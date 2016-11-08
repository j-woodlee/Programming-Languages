import scala.language.implicitConversions

val x = 5
println (x + "7")

class Num (val i : Int) {

  def + (other : Num) = new Num(this.i + other.i)
  override def toString : String = i.toString

}

implicit def toNum(s : String) = new Num(s.toInt)
val y = new Num(5)
println (y + "7")
