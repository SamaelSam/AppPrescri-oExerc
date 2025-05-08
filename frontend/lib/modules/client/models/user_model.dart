class UserModel {
  final String id;
  final String username;
  final String email;
  final String role;
  final String hashedPassword;  // Novo campo para o hash da senha

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.hashedPassword, // Inicializando o campo 'hashedPassword'
  });

  // Construtor de fábrica para criar um objeto a partir de um Map (geralmente vindo de uma API)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']['\$oid'],  // Corrigido aqui
      username: json['username'],
      email: json['email'],
      role: json['role'],
      hashedPassword: json['hashed_password'], // Lendo o campo 'hashed_password' do JSON
    );
  }

  // Método para converter o objeto para um Map (geralmente para enviar a uma API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'hashed_password': hashedPassword, // Incluindo 'hashed_password' ao converter para JSON
    };
  }
}
