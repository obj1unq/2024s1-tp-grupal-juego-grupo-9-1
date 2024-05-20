import wollok.game.*
import proyectiles.*
import direcciones.*
import interfaz.*


object hero {

	var property position = game.at(1,1)
	var property direccion = abajo
	var property hp = managerVidaHeroe
	var property estado = vivo
	const property bando = self

	method image() {
		return "Hero_" + direccion.toString().capitalize() + "_" + estado.toString() + ".png"
	}
	method hp(){
		return hp
	}

	method dispararHacia(_direccion) {
		new Proyectil(
			direccion = _direccion, 
			position = self.position(), 
			tipoProyectil = self.toString() + "_" + _direccion.toString(), 
			danio = 10,
			velocidad = 300,
			bando = self
		).disparar()
	}

	method mover(_direccion) {
		if(self.puedeMover(_direccion)){
			direccion = _direccion
			position = direccion.siguiente(position)			
		}
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

object vivo{
	
	method puedeMover() = true
	
	method activar(){}
}

object derrotado{
	
	method puedeMover() = false
	
	method activar(){
		game.say(hero, "Me han derrotado!")
		game.schedule(2500, {game.stop()})
	}
}


object ganador{
	
	method puedeMover() = false
	
	method activar(){
		game.say(hero, "Victoria! He derrotado al jefazo!")
	}	
}