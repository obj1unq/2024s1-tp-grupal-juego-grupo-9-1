import wollok.game.*
import hero.*
import direcciones.*
import personaje.*
import jefe.*
import props.*
import randomizer.*
import interfaz.*

class LugarConMusica{
	const property soundtrack
	method empezarMusica(){
		self.soundtrack().shouldLoop(true)
		self.soundtrack().play()
	}
	method detenerMusica(){
		self.soundtrack().stop()
	}
}
object titulo inherits LugarConMusica (soundtrack = game.sound("Title.mp3")){
	const siguienteParte = instrucciones
	const property sonidoAvanzar = game.sound("Menu_Avanzar.mp3")
	method position() = game.origin()
	method image(){
		return "titulo.png"
	}
	method iniciar(){
		game.addVisual(self)
		self.empezarMusica()
		keyboard.any().onPressDo({
			self.siguientePantalla()
			if (not self.sonidoAvanzar().played())self.sonidoAvanzar().play()
		})
	}
	method siguientePantalla(){
		self.detenerMusica()
		game.removeVisual(self)
		game.clear()
		siguienteParte.iniciar()
	}
	override method empezarMusica(){
		game.schedule(1000, {super()})
	}
}

object instrucciones inherits LugarConMusica(soundtrack = game.sound("Instrucciones.mp3")){
	const property administradorDeNiveles = escenario
	method image(){
		return "instrucciones.png"
	}
	method position() = game.origin()
	method iniciar(){
		game.addVisual(self)
		self.empezarMusica()
		game.schedule(4000, {self.avanzarAlNivel()})
	}
	method avanzarAlNivel(){
		game.removeVisual(self)
		self.detenerMusica()
		game.clear()
		self.administradorDeNiveles().init()
	}
}



class Nivel inherits LugarConMusica (soundtrack =game.sound("Castillo.mp3")){
	const property bordesEscenario = []
	
	method image()
	
	method totalEnemigos()
	
	method iniciar(){
		self.iniciarAnimaciones()
		self.empezarMusica()	
		game.onTick(5000, "Aparece enemigo", {enemyManager.crearEnemigo(self.enemigo())})
	}
	method iniciarAnimaciones(){
		game.onTick(350, "Animar personajes", {managerAnimados.animarPersonajes()})
	}
	method position() = game.origin()
	
	method enemigo()
}

class Cuadrante {

	const property bordeXInicial
	const property bordeXFinal
	const property bordeYInicial
	const property bordeYFinal

	method estaDentro(position) {
		return position.y().between(bordeYInicial, bordeYFinal) && position.x().between(bordeXInicial, bordeXFinal)
	}

}

object escenario {
	
	const property niveles = [nivel1,nivel2,nivel3]
	var nivelActual = 1
	
	method nivel() = niveles.get(nivelActual-1)
	
		method estaDentro(position) {
			return self.nivel().bordesEscenario().any({ cuadrante => cuadrante.estaDentro(position) })
	}
	
	method pasarDeNivel(){
		const corazonesHeroe = hero.hp().corazones()
		enemyManager.resetearContador()
		if (nivelActual < niveles.size()){
			self.nivel().detenerMusica()
			game.removeVisual(self.nivel())
			nivelActual ++
			game.clear()
			hero.estado(vivo)
			hero.position(game.at(1,1))
			hero.hp().corazones(corazonesHeroe)
			self.init()		
		} else{
			game.say(hero, "Juego completado! Felicitaciones!")
			game.schedule(1500, {game.stop()})
		}
	}
	
	method init(){

		game.addVisual(self.nivel())
		game.addVisual(hero)
		hero.hp().iniciar()
		hero.iniciarRecarga()
		
		// ACCIONES DE HERO
		keyboard.w().onPressDo({hero.mover(arriba)})
		keyboard.d().onPressDo({hero.mover(derecha)})
		keyboard.a().onPressDo({hero.mover(izquierda)})
		keyboard.s().onPressDo({hero.mover(abajo)})
		keyboard.left().onPressDo({hero.dispararHacia(izquierda)})
		keyboard.up().onPressDo({hero.dispararHacia(arriba)})
		keyboard.right().onPressDo({hero.dispararHacia(derecha)})
		keyboard.down().onPressDo({hero.dispararHacia(abajo)})
		game.onCollideDo(hero, { algo => algo.collision(hero) })
		self.nivel().iniciar()
		
		
		
	}
	
	method nivelCompletado(){
		hero.victoria()
		game.schedule(2000, {self.pasarDeNivel()})
		
	}

}

object nivel1 inherits Nivel {
			
			override method totalEnemigos() = 1
			
			override method bordesEscenario() = [cuadranteFactory.nuevo(1,9,1,5) , cuadranteFactory.nuevo(1,4,6,9), cuadranteFactory.nuevo(5,7,8,9), cuadranteFactory.nuevo(8,13,5,9)]
			
			override method enemigo() = manoplas
			
			override method image() = "Level_1_Zeldum.png"
}

object nivel2 inherits Nivel {
			
			override method totalEnemigos() = 1
						
			override method bordesEscenario() = [cuadranteFactory.nuevo(1,7,1,5) , cuadranteFactory.nuevo(8,13,1,8)]
			
			override method enemigo() = [manoplas, octorok].anyOne()
			
			override method image() = "Level_2_Zeldum.png"
			
}

object nivel3 inherits Nivel (soundtrack = game.sound("Boss.mp3")){
		
			override method totalEnemigos() = 1
						
			override method bordesEscenario() = [cuadranteFactory.nuevo(1, game.width()-2, 1, game.height()-4)]
			
			override method enemigo() = jefe
			
			override method iniciar(){
				self.empezarMusica()
				muroInvisibleJefe.crearBarreraAt(game.height()-4)
				self.iniciarAnimaciones()
				game.schedule(1000, {enemyManager.crearEnemigo(self.enemigo())})
			}
			
			override method image() = "Level_3_Zeldum.png"
}

object cuadranteFactory {

	method nuevo(_bordeXInicial, _bordeXFinal, _bordeYInicial, _bordeYFinal) {
		return new Cuadrante(bordeXInicial = _bordeXInicial, bordeXFinal = _bordeXFinal, bordeYInicial = _bordeYInicial, bordeYFinal = _bordeYFinal)
	}

}

