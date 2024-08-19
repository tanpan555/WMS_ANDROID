import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0; // Initial index for the bottom bar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/'); // Navigate to Home
        break;
      case 1:
        _showRightDrawer(context); // Show the drawer from the right
        break;
    }
  }

  void _showRightDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4, // Initial height
          maxChildSize: 0.8, // Maximum height
          minChildSize: 0.2, // Minimum height
          expand: false,
          builder: (_, controller) {
            return Container(
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.3), // Adjust width here
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: ListView(
                controller: controller,
                children: [
                  ListTile(
                    leading: Icon(Icons.logout_outlined),
                    title: Text('Sign Out'),
                    onTap: () {
                      // Handle Settings tap
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.password_outlined),
                    title: Text('Change Password'),
                    onTap: () {
                      // Handle Profile tap
                    },
                  ),
                  // Add more list tiles as needed
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // Adjust the height of the background area here
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 1), // Set the background color
      ),
      child: BottomNavigationBar(
        showSelectedLabels: false, // Hide selected labels
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 17, 0, 56),
        onTap: _onItemTapped,
        iconSize: 25, // Set the icon size here
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white, // Set to transparent to use the container's color
      ),
    );
  }
}
