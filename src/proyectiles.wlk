import wollok.game.*
import direcciones.*

/* estos proyectiles no tienen colicion con objetos pues no se como se haran obstaculos si hay 
  ni como sera la vida del heroe, en los assets esta un proyectil parte por si hace falta cambiar el tipo de daño
  y por ende hacer 2 tipos distintos de proyectiles*/
class ProyectilBoss {
	var property direccion
	var property position
	
	method image(){
		return "Proyectil_Boss.png"
	}
	method disparar(){
		self.position(self.direccion().siguiente(self.position()))
		game.addVisual(self)
		game.onTick(500,"desplazarProyectil" + self.identity().toString(),{self.desplazar()})
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
}
