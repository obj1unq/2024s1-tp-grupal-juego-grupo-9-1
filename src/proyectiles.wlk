import wollok.game.*
import direcciones.*

/* estos proyectiles no tienen colicion con objetos pues no se como se haran obstaculos si hay 
  ni como sera la vida del heroe, en los assets esta un proyectil parte por si hace falta cambiar el tipo de daño
  y por ende hacer 2 tipos distintos de proyectiles*/
class Proyectil {
	var property direccion
	var property position
	var property tipoProyectil
	var property danio
	var property velocidad
	
	method image(){
		return "Proyectil_" + tipoProyectil.toString() + ".png"
	}
	method disparar(){
		self.position(self.direccion().siguiente(self.position()))
		game.addVisual(self)
		game.onTick(velocidad,"desplazarProyectil" + self.identity().toString(),{self.desplazar()})
	}
	
	method desplazar(){
		if (direcciones.esUnBorde(self.position())){
			self.desaparecer()
		}
		else{
		self.position(self.direccion().siguiente(self.position()))}
	}
	method desaparecer(){
		game.removeTickEvent("desplazarProyectil" + self.identity().toString())
		game.removeVisual(self)
	}
	
	method collision(personaje){
		personaje.recibirDanio(danio)
		self.desaparecer()
	}
	
	method esAtravesable() = true
}