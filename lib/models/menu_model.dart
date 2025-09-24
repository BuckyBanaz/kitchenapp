class MenuModel {
  final int? id;
  final String name;
  final int? categoryId;

  MenuModel({
    this.id,
   required this.name,
    this.categoryId,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      name: json['name'],
      categoryId: json['category_id'] is int
          ? json['category_id']
          : int.tryParse(json['category_id'].toString()),
    );
  }

  factory MenuModel.createTemp(String name) {
    return MenuModel(id: null, name: name, categoryId: null);
  }

  MenuModel copyWith({int? id, String? name, int? categoryId}) {
    return MenuModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  String toString() => name ?? '';
}
