import wollok.game.*
import direcciones.*
import proyectiles.*
import randomizer.*
import hero.*
import nivel.*

class Animado{
 var frameActual = 1
 const property frames
 
 method frameActual(){
 	return "frame" + frameActual.toString()
 }
 	
 method animar(){
 if (frameActual == self.frames()){
 		frameActual = 1
 	}
 else{
 	frameActual +=1
    }
  }
}

object managerAnimados{
	const personajesAnimados = #{}
	method aniadirPersonajeAnimado(personaje){
		personajesAnimados.add(personaje)
	}
	method removerPersonajeAnimado(personaje){
		personajesAnimados.remove(personaje)
	}
	method animarPersonajes(){
		personajesAnimados.forEach({personaje => personaje.animar()})
	}
}



class Enemigo inherits Animado{
 /*method accion(){
	 * 	if (estaElHeroeA(direccion)) ataca(direccion)
	 * 	else mover(direccion)}
	 */
	const property sonidoDanio = "Enemigo_Daniado.mp3"
	var property position
	var property direccion
	var property hp
	var property velocidadAtaque = null
	var property velocidadMovimiento
	const property danio
	
	method bando(){
		return enemigo
	}

	method image() {
		return direccion.toString().capitalize() + "_" + self.frameActual() + ".png"
	}
	//

	method iniciar(){
		game.onTick(self.velocidadMovimiento(), self.accion(), {self.activar()})
	}
	method accion()

	method mover()
	
	method activar(){self.mover()}

	method recibirDanio(_danio) {
		const sonido = game.sound(self.sonidoDanio())
		hp -= _danio
		sonido.play()
		self.comprobarHp()
	}

	method comprobarHp() {
		if (hp == 0) self.enemyDerrotado()
	}

	method enemyDerrotado() {
		game.removeTickEvent(self.accion())
		enemyManager.enemyDerrotado(self)
	}

	method collision(personaje) {
		personaje.recibirDanio(self.danioPorContacto())
		self.enemyDerrotado()
	}

	method danioPorContacto() = self.danio() / 2

	method esAtravesable() = false

}

class Manoplas inherits Enemigo (frames = 3) {


	override method image() = "Manoplas_" + super() 

	override method accion() = "Perseguir a heroe" + self.identity()

	override method mover() {
		self.direccion(direcciones.mirandoAlHeroe(self.position()))
		if (direcciones.puedeIr(self.position(), self.direccion())) {
			position = direccion.siguiente(self.position())
		}
	}

}

class Octorok inherits Enemigo {

	var property moviendoA

	override method image() = "Octorok_" + super()

	override method accion() = "Encontrar y atacar" + self.identity()

	override method activar() {
		super()
		self.disparar()
	}

	override method mover() {
		if (not direcciones.puedeIr(self.position(), moviendoA)) {
			self.girarBicho()
		}
		self.direccion(self.moviendoA())
		self.position(self.moviendoA().siguiente(self.position()))
	}

	method girarBicho() {
		self.moviendoA((self.moviendoA().opuesto()))
	}

	method disparar() {
		if (self.sePuedeDispararAHero()) {
			direccion = direcciones.mirandoAlHeroe(self.position())
				// hay que cambiar
			new Proyectil(
			direccion = self.direccion() , 
			position = self.position(), 
			tipoProyectil = "Octorok", // Determina la imagen correspondiente al proyectil. Si se suman nuevas, fijarse nombres de archivos
			danio = self.danio(),
			velocidad = self.velocidadAtaque(),
			bando = self.bando()
		).disparar()
		}
	}

	method sePuedeDispararAHero() {
		return self.position().x() == hero.position().x() or self.position().y() == hero.position().y()
	}

	override method collision(personaje) {
		if (personaje.bando() != self.bando()) {
			personaje.recibirDanio(self.danioPorContacto())
			self.enemyDerrotado()
		}
	}

}

object manoplas {

	method crearNuevo() {
		return new Manoplas(position = randomizer.emptyPosition(), direccion = derecha, hp = 10, velocidadMovimiento = 1000, danio = 10)
	}

}

object octorok {

	method crearNuevo() {
		return new Octorok(position = randomizer.emptyPosition(), direccion = derecha, hp = 10, moviendoA = [ derecha, arriba ].anyOne(), velocidadMovimiento = 1000, velocidadAtaque = 1000, danio = 10,frames = 2)
	}
}

object enemyManager {

	const property enemigos = []
	const property enemigosDerrotados = []

	method crearEnemigo(enemigo) {
		if (enemigos.size() < 5) {
			const enemigoGenerado = enemigo.crearNuevo()
			game.addVisual(enemigoGenerado)
			managerAnimados.aniadirPersonajeAnimado(enemigoGenerado)
			enemigoGenerado.iniciar()
			game.onCollideDo(enemigoGenerado, { algo => algo.collision(enemigoGenerado)})
		}
	}

	method enemyDerrotado(enemigo) {
		game.removeVisual(enemigo)
		managerAnimados.removerPersonajeAnimado(enemigo)
		enemigos.remove(enemigo)
		enemigosDerrotados.add(enemigo)
		self.chequearVictoria()
	}
	
	method chequearVictoria(){
		if(enemigosDerrotados.size() == escenario.nivel().totalEnemigos()){
			escenario.nivelCompletado()
		}
	}
	
	method resetearContador(){
		enemigosDerrotados.clear()
	}

}

object enemigo{}

