import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'SSFGDT31_search.dart';
import 'SSFGDT31_select_doc_type.dart';

class Ssfgdt31Menu extends StatefulWidget {
  final String pWareCode;
  final String pWareName;

  const Ssfgdt31Menu({
    Key? key,
    required this.pWareCode,
    required this.pWareName,
  }) : super(key: key);

  @override
  _Ssfgdt31MenuState createState() => _Ssfgdt31MenuState();
}

class _Ssfgdt31MenuState extends State<Ssfgdt31Menu> {
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
          Ssfgdt31Search(
            pWareCode: widget.pWareCode,
            pWareName: widget.pWareName,
          ));
    }
    if (checkCard == 'สร้างเอกสาร') {
      return _navigateToPage(
          context,
          Ssfgdt31SelectDocType(
            pWareCode: widget.pWareCode,
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
      appBar: CustomAppBar(
          title: 'รับคืนจากการเบิกเพื่อผลผลิต', showExitWarning: false),
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
