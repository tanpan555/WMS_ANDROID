import 'package:flutter/material.dart';
import 'custom_appbar.dart';
import 'custom_drawer.dart';
import 'SSINDT01/SSINDT01_card.dart';
import 'SSFGDT04/SSFGDT04_main.dart';
// import 'SSINDT01_CARD.dart';
// import 'drawer.dart'; // Import the new drawer file
// import 'appbar.dart'; // Import the custom AppBar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drawer Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // Using default title here
      drawer: const CustomDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(15.0),
        children: [
          ExpansionTile(
            leading: const Icon(
              Icons.archive_outlined,
              color: Colors.black,
            ),
            title: Text(
              'WMS คลังวัตถุดิบ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            children: <Widget>[
              ListTile(
                title: const Text('รับจากการสั่งซื้อ'),
                onTap: () {
                  _navigateToPage(context, const Ssindt01Card());
                },
              ),
              ListTile(
                title: const Text('รับตรง (ไม่อ้าง PO)'),
                onTap: () {
                  _navigateToPage(context, const Ssfgdt04Main());
                },
              ),

              // ListTile(
              //   title: const Text('Page 2'),
              //   onTap: () {
              //     _navigateToPage(context, const Page2());
              //   },
              // ),
              // Add more ListTiles here if needed
            ],
          ),
          // Add other widgets here if needed
        ],
      ),
    );
  }
}
