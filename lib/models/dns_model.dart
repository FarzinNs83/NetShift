class DnsModel {
  final String name;
  final String primaryDNS;
  final String secondaryDNS;

  DnsModel({
    required this.name,
    required this.primaryDNS,
    required this.secondaryDNS,
  });
    Map<String, dynamic> toJson() {
    return {
      'name': name,
      'primaryDNS': primaryDNS,
      'secondaryDNS': secondaryDNS,
    };
  }
  factory DnsModel.fromJson(Map<String, dynamic> json) {
    return DnsModel(
      name: json['name'],
      primaryDNS: json['primaryDNS'],
      secondaryDNS: json['secondaryDNS'],
    );
  }
}
