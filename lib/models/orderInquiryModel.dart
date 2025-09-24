import 'dart:convert';

class MenuItem {
  final String item;

  MenuItem({required this.item});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(item: json['item']);
  }

  Map<String, dynamic> toJson() => {
    'item': item,
  };
}

class OrderInquiryModel {
  final int id;
  final int customerId;
  final String address;
  final String date;
  final String time;
  final String status;
  final List<MenuItem> menu;
  final String person;
  final String additionalNumber;
  final String? price;
  final String? location;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? note;
  final String? image; // ✅ Added image

  OrderInquiryModel({
    required this.id,
    required this.customerId,
    required this.address,
    required this.date,
    required this.time,
    required this.status,
    required this.menu,
    required this.person,
    required this.additionalNumber,
    this.price,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.note, // nullable
    this.image, // ✅
  });

  factory OrderInquiryModel.fromJson(Map<String, dynamic> json) {
    // ✅ menu can be null or an already-decoded list or a JSON string
    List<MenuItem> parsedMenu = [];

    try {
      final rawMenu = json['menu'];

      if (rawMenu != null) {
        if (rawMenu is String) {
          parsedMenu = List<Map<String, dynamic>>.from(jsonDecode(rawMenu))
              .map((e) => MenuItem.fromJson(e))
              .toList();
        } else if (rawMenu is List) {
          parsedMenu = rawMenu
              .map<MenuItem>((e) => MenuItem.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
      }
    } catch (e) {
      parsedMenu = []; // fallback to empty list on error
    }

    return OrderInquiryModel(
      id: json['id'],
      customerId: json['customer_id'],
      address: json['address'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? '',
      person: json['person'] ?? '',
      additionalNumber: json['additional_number'] ?? '',
      menu: parsedMenu,
      price: json['price']?.toString(),
      location: json['location'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      image: json['image'], // ✅ null-safe
      note: json['note'], // 👈 nullable',
    );
  }
}
