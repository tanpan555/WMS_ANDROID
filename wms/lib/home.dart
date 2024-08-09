import 'package:flutter/material.dart';
import 'package:wms/CardTest.dart';
import 'package:wms/main.dart';




class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  String? selectedPage;

  void _navigateToPage(String page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          switch (page) {
            case 'cardtest':
              return CardTest();
               default:
              return HomePage();
          }
        },
      ),
    ).then((_) {
      setState(() {
        selectedPage = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                selectedPage = value;
                _navigateToPage(selectedPage!);
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'cardtest',
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.info, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('cardtest'),
                    ],
                  ),
                ),
            
              ];
            },
            child: Row(
              children: <Widget>[
                Icon(Icons.arrow_drop_down_sharp,size: 50.0),
                SizedBox(width: 10,height: 50,),
                Text(selectedPage ?? 'เลือกหน้า'),
              ],
            ),
          ),
        ),
        
      ),
    );
  }
}