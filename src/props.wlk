import wollok.game.*
import hero.*

class Invisible {
	
	var property position
	
	method image() = "Boss_Parte.png"
	
	method esAtravesable(){
		return false
	}	
	
	method collision(personaje){
		game.say(self, "Atravesaste el muro")
	}
}

object muroInvisible{
	
	var contador = 0
	
	const property direcciones = []
	
	method llenarDirecciones(){
		if (contador < game.width()){
			direcciones.add(game.at(contador, game.height()-3))
			contador ++
			self.llenarDirecciones()
		}
		
	}
	
	method crearMuroInvisible(){
		self.llenarDirecciones()
		direcciones.forEach({posicion => self.crearMuroAt(posicion)})		
	}
	
	method crearMuroAt(posicion) {
		const muroNuevo = new Invisible(position = posicion)
		game.addVisual(muroNuevo)
	}
	
}
