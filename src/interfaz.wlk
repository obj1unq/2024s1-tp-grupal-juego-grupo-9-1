import hero.*
import wollok.game.*


object managerVidaHeroe {
	const corazones = []
	const heroe = hero
	
	method corazonActual(){
		return corazones.find({corazon => corazon.estaVivo()})
	}
	method tieneVida(){
		return corazones.any({corazon => corazon.estaVivo()})
	}
	method iniciar(){
		self.generarCorazones(3)
		corazones.forEach({corazon => game.addVisual(corazon)})
	}
	method generarCorazones(cantidad){
		(1 .. cantidad).forEach({numero => corazones.add(new CorazonVida(position = game.at(numero,0)))})
		corazones.sortBy({corazon1, corazon2 => corazon1.position().x() > corazon2.position().x()})
	}
	method reducirVida(cantidad){
		self.corazonActual().reducirVida(cantidad)
		self.verificarDerrota()
	}
	method verificarDerrota(){
		if (not self.tieneVida()) heroe.derrotado()
	}
	
}

class CorazonVida{
	const property position
	var property cantidadVida = 20
	
	method image(){
		return "corazon_" + cantidadVida.toString() + ".png"
	}
	method reducirVida(cantidad){
		cantidadVida = (cantidadVida - cantidad.max(0).min(5)).max(0)
	}
	method estaVacio(){
		return cantidadVida == 0
	}
	method estaVivo(){
		return cantidadVida > 0
	}
	
	
	
}