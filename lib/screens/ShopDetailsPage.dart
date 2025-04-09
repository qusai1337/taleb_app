import 'package:flutter/material.dart';
import 'qr_scan_page.dart';

class ShopDetailsPage extends StatelessWidget {
  final Map shop;

  ShopDetailsPage({required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(shop['name'], style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFF008C8C)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                shop['image_url'] ?? '',
                height: 160,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Text(
                shop['name'] ?? '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008C8C),
                ),
              ),
              Text(
                (shop['discount'] ?? '') + ' OFF',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008C8C),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    shop['location'] ?? '',
                    style: TextStyle(color: Colors.grey[700]),
                  )
                ],
              ),
              SizedBox(height: 20),
              Text(
                shop['description'] ?? 'No description available.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'The discount is only for students after scanning the QR code',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => QRScanPage()),
                    );

                    if (result != null) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("✅ Scan Complete"),
                          content: Text("Code: \$result"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("OK"),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.qr_code),
                  label: Text(
                    "SCAN QR CODE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF008C8C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
