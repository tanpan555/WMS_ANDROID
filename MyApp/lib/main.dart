import 'package:flutter/material.dart';
import 'SSINDT01/SSINDT01_CARD.dart';
import 'drawer.dart'; // Import the new drawer file
import 'appbar.dart'; // Import the custom AppBar
import 'Login.dart'; // Import the LoginPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login', // Set LoginPage as the initial route
      routes: {
        '/': (context) => const MyHomePage(),
        '/ssindt01Card': (context) => const Ssindt01Card(),
        '/login': (context) => LoginPage(),
        // Define other routes here if needed
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  void _navigateToPage(BuildContext context, String routeName) {
    try {
      Navigator.pushNamed(context, routeName);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to navigate to $routeName'),
        ),
      );
    }
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
              Icons.inventory_2_outlined,
              color: Colors.black,
            ),
            title: Text(
              'WMS คลังวัตถุดิบ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.arrow_circle_right_outlined,
                ),
                title: const Text('รับจากการสั่งซื้อ'),
                onTap: () {
                  _navigateToPage(context, '/ssindt01Card');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.arrow_circle_right_outlined,
                ),
                title: const Text('รับตรง (ไม่อ้าง PO)'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.arrow_circle_right_outlined,
                ),
                title: const Text('Move Locator'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.arrow_circle_right_outlined,
                ),
                title: const Text('Move Warehouse'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.arrow_circle_right_outlined,
                ),
                title: const Text('เบิกจ่าย'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.assignment_outlined,
                ),
                title: const Text('ตรวจนับ'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.repeat,
                ),
                title: const Text('รับคืนจากการเบิกผลิตเพื่อผลผลิต'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              // Add more ListTiles here if needed
            ],
          ),
          ExpansionTile(
            leading: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
            ),
            title: Text(
              'WMS คลังสำเร็จรูป',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.arrow_circle_right_outlined,
                ),
                title: const Text('รับจากการผลิต'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.arrow_circle_right_outlined,
                ),
                title: const Text('รับตรง (ไม่อ้าง PO)'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.arrow_circle_right_outlined,
                ),
                title: const Text('Move Locator'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.arrow_circle_right_outlined,
                ),
                title: const Text('Move Warehouse'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.arrow_circle_right_outlined,
                ),
                title: const Text('เบิกจ่าย'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.arrow_circle_right_outlined,
                ),
                title: const Text('ตรวจนับ'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              // Add more ListTiles here if needed
            ],
          ),
          ExpansionTile(
            leading: const Icon(
              Icons.discount_outlined,
              color: Colors.black,
            ),
            title: Text(
              'พิมพ์ Tag',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.label_important_outline_rounded,
                ),
                title: const Text('Gen FG-Tag'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.print_outlined,
                ),
                title: const Text('Reprint Tag ม้วน'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              // Add more ListTiles here if needed
            ],
          ),
          ExpansionTile(
            leading: const Icon(
              Icons.folder_outlined,
              color: Colors.black,
            ),
            title: Text(
              'ตรวจนับประจำงวด',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.arrow_circle_right_outlined,
                ),
                title: const Text('ประมวลผลก่อนตรวจนับ'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.arrow_circle_right_outlined,
                ),
                title: const Text('บันทึกตรวจนับ'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.arrow_circle_right_outlined,
                ),
                title: const Text('รายงานเตรียมตรวจนับ'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.arrow_circle_right_outlined,
                ),
                title: const Text('รายงานตรวจนับ'),
                onTap: () {
                  // _navigateToPage(context, '/ssindt01Card');
                },
              ),
              // Add more ListTiles here if needed
            ],
          ),
          // Add other widgets here if needed
        ],
      ),
    );
  }
}
