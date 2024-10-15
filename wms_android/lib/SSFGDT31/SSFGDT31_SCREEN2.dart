import 'package:flutter/material.dart';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'SSFGDT31_SEARCH_DOC.dart'; // Make sure the file name and class name match
import 'SSFGDT31_ADD_DOC.dart';

class SSFGDT31_SCREEN2 extends StatefulWidget {
  final String pWareCode;

  SSFGDT31_SCREEN2({
    Key? key,
    required this.pWareCode,
  }) : super(key: key);

  @override
  _SSFGDT31_SCREEN2State createState() => _SSFGDT31_SCREEN2State();
}

class _SSFGDT31_SCREEN2State extends State<SSFGDT31_SCREEN2> {
  @override
  void initState() {
    super.initState();
    print('pWareCode: ${widget.pWareCode}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(title: 'รับคืนจากการเบิกผลิต', showExitWarning: false),
      backgroundColor: Color.fromARGB(255, 17, 0, 56),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              color: Color.fromARGB(255, 231, 231, 231),
              child: ListTile(
                leading: Image.asset(
                  'assets/images/search_doc.png',
                  width: 40,
                  height: 40,
                ),
                title: Text('ค้นหาเอกสาร', style: TextStyle(fontSize: 18)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SSFGDT31_SEARCH_DOC(pWareCode: widget.pWareCode)),
                  );
                },
              ),
            ),
            SizedBox(height: 5),
            Card(
              color: Color.fromARGB(255, 231, 231, 231),
              child: ListTile(
                leading: Image.asset(
                  'assets/images/add_doc.png',
                  width: 40,
                  height: 40,
                ),
                title: Text('สร้างเอกสาร', style: TextStyle(fontSize: 18)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SSFGDT31_ADD_DOC(pWareCode: widget.pWareCode)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
    );
  }
}
