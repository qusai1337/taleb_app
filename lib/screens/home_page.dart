import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ShopDetailsPage.dart';
import 'login_page.dart';
import 'package:easy_localization/easy_localization.dart';

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
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    user = widget.user;
    _fetchShops();
  }

  Future<void> _fetchShops() async {
    final response = await http.get(Uri.parse('http://localhost:3000/shops'));

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
          child: Image.asset('assets/homeLogo.png', height: 60),
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
              "${'welcome'.tr()}, ${user['name']}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // 🔍 Search bar
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
                hintText: 'search'.tr(),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            SizedBox(height: 16),

            // 🏷️ Category bar
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategory("gym", "🏋️ ${'gym'.tr()}"),
                  _buildCategory("food", "🍔 ${'food'.tr()}"),
                  _buildCategory("coffee", "☕ ${'coffee'.tr()}"),
                  _buildCategory("market", "🛒 ${'market'.tr()}"),
                  _buildCategory("office", "🖥️ ${'office'.tr()}"),
                ],
              ),
            ),
            SizedBox(height: 16),

            // 🌟 Try These First slider
            Text("try_first".tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: shops.where((shop) => shop['IsTotryFirst'] == true).map((shop) {
                  return Container(
                    width: 160,
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Column(
                      children: [
                        Expanded(child: Image.network(shop['image_url'], fit: BoxFit.cover)),
                        SizedBox(height: 6),
                        Text(shop['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 12),

            // 🏪 Main list
            Expanded(
              child: ListView.builder(
                itemCount: filteredShops.length,
                itemBuilder: (context, index) {
                  final shop = filteredShops[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ShopDetailsPage(shop: shop),
                      ));
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

  Widget _buildCategory(String value, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedCategory == value) {
            selectedCategory = '';
            filteredShops = shops;
          } else {
            selectedCategory = value;
            filteredShops = shops.where((shop) {
              return shop['category'].toString().toLowerCase().contains(value.toLowerCase());
            }).toList();
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selectedCategory == value ? Color(0xFF008C8C) : Color(0xFFE6F2F2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(color: selectedCategory == value ? Colors.white : Colors.black),
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
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
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
              errorBuilder: (_, __, ___) => Container(
                height: 50,
                width: 50,
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: Icon(Icons.broken_image, size: 24, color: Colors.grey),
              ),
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
