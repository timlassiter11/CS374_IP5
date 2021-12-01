import 'dart:collection';

import 'package:cs374_ip5/models/purchase_item.dart';
import 'package:flutter/material.dart';

class ShoppingCart extends ChangeNotifier {
  final Map<PurchaseItem, int> _items = <PurchaseItem, int>{};

  // Read only access to the items
  // Must use the methods to update the state so all subscribers get notified
  UnmodifiableMapView<PurchaseItem, int> get items =>
      UnmodifiableMapView(_items);

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  double get total {
    double total = 0.0;
    for (PurchaseItem item in _items.keys) {
      int qty = _items[item]!;
      total += qty * item.price;
    }
    return total;
  }

  void addItem(PurchaseItem item, {int qty = 1}) {
    _items[item] = qty;
    notifyListeners();
  }

  void removeItem(PurchaseItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void setItemQty(PurchaseItem item, int qty) {
    _items[item] = qty;
    notifyListeners();
  }
}
