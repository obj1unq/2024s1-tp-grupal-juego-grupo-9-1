import wollok.game.*
import proyectiles.*
import direcciones.*

object hero {

	var property position = game.center()
	var property direccion = abajo

	method image() {
		return "Hero_" + direccion.toString().capitalize() + ".png"
	}

	method dispararHacia(_direccion) {
		new Proyectil(
			direccion = _direccion, 
			position = self.position(), 
			tipoProyectil = self.toString() + "_" + 
			_direccion.toString(), danio = 10
		).disparar()
	}

	method mover(_direccion) {
		self.validarMover(_direccion)
		direccion = _direccion
		position = direccion.siguiente(position)
	}
	
	method validarMover(_direccion){
		if(not self.puedeMover(_direccion)){
			self.error("No puedo pasar")
		}
	}
	
	method puedeMover(_direccion){
		return direcciones.puedeIr(position,_direccion)
	}

}

