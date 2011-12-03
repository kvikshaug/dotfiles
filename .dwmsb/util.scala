import java.io._

object Util {
  def read(f: String) = scala.io.Source.fromFile(f).mkString
  def lines(f: String) = scala.io.Source.fromFile(f).getLines

  def run(c: Array[String]) = {
    val p = Runtime.getRuntime.exec(c)
    val in = new BufferedReader(new InputStreamReader(p.getInputStream))

    val sb = new StringBuilder
    def readAll(r: BufferedReader): Unit = r.readLine match {
      case null => return
      case s: String => sb.append(s).append("\n"); readAll(r)
    }
    readAll(in)
    in.close
    p.getErrorStream.close
    p.getOutputStream.close
    sb.toString
  }

  def pickLine(s: String, n: Int, i: Int = 0): String = n match {
    case 1 => try {
      s.substring(i, s.indexOf('\n', i))
    } catch {
      case e => s.substring(s.lastIndexOf('\n') + 1, s.length)
    }
    case n => pickLine(s, n - 1, s.indexOf('\n', i) + 1)
  }

}