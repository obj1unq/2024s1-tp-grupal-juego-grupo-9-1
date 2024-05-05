import wollok.game.*
import proyectiles.*
import direcciones.*
object hero {
	var property position = game.center()
	var property direccion = abajo
	method image(){
		return "Hero_"+ direccion.toString().capitalize() +".png"
	}
	
	method dispararHacia(_direccion){
		new Proyectil(direccion = _direccion, position = self.position(), tipoProyectil = self.toString() + "_" + _direccion.toString()).disparar()		
	}
	
	method mirarHacia(_direccion){
		direccion = _direccion
	}
}
