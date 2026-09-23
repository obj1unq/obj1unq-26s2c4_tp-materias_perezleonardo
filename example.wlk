class Carrera{
  const materias = []
  method materias(){
    return materias
  }
  method planDeEstudios(listaDeMaterias) {
    materias.addAll(listaDeMaterias)
  }

}

class Materia {
  const property carrera
  const property requisitos = []
  const inscriptos = [] 
  const property cupo = 10
  const listaDeEspera = [] 

  method inscribir(alumno){
    if (self.cupoDisponible()) inscriptos.add(alumno)
    else listaDeEspera.add(alumno) 
  }

  method cupoDisponible(){
    return inscriptos.size() < cupo
  } 

  method baja(alumno) {
    inscriptos.remove(alumno)
    if (not listaDeEspera.isEmpty()) self.promover(alumno)
      
  }

  method promover(alumno){
    inscriptos.add(listaDeEspera.first())
    listaDeEspera.remove(listaDeEspera.first())
  }

  method inscriptos(){
    return inscriptos
  } 

  method listaDeEspera(){
    return listaDeEspera
  } 

  method estaInscripto(alumno){
    return inscriptos.contains(alumno)
  }

  method estaEnListaDeEspera(alumno){
    return listaDeEspera.contains(alumno)
  }
}

class Aprobacion {
  const property materia
  const property nota 
}

class Alumno{
  const carreras = [] 
  const materiasAprobadas = []

  method registrarAprobada(materia,nota){
    if (self.estaAprobada(materia)) self.error("La materia se encuentra aprobada")
    else materiasAprobadas.add(new Aprobacion(materia = materia, nota = nota))
  }
  method estaAprobada(materia){
    return materiasAprobadas.any({aprobada => aprobada.materia() == materia})
  }
  method cantidadAprobadas(){
    return materiasAprobadas.size()
  }

  method promedioNotas(){
    return if (materiasAprobadas.isEmpty()) 0
    else materiasAprobadas.map({aprobada => aprobada.nota()}).average()
  } 

  method materiasDeCarreras(){
    return carreras.flatMap({carrera => carrera.materias()})
  } 

  method puedeAnotarseA(materia){
    return self.materiasDeCarreras().contains(materia) && 
    (not self.estaAprobada(materia)) &&
    (not materia.inscriptos().contains(self)) &&
    (materia.requisitos().all({ requisito => self.estaAprobada(requisito)}))
    
  }

  //Está horrible, pero no se me ocurre algo mejor
  method materiasInscripto(){
    return self.materiasDeCarreras().filter({ materia => materia.estaInscripto(self)})
  }
  //Está también está horrible, tampoco se me ocurre algo mejor

  method materiasEnListaDeEspera() {
    return self.materiasDeCarreras().filter({ materia => materia.estaEnListaDeEspera(self)}) 
  }
  
  //Podría encapsular en filtrarMaterias(filtro), pero no me parece relevante

  //Esto esta peor, no se me cae una idea.
  method materiasQuePuedeInscribirse(carrera){
    return if (carreras.contains(carrera)) carrera.materias().filter({ materia => self.puedeAnotarseA(materia)}) else self.error("El alumno no cursa esa carrera")
  }
 
}


