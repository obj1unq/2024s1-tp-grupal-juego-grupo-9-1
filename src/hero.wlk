import wollok.game.*
import proyectiles.*
import direcciones.*
import interfaz.*


object hero {

	var property position = game.at(1,1)
	var property direccion = abajo
	const property hp = managerVidaHeroe
	var property estado = vivo
	const property bando = self
	var puedeDisparar = true
	const property sonidoDanio = "Hero_Daniado.mp3"
	
	

	method image() {
		return "Hero_" + direccion.toString().capitalize() + "_" + estado.toString() + ".png"
	}

	method dispararHacia(_direccion) {
		if (self.puedeDisparar()){
		new Proyectil(
			direccion = _direccion, 
			position = self.position(), 
			tipoProyectil = self.toString() + "_" + _direccion.toString(), 
			danio = 10,
			velocidad = 300,
			bando = self
		).disparar()
		direccion = _direccion
		self.iniciarRecarga()
		estado = disparandoArco
		game.schedule(100, {self.volverALaNormalidad()})
		}
	}
	method puedeDisparar(){
		return puedeDisparar
	}
	method iniciarRecarga(){
		puedeDisparar = false
		game.schedule(350, {puedeDisparar = true})
	}
	method mover(_direccion) {
		if(self.puedeMover(_direccion)){
			direccion = _direccion
			position = direccion.siguiente(position)
			estado = moviendo
			game.schedule(100, {self.volverALaNormalidad()})			
		}
	}
	method volverALaNormalidad(){
		if(estado.puedeCambiarEstado()) estado = vivo
	}
	
	method validarMover(_direccion){
		if(not self.puedeMover(_direccion)){
			self.error("No puedo pasar")
		}
	}
	
	method puedeMover(_direccion){
		return estado.puedeMover() && direcciones.puedeIr(position,_direccion)
	}
	
	method recibirDanio(cantidad){
		hp.reducirVida(cantidad)
		self.sonidoDeRecibirDanio()
	}
	method sonidoDeRecibirDanio(){
		const sonido = game.sound(self.sonidoDanio())
		sonido.play()
	}
	
	method derrotado(){
		estado = derrotado
	 	direccion = abajo
		estado.activar()
	}
	
	method victoria(){
		estado = ganador
		direccion = abajo
		estado.activar()
	}
	
	method collision(objeto){}
	
	method esAtravesable() = true

}

class EstadoHeroe{
	const property puedeCambiarEstado = true
	const property puedeMover = true
	method activar(){}
}

object vivo inherits EstadoHeroe{
}
object disparandoArco inherits EstadoHeroe{
}
object moviendo inherits EstadoHeroe{
}

object derrotado inherits EstadoHeroe(puedeCambiarEstado = false, puedeMover = false){
	
	override method activar(){
		game.say(hero, "Me han derrotado!")
		game.schedule(2500, {game.stop()})
	}
}


object ganador inherits EstadoHeroe(puedeCambiarEstado = false, puedeMover = false){
	
	override method activar(){
		game.say(hero, "Victoria! He derrotado al jefazo!")
	}	
}