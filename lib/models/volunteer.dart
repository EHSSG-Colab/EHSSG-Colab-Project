class Volunteer {
  int? id;
  String volName;
  String volTsp;
  String volVillage;

  Volunteer(
      {this.id, required this.volName, required this.volTsp, required this.volVillage});

  factory Volunteer.fromMap(Map<String, dynamic> map){
    return Volunteer(
      id: map['id'],
      volName: map['vol_name'],
      volTsp: map['vol_tsp'],
      volVillage: map['vol_vil']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vol_name': volName,
      'vol_tsp': volTsp,
      'vol_vil': volVillage,
    };
  }
}