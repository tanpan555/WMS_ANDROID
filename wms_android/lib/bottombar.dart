import 'package:flutter/material.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import '../login.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0; // Initial index for the bottom bar
  String sessionID = '';

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        sessionID = globals.APP_SESSION;
        _selectedIndex = index;
        print(
            'sessionID in BottomBar : $sessionID Type : ${sessionID.runtimeType}');
      });
    }

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (Route<dynamic> route) => false, // ลบ stack ทั้งหมด
          arguments: sessionID, // ส่ง arguments
        );

        // Navigator.pushNamed(
        //   context,
        //   '/home',
        //   arguments: sessionID,
        // );
        // Navigator.pushReplacementNamed(
        //   context,
        //   '/home',
        //   arguments: sessionID, // ส่ง sessionID เป็น arguments
        // );
        // Navigator.popUntil(context, (route) => route.isFirst);
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
      enableDrag: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 1.0,
          minChildSize: 0.41,
          maxChildSize: 1.0,
          expand: false,
          builder: (_, controller) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Stack(
                children: [
                  Container(
                    color: Colors.transparent,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: ListView(
                        controller: controller,
                        children: [
                          ListTile(
                            leading: Icon(Icons.logout_outlined),
                            title: Text('Sign Out'),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.password_outlined),
                            title: Text('Change Password'),
                            onTap: () {
                              print('Change Password');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
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
        color:
            const Color.fromRGBO(255, 255, 255, 1), // Set the background color
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
        backgroundColor:
            Colors.white, // Set to transparent to use the container's color
      ),
    );
  }
}
