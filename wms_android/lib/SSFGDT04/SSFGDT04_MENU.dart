import 'package:flutter/material.dart';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'SSFGDT04_SEARCH.dart';
import 'SSFGDT04_TYPE.dart';
// import 'package:wms_android/custom_drawer.dart';

class SSFGDT04_MENU extends StatelessWidget {
  final String pWareCode;
  final String pErpOuCode;

  const SSFGDT04_MENU({
    super.key,
    required this.pWareCode,
    required this.pErpOuCode,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    return Scaffold(
      appBar:
          CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              color: const Color.fromARGB(255, 231, 231, 231),
              child: ListTile(
                leading: Image.asset(
                  'assets/images/search_doc.png',
                  width: 40,
                  height: 40,
                ),
                title:
                    const Text('ค้นหาเอกสาร', style: TextStyle(fontSize: 18)),
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
            const SizedBox(height: 5),
            Card(
              color: const Color.fromARGB(255, 231, 231, 231),
              child: ListTile(
                leading: Image.asset(
                  'assets/images/add_doc.png',
                  width: 40,
                  height: 40,
                ),
                title:
                    const Text('สร้างเอกสาร', style: TextStyle(fontSize: 18)),
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
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
    );
  }
}
