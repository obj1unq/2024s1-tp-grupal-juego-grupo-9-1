import wollok.game.*
import hero.*
import randomizer.*
import direcciones.*
import proyectiles.*

class Enemigo {

	// Wallmaster persigue y daña por contacto
	var property position = randomizer.emptyPosition()
	var property apuntando = derecha
	var aguante = 3

	method image() {
		return "Enemigo_" + apuntando.toString().capitalize() + ".png"
	}

	method iniciar() {
		self.perseguirAHeroe()
	}

	method perseguirAHeroe() {
		game.onTick(1000, "Perseguir a heroe", ({ self.mover()}))
	}

	method mover() {
		self.apuntando(direcciones.mirandoAlHeroe(self.position()))
		position = apuntando.siguiente(self.position())
	}

	method recibirDanio() {
		aguante -= 1
		self.comprobarAguante()
	}

	method comprobarAguante() {
		if (aguante == 0) self.serDerrotado()
	}

	method serDerrotado() {
		game.removeTickEvent("Perseguir a heroe")
		game.removeVisual(self)
	}

	method colision(personaje) {
		personaje.recibirDanio(self.danioPorContacto())
	}

	method danioPorContacto() {
		// ver cuanto daño 
		return 1
	}

}

class Octorok {

	var property position = randomizer.emptyPosition()
	var property apuntando = derecha
	var property moviendoA = [ derecha, arriba ].anyOne()
	var aguante = 10

	method image() {
		return "octorok_" + apuntando.toString() + ".png"
	}

	method iniciar() {
		self.encontrarYAtacarHero()
	}

	method encontrarYAtacarHero() {
		game.onTick(500, "encontrar y atacar", ({ self.moverYDisparar()}))
	}

	method moverYDisparar() {
		self.mover()
		self.disparar()
	}
	
	method mover() {
		if (direcciones.esUnBorde(self.position())) {
			self.moviendoA((self.moviendoA().opuesto()))
		}
		self.apuntando(self.moviendoA())
		self.position(self.moviendoA().siguiente(self.position()))		
	}

	method disparar() {
		if (self.sePuedeDispararAHero()) {
			apuntando = direcciones.mirandoAlHeroe(self.position())
			//hay que cambiar
			new ProyectilBoss(direccion = apuntando, 
							  position = self.position()).disparar()
		}
	}

	method sePuedeDispararAHero() {
		return self.position().x() == hero.position().x() or self.position().y() == hero.position().y()
	}

	method recibirDanio(cantidad) {
		aguante = (aguante - cantidad).max(0)
		self.comprobarAguante()
	}

	method comprobarAguante() {
		if (aguante == 0) self.serDerrotado()
	}

	method serDerrotado() {
		game.removeTickEvent("ENCONTRAR AL HEROE")
		game.removeVisual(self)
	}

	method colision(personaje) {
		personaje.recibirDanio(self.danioPorContacto())
	}

	method danioPorContacto() {
		// ver cuanto daño 
		return 1
	}

}

