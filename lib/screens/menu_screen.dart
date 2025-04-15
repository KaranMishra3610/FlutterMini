import 'dart:math';
import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'wallet_screen.dart';
import '../services/order_service.dart';

class MenuScreen extends StatefulWidget {
  final String userEmail;
  const MenuScreen({required this.userEmail, super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final OrderService _orderService = OrderService();
  final Map<String, int> itemQuantities = {};

  final List<Map<String, dynamic>> menuItems = [
    {"name": "Pizza", "price": 100.0, "image": "assets/images/pizza.jfif"},
    {"name": "Burger", "price": 50.0, "image": "assets/images/burger.jfif"},
    {"name": "Pasta", "price": 55.0, "image": "assets/images/pasta.jfif"},
    {"name": "Samosa", "price": 18.0, "image": "assets/images/samosa.jfif"},
    {"name": "Vada Pav", "price": 18.0, "image": "assets/images/vada_pav.jfif"},
    {"name": "Dosa", "price": 25.0, "image": "assets/images/dosa.jfif"},
    {"name": "Chole Bhature", "price": 63.0, "image": "assets/images/chole_bhature.jfif"},
    {"name": "Masala Dosa", "price": 40.0, "image": "assets/images/masala_dosa.jfif"},
  ];

  void updateQuantity(String itemName, int change) {
    setState(() {
      itemQuantities[itemName] = (itemQuantities[itemName] ?? 0) + change;
      if (itemQuantities[itemName]! < 0) {
        itemQuantities[itemName] = 0;
      }
    });
  }

  String generateOrderId() {
    final random = Random();
    int randomNumber = random.nextInt(900000) + 100000;
    return "${widget.userEmail}_$randomNumber";
  }

  Future<void> addToCart() async {
    if (itemQuantities.isEmpty || itemQuantities.values.every((q) => q == 0)) return;

    String orderId = generateOrderId();
    for (var item in menuItems) {
      String itemName = item["name"];
      double itemPrice = item["price"];
      int quantity = itemQuantities[itemName] ?? 0;

      if (quantity > 0) {
        await _orderService.addToCart(widget.userEmail, itemName, quantity, itemPrice, orderId);
      }
    }

    setState(() {
      itemQuantities.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order placed successfully! Order ID: $orderId")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Canteen Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WalletScreen(userEmail: widget.userEmail)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen(userEmail: widget.userEmail)),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          int crossAxisCount = width < 600 ? 1 : 2;
          double aspectRatio = width < 600 ? 2.2 : 1.2;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: aspectRatio,
            ),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              var item = menuItems[index];
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: width < 600
                      ? Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          item["image"],
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item["name"],
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "₹${item["price"].toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, color: Colors.red),
                                  onPressed: () => updateQuantity(item["name"], -1),
                                  iconSize: 22,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    itemQuantities[item["name"]]?.toString() ?? "0",
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.add, color: Colors.green),
                                  onPressed: () => updateQuantity(item["name"], 1),
                                  iconSize: 22,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          item["image"],
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        item["name"],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "₹${item["price"].toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.red),
                            onPressed: () => updateQuantity(item["name"], -1),
                          ),
                          Text(
                            itemQuantities[item["name"]]?.toString() ?? "0",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.green),
                            onPressed: () => updateQuantity(item["name"], 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addToCart,
        backgroundColor: Colors.purple[300],
        child: const Icon(Icons.shopping_cart_checkout),
      ),
    );
  }
}
