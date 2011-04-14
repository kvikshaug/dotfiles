/**
 * Parses atom feed XML for gmail and prints a line showing:
 * XM Y: Z
 * Where:
 * X = The number of unread mails in the inbox
 * Y = The name of the most recent sender in the conversation
 * Z = The subject of the e-mail
 **/
import scala.xml.XML

object Filter {
  def main(args: Array[String]): Unit = {
    val xml = XML.load(args(0))
    val mailcount = (xml \ "entry").size
    if(mailcount > 0) {
      val author = ((xml \ "entry")(0) \ "author" \ "name").text
      val subject = ((xml \ "entry")(0) \ "title").text
      print(mailcount + "M " + author + ": " + subject + " | ")
    }
  }
}
