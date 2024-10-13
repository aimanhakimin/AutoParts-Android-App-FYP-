import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Product {
  final String title;
  final String price;
  final String imageLink;
  final String productLink;

  Product({
    required this.title,
    required this.price,
    required this.imageLink,
    required this.productLink,
  });
}

class FindComponentsPage extends StatefulWidget {
  FindComponentsPage({Key? key}) : super(key: key);

  @override
  _FindComponentsPageState createState() => _FindComponentsPageState();
}

class _FindComponentsPageState extends State<FindComponentsPage> {
  List<Product>? products;
  List<Product>? filteredProducts;
  TextEditingController searchController = TextEditingController();
  int currentPage = 0;
  int pageSize = 50;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('http://172.20.10.2:5000/scrape'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          products = data
              .map((item) => Product(
                    title: item['title'],
                    price: item['price'],
                    imageLink: item['imageLink'],
                    productLink: item['productLink'],
                  ))
              .toList();
          filteredProducts = products;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      // Handle error gracefully (e.g., show error message)
    }
  }

  void _filterProducts() {
    setState(() {
      filteredProducts = products!
          .where((product) =>
              product.title.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
      currentPage = 0; // Reset to first page when filtering
    });
  }

  void _clearSearch() {
    searchController.clear();
    _filterProducts();
  }

  List<Product> getCurrentPageProducts() {
    int startIndex = currentPage * pageSize;
    int endIndex = (startIndex + pageSize < filteredProducts!.length)
        ? startIndex + pageSize
        : filteredProducts!.length;
    return filteredProducts!.sublist(startIndex, endIndex);
  }

  void goToPreviousPage() {
    setState(() {
      if (currentPage > 0) {
        currentPage--;
      }
    });
  }

  void goToNextPage() {
    setState(() {
      if ((currentPage + 1) * pageSize < filteredProducts!.length) {
        currentPage++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Find Components'),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Stack(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search components...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: filteredProducts == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Find Components',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Adjust the number of products per row
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: getCurrentPageProducts().length,
                      itemBuilder: (BuildContext context, int index) {
                        final product = getCurrentPageProducts()[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                  product: product,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    product.imageLink,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                        maxLines: 2, // Limit the number of lines for title
                                        overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        product.price,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: currentPage > 0 ? goToPreviousPage : null,
                      ),
                      Text('${currentPage + 1}'),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: (currentPage + 1) * pageSize < filteredProducts!.length
                            ? goToNextPage
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Default to Home
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Find Components',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Maintenance Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Track Workshop',
          ),
        ],
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.lightBlueAccent,
        onTap: (int index) {
          switch (index) {
            case 0:
              // Already on Find Components, do nothing
              break;
            case 1:
              Navigator.pushNamed(context, '/maintenance_log');
              break;
            case 2:
              Navigator.pushNamed(context, '/track_workshop');
              break;
          }
        },
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Product product;

  ProductDetailPage({Key? key, required this.product}) : super(key: key);

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              product.imageLink,
              height: 200.0,
              width: 200.0,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20.0),
            Text(
              product.title,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Price: ${product.price}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _launchURL(product.productLink);
              },
              child: Text('Go to Product Page'),
            ),
          ],
        ),
      ),
    );
  }
}
