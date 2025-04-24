class Volunteer {
  int? id;
  String volunteer_name;
  String volunteer_township;
  String volunteer_village;

  Volunteer({
    this.id,
    required this.volunteer_township,
    required this.volunteer_village,
    required this.volunteer_name,
  });

  factory Volunteer.fromMap(Map<String, dynamic> map) {
    return Volunteer(
      id: map['id'],
      volunteer_name: map['volunteer_name'],
      volunteer_township: map['volunteer_township'],
      volunteer_village: map['volunteer_village'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'volunteer_name': volunteer_name,
      'volunteer_township': volunteer_township,
      'volunteer_village': volunteer_village,
    };
  }
}
