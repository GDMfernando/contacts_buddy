class Contact {
  final int? id;
  final String name;
  final int phoneNum;
  final String? email;

  Contact(
      {this.id,
        required this.name,
        required this.phoneNum,
        this.email});

  Contact.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        phoneNum = res["phoneNum"],
        email = res["email"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNum' : phoneNum,
      'email': email
    };
  }
}