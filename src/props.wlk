import wollok.game.*
import hero.*

class Invisible {
	
	var property position
	
	method esAtravesable(){
		return false
	}	
}

object muroInvisibleJefe{
	
	var contador = 1
	
	const property posiciones = []
	
	method llenarPosiciones(posicionY){
		if (contador < game.width()-1){
			posiciones.add(game.at(contador, posicionY))
			contador ++
			self.llenarPosiciones(posicionY)
		}
		
	}
	
	method crearBarreraAt(posicionY){
		self.llenarPosiciones(posicionY)
		posiciones.forEach({posicion => self.crearMuroAt(posicion)})		
	}
	
	method crearMuroAt(posicion) {
		const muroNuevo = new Invisible(position = posicion)
		game.addVisual(muroNuevo)
	}	
}
