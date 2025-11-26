// Una línea tiene un número de teléfono, 
// y puede tener varios packs activos, 
// que sirven para que la línea pueda realizar consumos. 
// Por ahora Pdepfoni 
// permite hacer dos tipos de consumo:

//Conocer el costo promedio de todos los consumos 
//realizados dentro de un rango de fechas inicial y final. 
class linea {
    const numero
    var packs = []
    const consumosRealizados = []
    const precioPorSegundo = 0.05
    const precioFijo = 1
    const precioMb = 0.10

    method agregarPack(pack) {
      packs.add(pack)
    }
    method realizarConsumoInternet(mb) {
        const packDisponible = packs.find{pack => pack.puedeCubrirInternet(mb)}
        const costo = if(packDisponible != null){
            packDisponible.consumir(mb)
        }else{
            mb*precioMb
        }

        const consumo = new ConsumoInternet(
            fecha = new Date(),
            megabytes = mb,
            costo = costo
        )
        consumosRealizados.add(consumo)
    }
    method realizarConsumoLlamada(segundos) {
      const packDisponible = packs.find {pack => pack.puedeCubrirLlamada(segundos)}
        const costo = if(packDisponible != null){}else{
            self.calcularCostoLlamada(segundos)
        }
    
        const consumo = new ConsumoLlamadas(
            fecha = new Date(),
            segundos = segundos,
            costo = costo
        )
        consumosRealizados.add(consumo)    
    }
    method calcularCostoLlamada(segundos) {
        return if(segundos <= 30)
            precioFijo
            else
            precioFijo + (segundos - 30) * precioPorSegundo
        
    }
    method costoTotalUltimos30Dias() {
        return self.costoTotalUltimosDias(30)
    }
     method costoTotalUltimosDias(cantidadDias) {
        const fechaLimite = new Date().minusDays(cantidadDias)
        const fechaActual = new Date()
        
        return consumosRealizados
            .filter { consumo => consumo.estaEntre(fechaLimite, fechaActual) }
            .sum { consumo => consumo.costo() }
    }
    
    // Costo promedio en un rango de fechas
    method costoPromedioEntre(fechaInicial, fechaFinal) {
        const consumosEnRango = consumosRealizados.filter { consumo =>
            consumo.estaEntre(fechaInicial, fechaFinal)
        }
        
        if(consumosEnRango.isEmpty()) {
            return 0
        }
        
        const costoTotal = consumosEnRango.sum { consumo => consumo.costo() }
        return costoTotal / consumosEnRango.size()
    }
}
class Pack {
    const fechaVencimiento
    
    method estaVigente() {
        return new Date() <= fechaVencimiento
    }
    method puedeCubrirInternet(mb) = false
    method puedeCubrirLlamada(segundos) = false
    method consumir(mb) {} 
}
class PackCredito inherits Pack {
    var creditoDiponible 

    method puedeGastar(monto) {
        return self.estaVigente() && creditoDiponible >= monto
    }

    method gastar(monto) {
        creditoDiponible -= monto
    }
    
    override method puedeCubrirInternet(mb) {
        return self.puedeGastar(mb * 0.10)  // Calcula el costo
    }
    
    override method puedeCubrirLlamada(segundos) {
        const costo = if(segundos <= 30) 1 else 1 + (segundos - 30) * 0.05
        return self.puedeGastar(costo)
    }
    override method consumir(mb) {
        self.gastar(mb * 0.10)
    }

    // Y agregar un método para consumir llamadas
    method consumirLlamada(segundos) {
        const costo = if(segundos <= 30) 1 else 1 + (segundos - 30) * 0.05
        self.gastar(costo)
    }
}

class PackMB inherits Pack {
    var megabytesDisponibles

    override method puedeCubrirInternet(mb) {
    return self.estaVigente() && megabytesDisponibles >= mb
    }

    override method consumir(mb) {
        megabytesDisponibles -= mb
    }
}
class PackLlamadasGratis inherits Pack {
    override method puedeCubrirLlamada(segundos) {
        return self.estaVigente()
    }
}

class PackInternetIlimitadoFindes inherits Pack {
    override method puedeCubrirInternet(mb) {
        return self.estaVigente() && new Date().dayOfWeek().inRange(6,7)
    }  
}

class Consumo {
    const fecha 
    const costo 
    method costo() = costo

    method estaEntre(fechaInicial,fechaFinal) {
        return fecha.between(fechaInicial, fechaFinal)
    }
}

class ConsumoInternet inherits Consumo{
    const megabytes
}

class ConsumoLlamadas inherits Consumo {
    const segundos
}

