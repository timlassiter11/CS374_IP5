import 'dart:convert';

import 'package:cs374_ip5/models/book_purchase_item.dart';
import 'package:cs374_ip5/models/shopping_cart.dart';
import 'package:cs374_ip5/utils/fuzzy_search.dart';
import 'package:cs374_ip5/widgets/book_card.dart';
import 'package:cs374_ip5/widgets/icon_with_badge.dart';
import 'package:cs374_ip5/widgets/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

const String appTitle = 'Boundless Books';

void main() {
  // Observer - Publisher
  // We create a single ShippingCart instance here
  // We then provide this instance to the entire widget tree below.
  // If anything modifies this object, all of the subscribers will be notified
  runApp(ChangeNotifierProvider(
    create: (_) => ShoppingCart(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<BookPurchaseItem> _books = <BookPurchaseItem>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch<BookPurchaseItem?>(
                  context: context, delegate: BookSearch(_books));
            },
          ),
          // Observer - Subscriber
          // Anytime the shopping cart changes the builder function will
          // run which forces the widget to rebuild with the new data
          Consumer<ShoppingCart>(
            builder: (_, cart, child) {
              return IconButton(
                icon: IconWithBadge(
                  const Icon(Icons.shopping_cart_outlined),
                  top: -5.0,
                  right: -5.0,
                  badge: cart.isNotEmpty
                      ? Container(
                          width: 15,
                          height: 15,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                          child:
                              Center(child: Text(cart.items.length.toString())),
                        )
                      : null,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => Scaffold(
                        appBar: AppBar(
                          title: const Text('Cart'),
                        ),
                        body: const SafeArea(child: ShoppingCartWidget()),
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView.builder(
                itemCount: _books.length,
                itemBuilder: (BuildContext context, int index) {
                  BookPurchaseItem item = _books[index];
                  return BookCard(
                    name: item.name,
                    price: item.price,
                    qtyAvailable: item.qtyAvailable,
                    author: item.author,
                    img: item.img,
                    actions: <Widget>[
                      TextButton(
                        child: item.available
                            ? const Text('Add to Cart')
                            : const Text('Out of Stock'),
                        onPressed: item.available
                            ? () => context.read<ShoppingCart>().addItem(item)
                            : null,
                      )
                    ],
                  );
                },
              ),
            ),
    );
  }

  void _loadBooks() async {
    final String data = await rootBundle.loadString('assets/books.json');
    final List<dynamic> books = await json.decode(data);
    for (Map<String, dynamic> book in books) {
      _books.add(BookPurchaseItem.fromJson(book));
    }
    setState(() => _isLoading = false);
  }
}

class BookSearch extends SearchDelegate<BookPurchaseItem?> {
  final FuzzySearch<BookPurchaseItem> _searchEngine;

  BookSearch(List<BookPurchaseItem> data)
      : _searchEngine = FuzzySearch(
            data: data,
            elementToString: (BookPurchaseItem element) => element.name),
        super();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => _getBooks();

  @override
  Widget buildSuggestions(BuildContext context) => _getBooks();

  Widget _getBooks() {
    final Iterable<BookPurchaseItem> books = _searchEngine.search(query);
    if (books.isEmpty) {
      return const Center(child: Text('No matching books found.'));
    }
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (BuildContext context, int index) {
        BookPurchaseItem item = books.elementAt(index);
        return BookCard(
          name: item.name,
          price: item.price,
          qtyAvailable: item.qtyAvailable,
          author: item.author,
          img: item.img,
        );
      },
    );
  }
}
