import wollok.game.*
import hero.*
import direcciones.*
import personaje.*
import jefe.*
import props.*
import randomizer.*
import interfaz.*

class Nivel {

	const property bordesEscenario = []
	
	method image()
	
	method totalEnemigos()
	
	method iniciar(){
		self.iniciarAnimaciones()
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
		enemyManager.resetearContador()
		if (nivelActual < niveles.size()){
			game.removeVisual(self.nivel())
			nivelActual ++
			game.clear()
			hero.estado(vivo)
			hero.position(randomizer.emptyPosition())
			self.init()		
		} else{
			game.say(hero, "Juego completado! Felicitaciones!")
			game.schedule(1500, {game.stop()})
		}
	}
	
	method init(){

		game.addVisual(self.nivel())
		game.addVisual(hero)
		managerVidaHeroe.iniciar()
		
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

object nivel3 inherits Nivel {
		
			override method totalEnemigos() = 1
						
			override method bordesEscenario() = [cuadranteFactory.nuevo(1, game.width()-2, 1, game.height()-4)]
			
			override method enemigo() = jefe
			
			override method iniciar(){
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

