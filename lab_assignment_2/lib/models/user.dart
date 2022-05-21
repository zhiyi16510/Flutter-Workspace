class User {
  String? id;
  String? email;
  String? name;
  String? phone;
  String? address;
  String? regdate;
  String? otp;

  User(
      {this.id,
      this.email,
      this.name,
      this.phone,
      this.address,
      this.regdate,
      this.otp});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    regdate = json['regdate'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    data['regdate'] = regdate;
    data['otp'] = data;
    return data;
  }
}
