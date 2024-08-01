import 'package:flutter/material.dart';
import 'SSINDT01/SSINDT01_card.dart';
import 'SSFGDT04/SSFGDT04_main.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: const Color(0xff764abc),
            height: 106.0, // Same height as the AppBar
            alignment: Alignment.center,
            // child: const Text(
            //   'Drawer Header',
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 20.0, // Adjust font size as needed
            //   ),
            // ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ExpansionTile(
                  leading: const Icon(
                    Icons.archive_outlined,
                    color: Colors.black,
                  ),
                  title: const Text('WMS คลังวัตถุดิบ', style: TextStyle(color: Colors.black)),
                  children: <Widget>[
                    ListTile(
                      title: const Text('รับจากการสั่งซื้อ'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Ssindt01Card()), // ลิงค์ไปยัง Page1() จาก page1.dart
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('รับตรง (ไม่อ้าง PO)'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Ssfgdt04Main()), // ลิงค์ไปยัง Page1() จาก page1.dart
                        );
                      },
                    ),
                    // สามารถเพิ่ม ListTile อื่นๆที่ต้องการได้ที่นี่
                  ],
                ),
                // ถ้าต้องการเพิ่ม ListTile อื่นๆ นอกเหนือจาก ExpansionTile สามารถเพิ่มที่นี่ได้
                // ListTile(
                //   leading: const Icon(
                //     Icons.train,
                //     color: Colors.black,
                //   ),
                //   title: const Text('Page 2', style: TextStyle(color: Colors.black)),
                //   onTap: () {
                //     Navigator.pop(context);
                //     // Add navigation action here if needed
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
