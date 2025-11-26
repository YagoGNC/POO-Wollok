class Personaje{
    var copas = 0

    method tieneEstrategia() 
    method destreza()
    method copas() = copas
    method modificarCopas(cantidad) {
        copas += cantidad
    }

}

class Arquero inherits Personaje{
    var rango = 0
    var agilidad = 0

    override method destreza() {
        return agilidad * rango
    }

    override method tieneEstrategia() {
        return rango > 100
    }
}
class Guerrera inherits Personaje{
    const property estrategia 
    var fuerza = 0

    override method destreza() {
        return fuerza * 1.5
    }

    override method tieneEstrategia() {
        return estrategia
    }
}
class Ballestero inherits Arquero{
    override method destreza() {
      return (agilidad*rango)*2
    }
}
class Mision{
    method puedeRealizarse(participantes)
    method esSuperadaPor(participantes)
    method ajustarCopas(participantes)
    
    method realizarse(participantes) {
        if(!self.puedeRealizarse(participantes)) {
            self.error("Misión no puede comenzar")
        }
        self.ajustarCopas(participantes)
    }
}
class MisionIndividual inherits Mision{
    const dificultadMision = 0
    override method puedeRealizarse(personaje) {
        return personaje.copas() >= 10
    }
    override method esSuperadaPor(personaje) {
        return personaje.tieneEstrategia() || personaje.destreza() > dificultadMision
    }
    
    override method ajustarCopas(personaje) {
        var copasEnJuego = self.calcularCopasEnJuego(personaje)
        if(self.esSuperadaPor(personaje)){
            personaje.modificarCopas(copasEnJuego)
        }else{
            personaje.modificarCopas(-copasEnJuego)
        }
    }

    method calcularCopasEnJuego(personaje) {
        return 2 * dificultadMision
    }
}
class MisionEquipo inherits Mision{
    override method puedeRealizarse(personajes) {
        return personajes.sum{p => p.copas()} >= 60
    }
    
    override method esSuperadaPor(personajes) {
        return self.masDeLaMitadConEstrategia(personajes) || 
               self.todosConMuchaDestreza(personajes)
    }
    method masDeLaMitadConEstrategia(personajes) {
        const cantidadConEstrategia = 
            personajes.count{p => p.tieneEstrategia()}
        return cantidadConEstrategia > personajes.size() / 2
    }
    method todosConMuchaDestreza(personajes) {
        return personajes.all{p => p.destreza() > 400}
    }
    override method ajustarCopas(personajes) {
        const copasEnJuego = self.calcularCopasEnJuego(personajes)
        if(self.esSuperadaPor(personajes)){
            personajes.forEach{p => p.modificarCopas(copasEnJuego)}
        } else {
            personajes.forEach{p => p.modificarCopas(-copasEnJuego)}
        }
    }
    method calcularCopasEnJuego(personajes) {
        return 50 / personajes.size()
    }
}
   
class MisionBoostIndividual inherits MisionIndividual{
    var multiplicador = 1
    
    override method calcularCopasEnJuego(personaje) {
        return super(personaje) * multiplicador // q hace super?
    }
}

//Cada una de las misiones Boost tiene un multiplicador que multiplica la cantidad de copas en juego
class MisionBoostEquipo inherits MisionEquipo{
   var multiplicador = 1
    
    override method calcularCopasEnJuego(personajes) {
        return super(personajes) * multiplicador
    }
}
//mientras que las misiones Bonus otorgan 1 copa más por cada participante de la misión
class MisionBonusIndividual inherits MisionIndividual{
    var copasExtraPorParticipante = 1
    
    override method calcularCopasEnJuego(personajes) {
        const copasExtraTotal = copasExtraPorParticipante * personajes.size()
        return super(personajes) + copasExtraTotal
    }
}

class MisionBonusEquipo inherits MisionEquipo{
    var copasExtraPorParticipante = 1
    override method ajustarCopas(personajes) {
        var cantidadParticipantes = personajes.length()
        var copasBase = 50 / cantidadParticipantes
        var copasExtraTotal = copasExtraPorParticipante * cantidadParticipantes
        var copasEnJuego = copasBase + copasExtraTotal

        if(self.esSuperadaPor(personajes)){
            personajes.forEach{personaje => personaje.modificarCopas(copasEnJuego)}
        }else{
            personajes.forEach{personaje=>personaje.modificarCopas(-copasEnJuego)}
        }
    }
}
