class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String image;
  final String username;
  final String ethAddress;
  final String uniqueId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.username,
    required this.ethAddress,
    required this.uniqueId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?? '',
      name: json['name']?? '',
      email: json['email']?? '',
      phone: json['phone']?? '',
      image: json['image']?? '',
      username: json['username']?? '',
      ethAddress: json['eth_address']?? '',
      uniqueId: json['unique_id']?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'image': image,
    'username': username,
    'eth_address': ethAddress,
    'unique_id': uniqueId,
  };
}
