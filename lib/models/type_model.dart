// models/type_model.dart
class TypeModel {
  final int id;
  final String name;

  TypeModel({
    required this.id,
    required this.name,
  });

  factory TypeModel.fromJson(Map<String, dynamic> json) {
    return TypeModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
