import 'package:cs374_ip5/models/purchase_item.dart';

class BookPurchaseItem extends PurchaseItem {
  final String author;

  const BookPurchaseItem({
    required String id,
    required double price,
    required int qtyAvailable,
    required String name,
    required String img,
    required this.author,
  }) : super(
          id: id,
          price: price,
          qtyAvailable: qtyAvailable,
          name: name,
          img: img,
        );

  factory BookPurchaseItem.fromJson(Map<String, dynamic> json) {
    return BookPurchaseItem(
      id: json['id'] as String,
      price: json['price'] as double,
      qtyAvailable: json['qtyAvailable'] as int,
      name: json['name'] as String,
      img: json['img'] as String,
      author: json['author'] as String,
    );
  }
}
