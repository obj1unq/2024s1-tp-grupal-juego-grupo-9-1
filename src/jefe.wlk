import wollok.game.*
import proyectiles.*
import randomizer.*
import direcciones.*
import hero.*
import personaje.*

/*comentarios : se supone que donde este el jefe no sea una zona que pueda atravezar el heroe, pues como ataca
 * hacia abajo solo, que no se pueda que el jugador se ponga al lado y ataque sin peligro
 * por eso no tiene colision, tampoco puse metodos de recibir daño pues no se como se diseñaran
 * los ataques del heroe, las partes deberian ser inmunes al daño pues es para aumentar dificultad
 al pasar a "la otra fase"*/
 
object jefe inherits Enemigo (danio = 10, position = game.at(7,9), direccion = derecha, hp = 40, velocidadAtaque = 500, velocidadMovimiento = 500,frames = 5) {

	var property cantidadEscudos = 3
	var aguanteEscudo = 90
	var property moviendoA = derecha
	const partes = []
	var property cadencia = 4000
	const property sonidoSepararParte ="Boss-Separar-Parte.mp3"


	override method iniciar() {
		self.activarMovimiento()
		self.activarAtaques()
	}
	
	method activarMovimiento() {
		game.onTick(self.velocidadMovimiento(), "Movimiento de boss", {self.mover()})
	}
	override method accion() = "Ataques Boss"

	method activarAtaques() {
		game.onTick(cadencia, self.accion(), { self.atacar()})
	}
	
	method atacar() {
		// Tanto los proyectiles del jefe y partes tienen atributos parametrizables.
		new Proyectil(
			direccion = abajo , 
			position = self.position(), 
			tipoProyectil = "Jefe", // Determina la imagen correspondiente al proyectil. Si se suman nuevas, fijarse nombres de archivos
			danio = 10,
			velocidad = self.velocidadAtaque(),
			bando = self.bando()
		).disparar()
	}

	method subirVelocidadProyectil(modificadorCadencia, modificadorVelocidad){
		// Incrementa la frecuencia y velocidad de los proyectiles
		game.removeTickEvent("Ataques Boss")	// Necesario desactivar para cambiar parametros
		self.velocidadAtaque(self.velocidadAtaque()- modificadorVelocidad) 
		cadencia -= modificadorCadencia
		self.activarAtaques()
	}
	
	
	method subirVelocidadMovimiento(velocidad){
		game.removeTickEvent("Movimiento de boss")
		self.velocidadMovimiento(self.velocidadMovimiento() - velocidad)
		self.activarMovimiento()
	}

	override method mover() {
		// este metodo supone toda la ventana como posible movimiento
		if (direcciones.esUnBorde(moviendoA.siguiente(self.position()) )) {
			self.moviendoA((self.moviendoA().opuesto()))
			self.position(self.moviendoA().siguiente(self.position()))
		} else {
			self.position(self.moviendoA().siguiente(self.position()))
		}
	}

	method separarParte() {
		const sonido = game.sound (self.sonidoSepararParte())
		// este si se agregan mas bordes que sean con objetos asi no aparece encima una parte
		// Cada vez que se separa una parte, se incrementa la velocidad y cadencia de proyectil de boss y partes por igual
		self.subirVelocidadProyectil(1100, 120)
		self.subirVelocidadMovimiento(100)
		const parte = new ParteBoss(position = randomizer.emptyPosition())
		sonido.play()
		parte.iniciar()
		partes.add(parte)
		managerAnimados.aniadirPersonajeAnimado(parte)
		game.onCollideDo(parte, { algo => algo.collision(parte)})
	}

	method escudos() {
		return if (self.cantidadEscudos() > 0) self.cantidadEscudos().toString() else "Vulnerable"
	}

	override method image() {
		return "boss_" + self.escudos() + "_" + self.frameActual() + ".png"
	}

	method removerEscudo() {
		if (cantidadEscudos > 0) cantidadEscudos -= 1
	}

	method aguanteEscudo() {
		return aguanteEscudo
	}

	override method recibirDanio(cantidad) {
		const sonido = game.sound(self.sonidoDanio())
		sonido.play()
		if (self.aguanteEscudo() > 0) {
			aguanteEscudo = (aguanteEscudo - cantidad).max(0)
			self.comprobarCantidadEscudos()
		} else {
			self.hp((self.hp() - cantidad).max(0))
			self.comprobarHp()
		}
	}

	method comprobarCantidadEscudos() {
		if (self.aguanteEscudo() <= (self.cantidadEscudos() - 1) * 30) {
			cantidadEscudos -= 1
			self.separarParte()
		}
	}
	
	override method enemyDerrotado() {
		partes.forEach({ parte => parte.eliminarse()})
		super()
	}
	
	override method esAtravesable() {
		return false
	}

	method crearNuevo() {
		return self
	}
}

class ParteBoss inherits Animado (frames = 5){

	var property direccionMirada = direcciones.mirandoAlHeroe(self.position())
	var property position
	const property sonidoImpacto = "Parte_NoRecibe_Daño.mp3"
	var teletransportandose = false
	
	method bando() = enemigo

	method iniciar() {
		game.addVisual(self)
		game.onTick(4000, "DispararParte" + self.identity().toString(), { self.disparar()})
	}

	method esAtravesable() {
		return false
	}
	method collision(personaje) {
		personaje.recibirDanio(5)
	}

	method image(){
	return if (not teletransportandose) {"Boss_Parte_"+ self.frameActual() + ".png"}
			else {"Boss_Parte_Teleport.png"}
	}
	
	method disparar() {
		direccionMirada = direcciones.mirandoAlHeroe(self.position())
		new Proyectil(
			direccion = direccionMirada , 
			position = self.position(), 
			tipoProyectil = "ParteBoss", 
			danio = 10,
			velocidad = jefe.velocidadAtaque(),
			bando = self.bando()
		).disparar()
		game.schedule(250,{self.teleportarse()})
	}
	
	method teleportarse(){
		teletransportandose = true
		game.schedule(250, {self.position(randomizer.emptyPosition())
							teletransportandose = false
		})
	}
	
	method recibirDanio(danio){
		const sonido =game.sound(self.sonidoImpacto())
		sonido.play()
	}

	method eliminarse() {
		managerAnimados.removerPersonajeAnimado(self)
		game.removeTickEvent("DispararParte" + self.identity().toString())
		game.removeVisual(self)
	}

}

