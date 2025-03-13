import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:wms_android/login.dart';
import 'styles.dart';

// SideSheet implementation
void showSideSheet({
  required BuildContext context,
  required Widget body,
  Color statusBarColor = Colors.transparent,
}) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: statusBarColor,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  ));

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (BuildContext buildContext, Animation animation,
        Animation secondaryAnimation) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: statusBarColor,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Material(
            child: SafeArea(
              child: body,
            ),
          ),
        ),
      );
    },
    transitionBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  ).then((_) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  });
}

class BottomBar extends StatefulWidget {
  final String currentPage;

  const BottomBar({Key? key, required this.currentPage}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  String sessionID = '';

  Future<void> _onItemTapped(int index) async {
    if (mounted) {
      setState(() {
        sessionID = globals.APP_SESSION;
        print(
            'sessionID in BottomBar : $sessionID Type : ${sessionID.runtimeType}');
      });
    }

    switch (index) {
      case 0:
        if (widget.currentPage == 'show') {
          bool? confirmResult = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return DialogStyles.warningNotSaveDialog(
                context: context,
                textMessage: 'ยืนยันที่จะย้อนกลับไปหน้าแรกหรือไม่',
                onCloseDialog: () => Navigator.of(context).pop(false),
                onConfirmDialog: () => Navigator.of(context).pop(true),
              );
            },
          );

          if (confirmResult == true) {
            if (mounted) {
              setState(() {
                _selectedIndex = index;
              });
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          }
        } else {
          // For 'not_show' or any other value
          if (mounted) {
            setState(() {
              _selectedIndex = index;
            });
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        }
        break;
      case 1:
        if (mounted) {
          setState(() {
            _selectedIndex = index;
          });
          _showRightDrawer(context);
        }
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
      statusBarColor: Colors.white,
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
            // icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            // icon: Icon(Icons.person_outline),
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
