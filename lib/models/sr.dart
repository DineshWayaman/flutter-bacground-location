class SR {
  final int id;
  final String customerName;
  final String name;

  SR({required this.id, required this.customerName, required this.name});

  factory SR.fromJson(Map<String, dynamic> json) {
    return SR(
      id: json['id'],
      customerName: json['customerName'],
      name: json['name'],
    );
  }

}