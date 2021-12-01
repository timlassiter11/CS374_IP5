import 'package:flutter/cupertino.dart';

@immutable
class PurchaseItem {
  final String id;
  final double price;
  final int qtyAvailable;
  final String name;
  final String img;

  const PurchaseItem({
    required this.id,
    required this.price,
    required this.qtyAvailable,
    required this.name,
    required this.img,
  });

  bool get available => qtyAvailable > 0;

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      id: json['id'] as String,
      price: json['price'] as double,
      qtyAvailable: json['qtyAvailable'] as int,
      name: json['name'] as String,
      img: json['img'] as String,
    );
  }
}
