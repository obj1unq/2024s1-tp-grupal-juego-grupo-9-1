import wollok.game.*
import hero.*

class Invisible {
	
	var property position
	
	method esAtravesable(){
		return false
	}	
}

object muroInvisible{
	
	var contador = 1
	
	const property direcciones = []
	
	method llenarDirecciones(posicionY){
		if (contador < game.width()-1){
			direcciones.add(game.at(contador, posicionY))
			contador ++
			self.llenarDirecciones(posicionY)
		}
		
	}
	
	method crearMuroInvisible(posicionY){
		self.llenarDirecciones(posicionY)
		direcciones.forEach({posicion => self.crearMuroAt(posicion)})		
	}
	
	method crearMuroAt(posicion) {
		const muroNuevo = new Invisible(position = posicion)
		game.addVisual(muroNuevo)
	}	
}
