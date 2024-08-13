import 'package:flutter/material.dart';
import 'drawer.dart'; // Import the new drawer file
import 'appbar.dart';
// import 'SSINDT01/SSINDT01_CARD.dart'; // Import the Ssindt01Card page

class Card1Page extends StatelessWidget {
  const Card1Page({Key? key}) : super(key: key);

  void _navigateToPage(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // Using default title here
      drawer: const CustomDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
          ),
          _buildListTile(
            context,
            Icons.arrow_circle_right_outlined,
            'รับจากการสั่งซื้อ',
            '/ssindt01Card', //linkหน้า
          ),
          _buildListTile(
            context,
            Icons.arrow_circle_right_outlined,
            'รับตรง (ไม่อ้าง PO)',
            '', // Update the route name as needed
          ),
          _buildListTile(
            context,
            Icons.arrow_circle_right_outlined,
            'Move Locator',
            '', // Update the route name as needed
          ),
          _buildListTile(
            context,
            Icons.arrow_circle_right_outlined,
            'Move Warehouse',
            '', // Update the route name as needed
          ),
          _buildListTile(
            context,
            Icons.arrow_circle_right_outlined,
            'เบิกจ่าย',
            '', // Update the route name as needed
          ),
          _buildListTile(
            context,
            Icons.assignment_outlined,
            'ตรวจนับ',
            '', // Update the route name as needed
          ),
          _buildListTile(
            context,
            Icons.repeat,
            'รับคืนจากการเบิกผลิตเพื่อผลผลิต',
            '', // Update the route name as needed
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    IconData icon,
    String title,
    String routeName,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.green[100], // Background color
        borderRadius: BorderRadius.circular(5), // Rounded corners
        // border: Border.all(
        //   // color: const Color.fromRGBO(187, 222, 251, 1), // Border color
        //   width: 1.0, // Border width
        // ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: Icon(icon),
        title: Text(title),
        onTap: () {
          if (routeName.isNotEmpty) {
            _navigateToPage(context, routeName);
          }
        },
      ),
    );
  }
}
