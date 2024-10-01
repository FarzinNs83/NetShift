class DnsModel {
  String name;
  String primary;
  String secondary;
  int? primaryPingTime;
  int? secondaryPingTime;

  DnsModel({
    required this.name,
    required this.primary,
    required this.secondary,
    this.primaryPingTime,
    this.secondaryPingTime,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'name': name,
  //     'primary': primary,
  //     'secondary': secondary,
  //     'primaryPingTime': primaryPingTime,
  //     'secondaryPingTime': secondaryPingTime,
  //   };
  // }

  // factory DnsModel.fromMap(Map<String, dynamic> map) {
  //   return DnsModel(
  //     name: map['name'],
  //     primary: map['primary'],
  //     secondary: map['secondary'],
  //     primaryPingTime: map['primaryPingTime'],
  //     secondaryPingTime: map['secondaryPingTime'],
  //   );
  // }
}
