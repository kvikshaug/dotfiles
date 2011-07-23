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
          val statusBar = String.format("%s%s%s | %s | %s | %s | %s | %s | %s", mailStatus, battery, cpuTemp, memUsage, diskUsage, loadAvg, netUsage, netStatus("wlan0", true), /*netStatus("eth0"),*/ date)
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
              sbSetter ! MailString(mailcount + "M " + author + ": " + subject + " | ")
            } else {
              sbSetter ! MailString("")
            }
          } catch {
            case e => sbSetter ! MailString("?M | ")
          }
      }
    }
  }

  /* NET */
  val netAvg = actor {
    val f = NumberFormat.getInstance
    f.setMinimumIntegerDigits(3)
    var lastrx = 0L
    var lasttx = 0L
    loop {
      receive {
        case _ =>
          val net = pickLine(read("/proc/net/dev"), 5)
          // TODO: don't hardcode wlan0
          val groups = """wlan0:\s+(\d+)\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+(\d+)""".r.findAllIn(net).matchData.next.subgroups
          val rx = groups(0).toLong
          val tx = groups(1).toLong
          sbSetter ! NetString(f.format(((rx - lastrx) / 1000).toInt) + "RX/" + f.format(((tx - lasttx) / 1000).toInt) + "TX")
          lastrx = rx
          lasttx = tx
      }
    }
  }

  /* BATTERY */
  def battery = {
    val battery = read("/proc/acpi/battery/BAT0/state")
    val capacity = """remaining capacity:\s+(\d+) mWh""".r.findAllIn(battery).matchData.next.subgroups(0)
    capacity
    if(""" discharging""".r.findFirstIn(battery).isDefined) {
      capacity + "d | "
    } else if(""" charging""".r.findFirstIn(battery).isDefined) {
      capacity + "c | "
    } else {
      ""
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
    String.valueOf(math.round(pst)) + "%"
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
  def netStatus(iface: String, wireless: Boolean = false) = {
    // TODO Show whether wlan is disconnected, connected, or connecting
    val ipLine = pickLine(run(Array("ifconfig", iface)), 2)
    val matcher = """inet addr:([0-9\.]+)""".r.findAllIn(ipLine).matchData
    val ip = if(matcher.hasNext) matcher.next.subgroups(0) else "↓"
    if(wireless) {
      val essidline = run(Array("iwgetid"))
      if(essidline isEmpty) {
        iface + ": " + ip + " @ ?"
      } else {
        val essidmatch = """ESSID:"(.*)"""".r
        val essid = essidmatch.findAllIn(essidline).matchData.next.subgroups(0)
        iface + /*": " + ip +*/ " @ " + essid
      }
    } else {
      iface + ": " + ip
    }
  }

  /* DATE */
  val f = DateTimeFormat.forPattern("yyyy-MM-dd ww HH:mm")
  def date = f.print(new DateTime)
}
