class Empleado{
  var property cantidadSalud 
  var property habilidades = []
  var property saludCritica
   
  method estaIncapacitado() {
    return self.cantidadSalud() < self.saludCritica()
  }
  method poseeHabilidadIndicada(habilidad) {
    return habilidades.contains(habilidad)
  }
  method puedeUsarUnaHabilidad(empleado, habilidad) {
    return !self.estaIncapacitado() && self.poseeHabilidadIndicada(habilidad)
  }
  method recibirDanio(danio) {
    cantidadSalud -= danio
  }
  method completarMision(mision)
}
class Espia inherits Empleado{
  override method saludCritica() = 15
  override method completarMision(mision){
    mision.habilidadesRequeridas().forEach{habilidad => 
      if(!self.poseeHabilidadIndicada(habilidad)){
        habilidades.add(habilidad)
      }
    }
  }
}

class Oficinista inherits Empleado{ 
  var property cantidadEstrellas = 0
  method saludCritica() {
  return 40 - 5 * cantidadEstrellas
  } 
  override method completarMision(mision){
    self.ganarEstrella()
  }
  method ganarEstrella(){
    cantidadEstrellas += 1
    if (cantidadEstrellas == 3){
      //ni idea, se convierte
    }
  }
}
class Jefe inherits Empleado{
  var property subordinados = []
  override method poseeHabilidadIndicada(habilidad) {
    return subordinados.any {empleado => empleado.puedeUsarUnaHabilidad(habilidad)}
  }
}
class Mision {
  var property habilidadesRequeridas = [] 
  var property peligrosidad
  method cumplir(ejecutor) {
    if(!ejecutor.puedeRealizar(ejecutor)){
      console.println("No se puede realizar")
    }
    ejecutor.aplicarDanio()
    ejecutor.registrarCompletada(ejecutor)
  }
  method puedeRealizar(ejecutor)
  method aplicarDanio(ejecutor)
  method registrarCompletacion(ejecutor)
}

class MisionIndividual inherits Mision {
  override method puedeRealizar(empleado){
    return habilidadesRequeridas.all{
      habilidad =>
      empleado.puedeUsarHabilidad(habilidad)
    }
  }
  override method aplicarDanio(empleado){
    empleado.recibirDanio(peligrosidad)
  }
  override method registrarCompletacion(empleado) {
    if(empleado.cantidadSalud()>0){
      empleado.completarMision(self)
    }
  }
}
class MisionEnEquipo inherits Mision{
  override method puedeRealizar(equipos) {
    return habilidadesRequeridas.all{habilidad =>
    equipos.any{empleado=>empleado.puedeUsarUnaHabilidad(habilidad)}}
  }
  override method aplicarDanio(equipo) {
    equipo.forEach{empleado=>empleado.recibirDanio(peligrosidad/3)}
  }
}
