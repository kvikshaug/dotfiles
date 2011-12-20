import org.joda.time.format.{DateTimeFormat, DateTimeFormatter}
import org.joda.time.DateTime
import scala.actors.Actor
import scala.actors.Actor._
import scala.xml._

import java.text.NumberFormat

import Util._

case class MailString(value: String)
case class NetString(value: String)

object StatusBar {

  // seconds
  val sbSetterSleep = 1
  val mailFetcherSleep = 5 * 60
  val netAvgSleep = 1

  def startThread(actor: Actor, sleepTime: Int) = new Thread {
    override def run = while(true) {
      actor ! Unit
      Thread.sleep(sleepTime * 1000)
    }
  }.start

  def main(args: Array[String]) {
    sbSetter.start
    mailFetcher.start
    netAvg.start
    startThread(sbSetter, sbSetterSleep)
    startThread(mailFetcher, mailFetcherSleep)
    startThread(netAvg, netAvgSleep)
  }

  val sbSetter = actor {
    var mailStatus = ""
    var netUsage = "?RX/?TX"
    loop {
      receive {
        case s: MailString => mailStatus = s.value
        case s: NetString => netUsage = s.value
        case _ =>
          val statusBar = String.format("%s%s%s | %s | %s | %s/%s | %s | %s | %s", mailStatus, battery, audio, memUsage, diskUsage, loadAvg, cpuTemp, netUsage, netStatus, date)
          run(Array("xsetroot", "-name", statusBar))
      }
    }
  }

  /* MAIL */
  val mailFetcher = actor {
    loop {
      receive {
        case _ =>
          val credentials = lines("/home/murray/.dwmsb/.creds")
          val username = credentials.next
          val password = credentials.next
          try {
            var xml = XML.loadString(run(Array("wget", "-O", "-", "--user=" + username, "--password=" + password, "https://mail.google.com/mail/feed/atom")))
            val mailcount = (xml \ "entry").size
            if(mailcount > 0) {
              val author = ((xml \ "entry")(0) \ "author" \ "name").text
              val subject = ((xml \ "entry")(0) \ "title").text
              sbSetter ! MailString(mailcount + "M " + author + " | ")
            } else {
              sbSetter ! MailString("")
            }
          } catch {
            case e => sbSetter ! MailString("?M | ")
            e.printStackTrace
          }
      }
    }
  }

  /* NET USAGE */
  val netAvg = actor {
    val f = NumberFormat.getInstance
    f.setMinimumIntegerDigits(3)
    var lastrx = 0L
    var lasttx = 0L
    loop {
      receive {
        case _ =>
          try {
            val iface = if(ifaceUp("wlan0").isDefined) "wlan0"
                        else if(ifaceUp("eth0").isDefined) "eth0"
                        else "lo"
            val net = read("/proc/net/dev")
            val groups = (iface + """:\s+(\d+)\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+(\d+)""").r.findAllIn(net).matchData.next.subgroups
            val rx = groups(0).toLong
            val tx = groups(1).toLong
            sbSetter ! NetString(f.format(((rx - lastrx) / 1000).toInt) + "RX/" + f.format(((tx - lasttx) / 1000).toInt)   + "TX")
            lastrx = rx
            lasttx = tx
          } catch {
            case e =>
              sbSetter ! NetString("?RX/?TX")
          }
      }
    }
  }

  /* BATTERY */
  def battery = {
    val battery = read("/sys/class/power_supply/BAT0/uevent")
    val status = """POWER_SUPPLY_STATUS=(.*)""".r.findAllIn(battery).matchData.next.subgroups(0)
    if(status == "Charged") {
      ""
    } else {
      val energyNow = """POWER_SUPPLY_ENERGY_NOW=(\d+)""".r.findAllIn(battery).matchData.next.subgroups(0)
      val energyFull = """POWER_SUPPLY_ENERGY_FULL=(\d+)""".r.findAllIn(battery).matchData.next.subgroups(0)
      val pst = ((energyNow.toDouble / energyFull.toDouble) * 100).round
      val statusChar = status(0).toLower // 'd' or 'c' (for discharging or charging)
      String.format("%s%s | ", String.valueOf(pst), String.valueOf(statusChar))
    }
  }

  /* AUDIO VOLUME */
  def audio = {
    val audio = pickLine(run(Array("amixer")), 6)
    if("""\[off\]$""".r.findFirstIn(audio).isDefined) {
      "M"
    } else {
      'v' + """\[(\d+%)\]""".r.findAllIn(audio).matchData.next.subgroups(0)
    }
  }

  /* CPU TEMP */
  def cpuTemp = {
    val temp = pickLine(run(Array("sensors")), 3)
    """.*?\+(\d+)\.\d.*""".r.findAllIn(temp).matchData.next.subgroups(0)
  }

  /* MEM USAGE */
  def memUsage = {
    val mem = pickLine(run(Array("free", "-b")), 2)
    val r = """Mem:\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)""".r
    val list = r.findAllIn(mem).matchData.next.subgroups.map(_.toDouble)
    val pst = ((list(1) - (list(4) + list(5))) / list(0)) * 100
    'm' + String.valueOf(math.round(pst)) + "%"
  }

  /* DISK USAGE */
  def diskUsage = {
    val du = pickLine(run(Array("df", "-h", ".")), 2)
    val r = """.*?(\d+)G.*?(\d+)G.*""".r
    val list = r.findAllIn(du).matchData.next.subgroups
    String.format("%s/%s", list(1), list(0))
  }

  /* LOAD AVG */
  def loadAvg = """\d.\d\d \d.\d\d \d.\d\d""".r.findFirstIn(read("/proc/loadavg")).getOrElse("?.?? ?.?? ?.??")

  /* NETWORK STATUS */
  def netStatus = {
    // TODO Show whether wlan is disconnected, connected, or connecting
    // prioritize wlan0
    val wlan0 = ifaceUp("wlan0")
    val eth0 = ifaceUp("eth0")
    // TODO: wwan0 (mobile ip)
    wlan0.getOrElse(eth0.getOrElse("↓"))
  }

  def ifaceUp(iface: String) = iface match {
    case "wlan0" =>
      val essidline = run(Array("iwgetid"))
      if(!essidline.isEmpty) {
        Some("""ESSID:"(.*)"""".r.findAllIn(essidline).matchData.next.subgroups(0))
      } else {
        None
      }
    case "eth0" =>
      val ipLine = run(Array("ip", "addr", "show", "eth0"))
      val matcher = """inet ([0-9\.]+)""".r.findAllIn(ipLine).matchData
      if(!matcher.isEmpty) {
        Some(matcher.next.subgroups(0))
      } else {
        None
      }
  }

  /* DATE */
  val f = DateTimeFormat.forPattern("yyyy-MM-dd ww HH:mm")
  def date = f.print(new DateTime)
}
