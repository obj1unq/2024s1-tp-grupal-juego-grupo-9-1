import wollok.game.*
import hero.*

//archivo suplemental de direcciones
object izquierda {
	
	method siguiente(posicion) {
		return posicion.left(1)	
	}
	
	method sufijo() {
		return "_Izquierda"
	}
	
	method opuesto() {
		return derecha
	}
}

object derecha {

	method siguiente(posicion) {
		return posicion.right(1)	
	}
	
	method sufijo() {
		return "_Derecha"
	}
	

	method opuesto() {
		return izquierda
	}
	
	
}

object arriba {

	method siguiente(posicion) {
		return posicion.up(1)	
	}
	
	method sufijo() {
		return "_Arriba"
	}
	
	method opuesto() {
		return abajo
	}
	
}

object abajo {

	method siguiente(posicion) {
		return posicion.down(1)	
	}
	
	method sufijo() {
		return "_Abajo"
	}

	method opuesto() {
		return arriba
	}
	
}
object direcciones{
	
	method esUnBorde(posicion) {
		return posicion.y() == 0 || posicion.y() == game.height() - 1 ||
			   posicion.x() == 0 || posicion.x() == game.width() - 1
	}
	method mirandoAlHeroe(position){
		return if (self.diferenciaXHero(position) > self.diferenciaYHero(position)) {
			self.direccionAMirarXH(position)}else{
				self.direccionAMirarYH(position)}
	}
	method diferenciaXHero(position){
		return (position.x() - (hero.position().x())).abs()
	}
	method diferenciaYHero(position){
		return (position.y() - (hero.position().y())).abs()
	}
	method direccionAMirarXH(position){
		return if (position.x() <= (hero.position().x())) derecha
		else izquierda
	}
	method direccionAMirarYH(position){
		return if (position.y() <= (hero.position().y())) arriba
		else abajo
	}
	
	method puedeIr(desde, direccion) {
		const aDondeVoy = direccion.siguiente(desde) 
		return not self.esUnBorde(aDondeVoy) && not self.hayObstaculo(aDondeVoy) 
	}
	
	method hayObstaculo(position) {
		const visuales = game.getObjectsIn(position)
		return visuales.any({visual => not visual.esAtravesable()})
	}
	
}
