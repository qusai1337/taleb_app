import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ShopDetailsPage.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final Map user;

  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List shops = [];
  List filteredShops = [];
  late Map user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
     //print("✅ USERNAME: ${user['name']}");
    _fetchShops();
  }

  Future<void> _fetchShops() async {
    final response = await http.get(Uri.parse('http://192.168.1.10:3000/shops'));
      //  final response = await http.get(Uri.parse('http://localhost:3000/shops'));

    if (response.statusCode == 200) {
      setState(() {
        shops = json.decode(response.body);
        filteredShops = shops;
      });
    } else {
      throw Exception('Failed to load shops');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
   appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  automaticallyImplyLeading: false,
  title: Padding(
    padding: const EdgeInsets.only(left: 16, top: 30, bottom: 10),
    child: Image.asset(
      'assets/homeLogo.png',
      height: 60,
    ),
  ),
  actions: [
    IconButton(
      icon: Icon(Icons.logout, color: Colors.black),
      onPressed: () {
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => LoginPage()),
);
      },
    ),
  ],
),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, ${user['name']}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            TextField(
              onChanged: (value) {
                setState(() {
                  filteredShops = shops.where((shop) {
                    final name = shop['name'].toString().toLowerCase();
                    final input = value.toLowerCase();
                    return name.contains(input);
                  }).toList();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            SizedBox(height: 16),

            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategory("🏋️ Gym"),
                  _buildCategory("🍔 Food"),
                  _buildCategory("☕ Coffee"),
                  _buildCategory("🛒 Market"),
                  _buildCategory("🖥️ Office"),
                ],
              ),
            ),
            SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: filteredShops.length,
                itemBuilder: (context, index) {
                  final shop = filteredShops[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShopDetailsPage(shop: shop),
                        ),
                      );
                    },
                    child: _buildModernCard(
                      title: shop['name'],
                      discount: shop['discount'],
                      location: shop['location'],
                      imageUrl: shop['image_url'],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String selectedCategory = '';

Widget _buildCategory(String label) {
  return GestureDetector(
    onTap: () {
      setState(() {
        if (selectedCategory == label) {
          selectedCategory = '';
          filteredShops = shops;
        } else {
          selectedCategory = label;
          filteredShops = shops.where((shop) {
            return shop['category']
                .toString()
                .toLowerCase()
                .contains(label.split(' ').last.toLowerCase());
          }).toList();
        }
      });
    },
    child: Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selectedCategory == label ? Color(0xFF008C8C) : Color(0xFFE6F2F2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selectedCategory == label ? Colors.white : Colors.black,
        ),
      ),
    ),
  );
}


  Widget _buildModernCard({
    required String title,
    required String discount,
    required String location,
    required String imageUrl,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 50,
                  width: 50,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: Icon(Icons.broken_image, size: 24, color: Colors.grey),
                );
              },
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(discount, style: TextStyle(color: Color(0xFF008C8C), fontWeight: FontWeight.w500)),
              Text(location, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }
}
