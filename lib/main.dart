import 'package:flutter/material.dart';

void main() {
  runApp(TransaksiApp());
}

class TransaksiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TransaksiPage(),
    );
  }
}

class TransaksiPage extends StatefulWidget {
  @override
  _TransaksiPageState createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final List<Map<String, dynamic>> items = [
    {'name': 'Laptop', 'price': 25000000, 'quantity': 0},
    {'name': 'Mouse', 'price': 1250000, 'quantity': 0},
    {'name': 'Keyboard', 'price': 1500000, 'quantity': 0},
    {'name': 'Monitor', 'price': 5000000, 'quantity': 0},
    {'name': 'Printer', 'price': 2200000, 'quantity': 0},
  ];

  int totalBayar = 0;
  List<Widget> itemDetails = [];

  // Initialize controllers for each item's quantity TextField
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    // Initialize a controller for each item
    controllers = List.generate(
        items.length, (index) => TextEditingController(text: '0'));
  }

  @override
  void dispose() {
    // Dispose of all controllers to free up resources
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void reset() {
    setState(() {
      for (int i = 0; i < items.length; i++) {
        items[i]['quantity'] = 0;
        controllers[i].text = '0'; // Reset the controller text to '0'
      }
      totalBayar = 0;
      itemDetails = [];
    });
  }

  void cetakStruk() {
    int total = 0;
    List<Widget> details = [];

    for (var item in items) {
      int subtotal = item['price'] * item['quantity'];
      total += subtotal;
      if (item['quantity'] > 0) {
        details.add(
          ListTile(
            title: Text("${item['name']} x ${item['quantity']}"),
            subtitle: Text("Subtotal: Rp $subtotal"),
          ),
        );
      }
    }

    setState(() {
      totalBayar = total;
      itemDetails = details;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toko Komputer'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Item list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name'], style: TextStyle(fontSize: 18)),
                            SizedBox(height: 4),
                            Text('Rp ${item['price']}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[600])),
                          ],
                        ),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller:
                                controllers[index], // Set the controller
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Jumlah',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                item['quantity'] = int.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Buttons below the list
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: reset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: Size(150, 50),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: cetakStruk,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(150, 50),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text('Cetak Struk'),
                ),
              ],
            ),
          ),
          // Cetak Struk scrollable details
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: itemDetails,
              ),
            ),
          ),
          // Fixed total at the bottom
          Container(
            color: Colors.blue[100],
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Bayar",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rp $totalBayar",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
