# CS374 Individual Project 5

A simple book search app prototype.

## [main.dart](lib/main.dart)
This contains the main entry point for the app as well as the home screen widget and book search class.

## [MyHomePage](lib/main.dart#L30)
This is the home screen widget which contains an app bar with a search button, and a list of [BookCard](lib/widgets/book_card.dart) widgets. When the ***MyHomePage*** widget is first created it starts loading the book data from [books.json](assets/books.json). That data is then parsed into a [BookPurchaseItem](lib/models/book_purchase_item.dart) model using the [fromJson](lib/models/book_purchase_item.dart#L21) factory method. This model is used to create the ***BookCard*** widgets that are displayed in the list view. While the data is loading, a loading indicator is displayed.

## [BookSearch](lib/main.dart#L91)
This is a search delegate which internally uses a [FuzzySearch](lib/utils/fuzzy_search.dart) to search through books. The ***FuzzySearch*** returns a list of ***BookPurchaseItems*** and this delegate simply creates a list view displaying those items using the ***BookCard*** widget.

## [FuzzySearch](lib/utils/fuzzy_search.dart)
This is a templated class which can be used to search any list of ***data***. The data needs to be passed to the constructor. It is also recommended to pass a fucntion that coverts each element in data to a string. If this function is not passed the default ***toString*** method is called. The resulting string is tokenized as well as the query string. All of the query tokens are compared against all of the elements tokens and a score is calculated based on that. The result is a map of elements and their respective scores. Once complete the map is sorted descending by scores and the list of elements from that map is returned.

## [BookPurchaseItem](lib/models/book_purchase_item.dart)
This is simply an immutable data model used to hold the information about a book that can be purchased.

## [ShoppingCart](lib/models/shopping_cart.dart)
This is the data model for the shopping cart. It is used as the model for the MVC as well as the publisher for the observer pattern.
The [ShoppingCartWidget](lib/widgets/shopping_cart.dart) is the main view for the ***ShoppingCart*** model. It subscribes to events ([HERE](lib/widgets/shopping_cart.dart#L14)) and rebuilds itself when any changes occur. The shopping cart icon on the home screen is also a subscriber to the shopping cart ([HERE](lib/main.dart#L74)). This allows the icon to display the number of items in the cart, and update anytime an item is added or removed. This is needed because items could be added from the home screen or removed from the shopping cart screen. To avoid having multiple controllers notify this widget to rebuild, we instead use the observer pattern to always get notifications when this model changes.

## Screenshots
<img src="https://raw.githubusercontent.com/timlassiter11/CS374_IP5/assets/home.png" width="30%"></img>
<img src="https://raw.githubusercontent.com/timlassiter11/CS374_IP5/assets/home_cart_empty.png" width="30%"></img>
<img src="https://raw.githubusercontent.com/timlassiter11/CS374_IP5/assets/search.png" width="30%"></img>
<img src="https://raw.githubusercontent.com/timlassiter11/CS374_IP5/assets/cart.png" width="30%"></img>
<img src="https://raw.githubusercontent.com/timlassiter11/CS374_IP5/assets/cart_empty.png" width="30%"></img>
<img src="https://raw.githubusercontent.com/timlassiter11/CS374_IP5/assets/search_no_results.png" width="30%"></img> 
