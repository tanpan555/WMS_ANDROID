import 'package:flutter/material.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'SSFGDT09L_search.dart';
// import 'SSFGDT17_MAIN.dart';

class Ssfgdt09lMenu extends StatefulWidget {
  final String pWareCode;
  final String pWareName;
  final String pErpOuCode;
  final String pOuCode;
  final String pAttr1;

  const Ssfgdt09lMenu({
    Key? key,
    required this.pWareCode,
    required this.pWareName,
    required this.pErpOuCode,
    required this.pOuCode,
    required this.pAttr1,
  }) : super(key: key);

  @override
  _Ssfgdt09lMenuState createState() => _Ssfgdt09lMenuState();
}

class _Ssfgdt09lMenuState extends State<Ssfgdt09lMenu> {
  List<dynamic> dataMenu = [
    {
      'items': [
        {'card_name': 'ค้นหาเอกสาร'},
        {'card_name': 'สร้างเอกสาร'},
      ]
    }
  ];

  Widget? checkName(String cardName) {
    // เช็คชื่่อและส่งไปตาม return
    switch (cardName) {
      case 'ค้นหาเอกสาร':
        return Ssfgdt09lSearch(
          pWareCode: widget.pWareCode,
          pWareName: widget.pWareName,
          pErpOuCode: widget.pErpOuCode,
          pOuCode: widget.pOuCode,
          pAttr1: widget.pAttr1,
        );
      default:
        return null;
    }
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF17153B),
      appBar: CustomAppBar(title: 'เบิกจ่าย'),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: dataMenu[0]['items'].map<Widget>((item) {
                IconData iconData;
                Color cardColor;
                String imagePath;

                switch (item['card_name']) {
                  case 'ค้นหาเอกสาร':
                    iconData = Icons.search;
                    cardColor = Colors.grey[300]!;
                    imagePath = 'assets/images/search_doc.png';
                    break;
                  case 'สร้างเอกสาร':
                    iconData = Icons.list;
                    cardColor = Colors.grey[300]!;
                    imagePath = 'assets/images/add_doc.png';
                    break;
                  default:
                    iconData = Icons.help_outline;
                    cardColor = Colors.grey;
                    imagePath = 'assets/images/dt_alert.png';
                }

                return Card(
                  elevation: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  color: cardColor,
                  child: ListTile(
                    leading: Image.asset(
                      imagePath,
                      width: 70,
                    ),
                    title: Text('ค้นหาเอกสาร'),
                    trailing: Icon(iconData),
                    onTap: () {
                      String cardName = item['card_name'] ?? '';
                      Widget? pageWidget = checkName(cardName);

                      if (pageWidget != null) {
                        _navigateToPage(context, pageWidget);
                      } else {}
                    },
                  ),
                );
              }).toList(),
            )),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
