import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'SSFGDT09L_search.dart';
import 'SSFGDT09L_select_doc_type.dart';

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
  List<dynamic> dataLovDocType = [];

  Map<String, dynamic>? selectedDocTypeItem;

  String docTypeLovD = '';
  String docTypeLovR = '';
  String chkCardName = '';
  String statusChkCreate = '';
  String messageChkCreate = '';
  String poDocType = '';
  String poDocNo = '';

  void checkName(String checkCard) {
    if (checkCard == 'ค้นหาเอกสาร') {
      return _navigateToPage(
          context,
          Ssfgdt09lSearch(
            pWareCode: widget.pWareCode,
            pWareName: widget.pWareName,
            pErpOuCode: widget.pErpOuCode,
            pOuCode: widget.pOuCode,
            pAttr1: widget.pAttr1,
          ));
    }
    if (checkCard == 'สร้างเอกสาร') {
      return _navigateToPage(
          context,
          Ssfgdt09lSelectDocType(
            pWareCode: widget.pWareCode,
            pErpOuCode: widget.pErpOuCode,
            pOuCode: widget.pOuCode,
            pAttr1: widget.pAttr1,
          ));
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
      appBar: CustomAppBar(title: 'เบิกจ่าย', showExitWarning: false),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: dataMenu[0]['items'].map<Widget>((item) {
                // IconData iconData;
                Color cardColor;
                String imagePath;

                switch (item['card_name']) {
                  case 'ค้นหาเอกสาร':
                    // iconData = Icons.search;
                    cardColor = Colors.grey[300]!;
                    imagePath = 'assets/images/search_doc.png';
                    break;
                  case 'สร้างเอกสาร':
                    // iconData = Icons.list;
                    cardColor = Colors.grey[300]!;
                    imagePath = 'assets/images/add_doc.png';
                    break;
                  default:
                    // iconData = Icons.help_outline;
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
                      width: 40,
                    ),
                    title: Text('${item['card_name']}',
                        style: const TextStyle(fontSize: 18)),
                    // trailing: Icon(iconData),
                    onTap: () {
                      setState(() {
                        chkCardName = item['card_name'] ?? '';
                        checkName(chkCardName);
                      });
                      // String cardName = item['card_name'] ?? '';
                      // Widget? pageWidget = checkName(cardName);

                      // if (pageWidget != null) {
                      //   _navigateToPage(context, pageWidget);
                      // } else {}
                    },
                  ),
                );
              }).toList(),
            )),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        currentPage: 'not_show',
      ),
    );
  }
}
