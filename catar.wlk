class Entrada {
    method cantidadAzucar() = 0
    method esBonito() = true
}

class Principal {
    var property cantidadAzucar = 0
    var property esBonito = false
}

class Postre {
    var property colores = 0
    method cantidadAzucar() = 120
    method esBonito() = colores > 3
}
class Cocinero {
    method conocerCalorias(plato) {
        return 3 * plato.cantidadAzucar() + 100
    }
    
    method catarUnPlato(plato) {
        return 0
    }
    
    method crearUnPlato() {
        return new Principal()  // Por defecto crea un principal vacío
    }
    
    method participarEn(torneo) {
        const plato = self.crearUnPlato()
        torneo.recibirPlato(plato)
    }
}
class Pastelero inherits Cocinero {
    const nivelDeDulzorDeseado
    
    override method catarUnPlato(plato) {
        return (5 * plato.cantidadAzucar() / nivelDeDulzorDeseado).min(10)
    }
    
    override method crearUnPlato() {
        return new Postre(colores = nivelDeDulzorDeseado / 50)
    }
}
class Chef inherits Cocinero {
    const caloriasPreferidas
    
    override method catarUnPlato(plato) {
        if (plato.esBonito() && self.conocerCalorias(plato) <= caloriasPreferidas) {
            return 10
        } else {
            return 0
        }
    }
    
    override method crearUnPlato() {
        return new Principal(
            cantidadAzucar = caloriasPreferidas,
            esBonito = true
        )
    }
}
class Souschef inherits Chef {
    override method catarUnPlato(plato) {
        if (plato.esBonito() && self.conocerCalorias(plato) <= caloriasPreferidas) {
            return 10
        } else {
            return (self.conocerCalorias(plato) / 100).min(6)
        }
    }
    override method crearUnPlato() {
        return new Entrada()
    }
}
class Torneo {
    const catadores = []
    const platos = []
    
    method recibirPlato(plato) {
        platos.add(plato)
    }
    
    method puntuacionDe(plato) {
        return catadores.sum { catador => catador.catarUnPlato(plato) }
    }
    
    method ganador() {
        if (platos.isEmpty()) {
            self.error("No hay platos en el torneo")
        }
        return platos.max { plato => self.puntuacionDe(plato) }
    }
}

//Queda pendiente ver los tests