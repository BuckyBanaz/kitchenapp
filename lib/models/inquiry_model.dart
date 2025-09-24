// models/inquiry_request_model.dart
class InquiryRequestModel {
  final List<dynamic> items;

  InquiryRequestModel({required this.items});

  Map<String, dynamic> toJson() => {
    'items': items,
  };
}
