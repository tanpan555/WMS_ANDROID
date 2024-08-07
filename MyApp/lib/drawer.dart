import 'package:flutter/material.dart';
import 'SSINDT01/SSINDT01_CARD.dart'; // นำเข้าไฟล์ page1.dart

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
                    Icons.inventory_2_outlined,
                    color: Colors.black,
                  ),
                  title: const Text('WMS คลังวัตถุดิบ',
                      style: TextStyle(color: Colors.black)),
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.arrow_circle_right_outlined
                          // color: Colors.black,
                          ),
                      title: const Text('รับจากการสั่งซื้อ'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Ssindt01Card()), // ลิงค์ไปยัง Page1() จาก page1.dart
                        );
                      },
                    ),
                    // สามารถเพิ่ม ListTile อื่นๆที่ต้องการได้ที่นี่
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.black,
                  ),
                  title: const Text('WMS คลังสำเร็จรูป',
                      style: TextStyle(color: Colors.black)),
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.arrow_circle_right_outlined
                          // color: Colors.black,
                          ),
                      title: const Text('รับจากการผลิต'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Ssindt01Card()), // ลิงค์ไปยัง Page1() จาก page1.dart
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
