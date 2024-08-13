import 'package:flutter/material.dart';
import 'SSINDT01/SSINDT01_CARD.dart';
import 'drawer.dart'; // Import the new drawer file
import 'appbar.dart'; // Import the custom AppBar
import 'Login.dart'; // Import the LoginPage
import 'card1.dart'; // Import the card1.dart page
// import 'bottombar.dart';

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
        '/card1': (context) =>
            Card1Page(), // Define the route for card1.dart page
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
    // Define card data with colors
    final List<Map<String, dynamic>> cards = [
      {
        'icon': Icons.inventory_2_outlined,
        'title': 'WMS คลังวัตถุดิบ',
        'color': Colors.green[100], // Light blue color
        'route': '/card1', // Route to navigate on tap
      },
      {
        'icon': Icons.shopping_bag_outlined,
        'title': 'WMS คลังสำเร็จรูป',
        'color': Colors.blue[100], // Light green color
      },
      {
        'icon': Icons.discount_outlined,
        'title': 'พิมพ์ Tag',
        'color': Colors.orange[100], // Light orange color
      },
      {
        'icon': Icons.folder_outlined,
        'title': 'ตรวจนับประจำงวด',
        'color': Colors.red[100], // Light red color
      },
    ];

    return Scaffold(
      appBar: const CustomAppBar(), // Using default title here
      drawer: const CustomDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(15.0),
        children: [
          // Your existing ExpansionTile widgets here...

          // 2x2 Grid of cards
          const SizedBox(height: 20), // Spacing above the grid
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 5, // Horizontal spacing between cards
              mainAxisSpacing: 5, // Vertical spacing between cards
              childAspectRatio: 1.0, // Aspect ratio for each card
            ),
            itemCount: cards.length, // Number of cards
            itemBuilder: (context, index) {
              final card = cards[index];
              return InkWell(
                onTap: () {
                  if (card.containsKey('route')) {
                    _navigateToPage(context, card['route']);
                  }
                },
                child: Card(
                  elevation: 4.0,
                  color: card['color'], // Set the background color of the card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        5), // Adjust the border radius here
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        card['icon'],
                        size: 50, // Size of the icon
                        color: Colors.black,
                      ),
                      const SizedBox(height: 20), // Space between icon and text
                      Text(
                        card['title'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
