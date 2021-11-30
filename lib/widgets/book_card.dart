import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    Key? key,
    required this.name,
    required this.price,
    required this.qtyAvailable,
    required this.author,
    required this.img,
  }) : super(key: key);

  final String name;
  final double price;
  final int qtyAvailable;
  final String author;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image(image: AssetImage(img)),
        title: Text(name),
        subtitle: Text(author),
        trailing: Text("\$${price.toStringAsFixed(2)}"),
      ),
    );
  }
}
