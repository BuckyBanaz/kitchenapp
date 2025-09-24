class OrderBookingModel {
  final int customerId;
  final String address;
  final String date;
  final String time;
  final String location;
  final String additionalNumber;
  final int person;
  final List<MenuItem>? menu; // nullable
  final double price;
  final String? image; // nullable
  final String? note; // nullable

  OrderBookingModel({
    required this.customerId,
    required this.address,
    required this.date,
    required this.time,
    required this.location,
    required this.additionalNumber,
    required this.person,
    this.menu, // nullable
    required this.price,
    this.image, // nullable
    this.note, // nullable
  });

  factory OrderBookingModel.fromJson(Map<String, dynamic> json) {
    return OrderBookingModel(
      customerId: json['customer_id'],
      address: json['address'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      location: json['location'] ?? '',
      additionalNumber: json['additional_number'] ?? '',
      person: json['person'] ?? 0,
      menu: json['menu'] != null
          ? (json['menu'] as List).map((e) => MenuItem.fromJson(e)).toList()
          : null,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'address': address,
      'date': date,
      'time': time,
      'location': location,
      'additional_number': additionalNumber,
      'person': person,
      'menu': menu?.map((e) => e.toJson()).toList(), // null-safe
      'price': price,
      'image': image,
      'note': note,
    };
  }
}

class MenuItem {
  final String item;

  MenuItem({required this.item});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(item: json['item'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'item': item};
  }
}
