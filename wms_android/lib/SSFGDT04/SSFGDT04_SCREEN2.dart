import 'package:flutter/material.dart';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'SSFGDT04_SEARCH.dart';
import 'SSFGDT04_TYPE.dart';

class SSFGDT04_SCREEN2 extends StatelessWidget {
  final String pWareCode;
  final String pErpOuCode;
  SSFGDT04_SCREEN2({
    Key? key,
    required this.pWareCode,
    required this.pErpOuCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('คุณได้เลือกคลัง: $pWareCode'),
      //     duration: Duration(seconds: 2),
      //   ),
      // );
    });

    return Scaffold(
      appBar: CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)'),
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
                      builder: (context) => SSFGDT04_SEARCH(
                        pWareCode: pWareCode,
                        pErpOuCode: pErpOuCode,
                      ),
                    ),
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
                        builder: (context) => SSFGDT04_TYPE(
                              pWareCode: pWareCode,
                              pErpOuCode: pErpOuCode,
                            )),
                  );
                  // Action for "สร้างเอกสาร"
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}