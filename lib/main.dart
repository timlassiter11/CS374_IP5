import 'dart:convert';

import 'package:cs374_ip5/models/book_purchase_item.dart';
import 'package:cs374_ip5/utils/fuzzy_search.dart';
import 'package:cs374_ip5/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String appTitle = 'Boundless Books';

void main() {
  runApp(const MyApp());
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
                    img: "assets/images/books/${item.img}",
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
          img: "assets/images/books/${item.img}",
        );
      },
    );
  }
}
