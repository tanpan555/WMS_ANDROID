import 'package:flutter/material.dart';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'SSFGDT31_SEARCH_DOC.dart'; // ตรวจสอบให้แน่ใจว่าชื่อไฟล์และชื่อคลาสตรงกัน
import 'SSFGDT31_ADD_DOC.dart';

class SSFGDT31_SCREEN2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'รับคืนจากการเบิกผลิต'),
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
                        builder: (context) => SSFGDT31_SEARCH_DOC()),
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
                    MaterialPageRoute(builder: (context) => SSFGDT31_ADD_DOC()),
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