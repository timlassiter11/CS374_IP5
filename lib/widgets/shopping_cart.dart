import 'package:cs374_ip5/models/purchase_item.dart';
import 'package:cs374_ip5/models/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingCartWidget extends StatelessWidget {
  const ShoppingCartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Observer - Subscriber
    // BuildContext.watch allows us to subscribe to the shopping carts
    // changes and rebuild this widget on any updates.
    final ShoppingCart cart = context.watch<ShoppingCart>();
    if (cart.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.shopping_cart_outlined,
              size: 75,
            ),
            Text(
              'Your cart is empty',
              style: Theme.of(context).textTheme.subtitle1,
            )
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (BuildContext context, int index) {
              PurchaseItem item = cart.items.keys.elementAt(index);
              int qty = cart.items[item]!;

              return _ShoppingCartItem(
                name: item.name,
                img: item.img,
                price: item.price,
                qty: qty,
                actions: [
                  TextButton(
                    child: const Text('Remove'),
                    onPressed: () => cart.removeItem(item),
                  )
                ],
              );
            },
          ),
        ),
        _OrderSummary(totalPrice: cart.total)
      ],
    );
  }
}

class _ShoppingCartItem extends StatelessWidget {
  const _ShoppingCartItem({
    Key? key,
    required this.name,
    required this.img,
    required this.price,
    required this.qty,
    this.actions,
  }) : super(key: key);

  final String name;
  final String img;
  final double price;
  final int qty;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Image(
              image: AssetImage(img),
            ),
            title: Text(name),
            trailing: Text('\$${price.toStringAsFixed(2)}'),
          ),
          if (actions != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!,
            )
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({Key? key, required this.totalPrice}) : super(key: key);

  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Order Summary',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const Spacer(),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: const Text('Checkout'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  onPressed: () {},
                ),
              )
            ]),
      ),
    );
  }
}
