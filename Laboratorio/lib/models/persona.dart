class Persona{
  final String nombre;
  final String apellido;
  final String correo;
  final String sexo;
  final String telefono;

  Persona({
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.sexo,
    required this.telefono,

});
  factory Persona.fromJson(Map<String, dynamic> json){
    return Persona(
        nombre: json['nombre'] ?? '',
        apellido: json['apellido']?? '',
        correo: json['correo']?? '',
        sexo: json['sexo']?? '',
        telefono: json['telefono']?? '') ;
  }
}