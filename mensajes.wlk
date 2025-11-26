import telefonia.*
class Mensaje {
    const transferencia = 5
    const factorDeRed = 1.3
    method enviado() = false
    method pesoNeto() {
      return 0
    }
    method pesoMensaje(){
        return transferencia + (self.pesoNeto() * factorDeRed)
    }
    
}
class Texto inherits Mensaje{
    const property pesoCaracter = 1
    var property cadenaCaracteres = ""
    override method pesoNeto() {
        return cadenaCaracteres.length() * pesoCaracter
    }
}
class Audio inherits Mensaje{
    var property duracion = 0
    const pesoDeAudioXSegundo = 1.2
    override method pesoNeto(){
        return (duracion * pesoDeAudioXSegundo)
    }
}
class Imagen inherits Mensaje{
    const pesoXPixel = 2
    const tamanioMaximo = 10000
    var property alto = 0
    var property ancho = 0
    var property modoCompresion 
    method pixelesOriginales() {
      return alto * ancho
    }
    override method pesoNeto() {
        return self.modoCompresion() * pesoXPixel
    }
    method compresionOriginal() {
        self.modoCompresion({self.pixelesOriginales()})
    }
    method compresionVariable(porcentaje) {
        self.modoCompresion({(porcentaje*self.pixelesOriginales())/100})
    }
    method compresionMaxima() {
        self.modoCompresion({ 
            if(self.pixelesOriginales()>tamanioMaximo){
                return tamanioMaximo
            }else{
                return self.pixelesOriginales()
            }
        })
    }
    
}
class Gif inherits Imagen{
    var property cantCuadros = 1
    override method pesoNeto() {
        return super() * cantCuadros
    } 
}
class Contacto inherits Mensaje{
    const pesoXContacto = 3
    override method pesoNeto() = pesoXContacto
}

class Chat {
    var property miembros = []
    var property mensajes = []
    method esParticipante(usuarioReceptor) {
        return (miembros.any{p => p == usuarioReceptor})
    }
    method hayMemoriaSuficiente(unMensaje) {
        const peso = unMensaje.pesoMensaje()
        return miembros.all{p=>p.tieneEspacioPara(peso)}
    }
    method enviarMensaje(usuarioEmisor, unMensaje) {
        
        if(!self.esParticipante(usuarioEmisor)){
            console.println("El emisor debe ser un participante del chat.")
        }
        if(!self.hayMemoriaSuficiente(unMensaje)){
            console.println("No hay memoria libre en todos los participantes.")
        }
        miembros.forEach { p => p.almacenar(unMensaje.pesoMensaje()) }
        mensajes.add(unMensaje)
    }
}
class Usuario {
    var property memoriaLibre = 1024
    method almacenar(peso) {
        self.memoriaLibre(self.memoriaLibre() - peso) 
    }
    method enviarMensaje(Usuario) {
      return Usuario
    }
}
class ChatPremiun inherits Chat{
    
}