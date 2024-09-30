import 'package:flutter/material.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:wms_android/login.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  String sessionID = '';

  void _onItemTapped(int index) {
    setState(() {
      sessionID = globals.APP_SESSION;
      _selectedIndex = index;
      print('sessionID in BottomBar : $sessionID Type : ${sessionID.runtimeType}');
    });

    switch (index) {
      case 0:
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
      case 1:
        _showRightDrawer(context);
        break;
    }
  }

  void _showRightDrawer(BuildContext context) {
    showSideSheet(
      context: context,
      body: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        color: Colors.grey[300],
        child: ListView(
          children: [
            ListTile(
              leading: Image.asset(
                'assets/images/exit.png',
                width: 25,
                height: 25,
              ),
              title: Text('Sign Out', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
            const Divider(color: Colors.black26, thickness: 1),
            ListTile(
              leading: Image.asset(
                'assets/images/reset-password.png',
                width: 25,
                height: 25,
              ),
              title: Text('Change Password', style: TextStyle(fontSize: 16)),
              onTap: () {
                print('Change Password');
              },
            ),
            const Divider(color: Colors.black26, thickness: 1),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 1),
      ),
      child: BottomNavigationBar(
        showSelectedLabels: false,
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
        iconSize: 25,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
      ),
    );
  }
}

// Custom SideSheet implementation
void showSideSheet({
  required BuildContext context,
  required Widget body,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          child: SafeArea(
            child: body,
          ),
        ),
      );
    },
    transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}