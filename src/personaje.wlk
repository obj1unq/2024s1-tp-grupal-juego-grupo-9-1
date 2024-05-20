import wollok.game.*
import direcciones.*
import proyectiles.*
import randomizer.*
import hero.*
import nivel.*

class Enemigo {

	var property position
	var property direccion
	var property hp
	var property velocidadAtaque = null
	var property velocidadMovimiento
	const property danio
	const property bando = enemigo

	method image() {
		return direccion.toString().capitalize() + ".png"
	}

	method iniciar() {
		self.perseguirAHeroe()
	}

	method perseguirAHeroe()

	method mover()

	method recibirDanio(_danio) {
		hp -= _danio
		self.comprobarHp()
	}

	method comprobarHp() {
		if (hp == 0) self.enemyDerrotado()
	}

	method enemyDerrotado() {
		enemyManager.enemyDerrotado(self)
	}

	method collision(personaje) {
		personaje.recibirDanio(self.danioPorContacto())
		self.enemyDerrotado()
	}

	method danioPorContacto() = self.danio() / 2

	method esAtravesable() = false

}

class Manoplas inherits personaje.Enemigo {

	override method image() = "Manoplas_" + super()

	override method perseguirAHeroe() {
		game.onTick(self.velocidadMovimiento(), "Perseguir a heroe" + self.identity(), ({ self.mover()}))
	}

	override method mover() {
		self.direccion(direcciones.mirandoAlHeroe(self.position()))
		if (direcciones.puedeIr(self.position(), self.direccion())) {
			position = direccion.siguiente(self.position())
		}
	}

	override method enemyDerrotado() {
		game.removeTickEvent("Perseguir a heroe" + self.identity())
		super()
	}

}

class Octorok inherits personaje.Enemigo {

	var property moviendoA = [ derecha, arriba ].anyOne()

	override method image() = "Octorok_" + super()

	override method perseguirAHeroe() {
		game.onTick(self.velocidadMovimiento(), "encontrar y atacar" + self.identity(), ({ self.moverYDisparar()}))
	}

	method moverYDisparar() {
		self.mover()
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

	override method enemyDerrotado() {
		game.removeTickEvent("encontrar y atacar" + self.identity())
		super()
	}

	override method collision(personaje) {
		if (personaje == hero) {
			personaje.recibirDanio(self.danioPorContacto())
			self.enemyDerrotado()
		}
	}

}

object manoplas {

	method crearNuevo() {
		const manoplas = self.manoplas()
		game.addVisual(manoplas)
		manoplas.iniciar()
		game.onCollideDo(manoplas, { algo => algo.collision(manoplas)})
		return manoplas
	}

	method manoplas() {
		return new Manoplas(position = randomizer.emptyPosition(), direccion = derecha, hp = 10, velocidadMovimiento = 1000, danio = 10)
	}

}

object octorok {

	method crearNuevo() {
		const octorok = self.octorok()
		game.addVisual(octorok)
		octorok.iniciar()
		game.onCollideDo(octorok, { algo => algo.collision(octorok)})
		return octorok
	}

	method octorok() {
		return new Octorok(position = randomizer.emptyPosition(), direccion = derecha, hp = 10, velocidadMovimiento = 1000, velocidadAtaque = 1000, danio = 10)
	}
}

object enemyManager {

	const property enemigos = []
	const property enemigosDerrotados = []

	method crearEnemigo(enemigo) {
		if (enemigos.size() < 5) {
			enemigos.add(enemigo.crearNuevo())
		}
	}

	method enemyDerrotado(enemigo) {
		game.removeVisual(enemigo)
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

