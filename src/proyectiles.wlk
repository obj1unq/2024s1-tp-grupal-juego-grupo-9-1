import wollok.game.*
import direcciones.*
import nivel.*

/* estos proyectiles no tienen colicion con objetos pues no se como se haran obstaculos si hay 
  ni como sera la vida del heroe, en los assets esta un proyectil parte por si hace falta cambiar el tipo de daño
  y por ende hacer 2 tipos distintos de proyectiles*/
class Proyectil {
	var property direccion
	var property position
	const tipoProyectil
	const property danio
	const velocidad
	const property bando
	
	method image(){
		return "Proyectil_" + tipoProyectil.toString() + ".png"
	}
	method disparar(){
		self.position(self.direccion().siguiente(self.position()))
		game.addVisual(self)
		game.onTick(velocidad,"desplazarProyectil" + self.identity().toString(),{self.desplazar()})
	}
	
	method desplazar(){
		if (not escenario.estaDentro(self.position()))
		{
			self.desaparecer()
		}
		else{
		self.position(self.direccion().siguiente(self.position()))}
	}
	method desaparecer(){
		game.removeTickEvent("desplazarProyectil" + self.identity().toString())
		game.removeVisual(self)
	}
	
	method collision(cosa){
		if(cosa.bando() != self.bando()){
			cosa.recibirDanio(danio)
			self.desaparecer()			
		}
	}

	
	method esAtravesable() = true
}