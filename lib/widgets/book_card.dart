import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    Key? key,
    required this.name,
    required this.price,
    required this.qtyAvailable,
    required this.author,
    required this.img,
    this.onTap,
    this.actions,
  }) : super(key: key);

  final String name;
  final double price;
  final int qtyAvailable;
  final String author;
  final String img;
  final VoidCallback? onTap;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Image(image: AssetImage(img)),
            title: Text(name),
            subtitle: Text(author),
            trailing: Text("\$${price.toStringAsFixed(2)}"),
          ),
          if (actions != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!,
            ),
        ],
      ),
    );
  }
}
