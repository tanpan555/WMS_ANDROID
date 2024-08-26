import 'package:flutter/material.dart';
import 'SSINDT01/SSINDT01_main.dart';
import 'SSFGDT04/SSFGDT04_main.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
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
                              builder: (context) => SSINDT01_MAIN()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                      title: const Text('รับตรง (ไม่อ้าง PO)'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SSFGDT04_MAIN()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                      title: const Text('Move Locator'),
                      onTap: () {
                        // _navigateToPage(context, '/');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                      title: const Text('Move Warehouse'),
                      onTap: () {
                        // _navigateToPage(context, '/');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                      title: const Text('เบิกจ่าย'),
                      onTap: () {
                        // _navigateToPage(context, '/');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.assignment_outlined,
                      ),
                      title: const Text('ตรวจนับ'),
                      onTap: () {
                        // _navigateToPage(context, '/');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.repeat,
                      ),
                      title: const Text('รับคืนจากการเบิกผลิตเพื่อผลผลิต'),
                      onTap: () {
                        // _navigateToPage(context, '/');
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
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                      title: const Text('รับตรง (ไม่อ้าง PO)'),
                      onTap: () {
                        // _navigateToPage(context, '/');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                      title: const Text('Move Locator'),
                      onTap: () {
                        // _navigateToPage(context, '/');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                      title: const Text('Move Warehouse'),
                      onTap: () {
                        // _navigateToPage(context, '/');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                      title: const Text('เบิกจ่าย'),
                      onTap: () {
                        // _navigateToPage(context, '/');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                      title: const Text('ตรวจนับ'),
                      onTap: () {
                        // _navigateToPage(context, '/');
                      },
                    ),
                    // สามารถเพิ่ม ListTile อื่นๆที่ต้องการได้ที่นี่
                  ],
                ),
                // ถ้าต้องการเพิ่ม ListTile อื่นๆ นอกเหนือจาก ExpansionTile สามารถเพิ่มที่นี่ได้
                ExpansionTile(
                  leading: const Icon(
                    Icons.discount_outlined,
                    color: Colors.black,
                  ),
                  title: const Text('พิมพ์ Tag',
                      style: TextStyle(color: Colors.black)),
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(
                        Icons.label_important_outline_rounded,
                      ),
                      title: const Text('Gen FG-Tag'),
                      onTap: () {
                        // _navigateToPage(context, '/');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.print_outlined,
                      ),
                      title: const Text('Reprint Tag ม้วน'),
                      onTap: () {
                        // _navigateToPage(context, '/');
                      },
                    ),
                    // Add more ListTiles here if needed
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(
                    Icons.folder_outlined,
                    color: Colors.black,
                  ),
                  title: const Text('ตรวจนับประจำงวด',
                      style: TextStyle(color: Colors.black)),
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                      title: const Text('ประมวลผลก่อนตรวจนับ'),
                      onTap: () {
                        // _navigateToPage(context, '/');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                      title: const Text('บันทึกตรวจนับ'),
                      onTap: () {
                        // _navigateToPage(context, '/');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                      title: const Text('รายงานเตรียมตรวจนับ'),
                      onTap: () {
                        // _navigateToPage(context, '/');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                      title: const Text('รายงานตรวจนับ'),
                      onTap: () {
                        // _navigateToPage(context, '/');
                      },
                    ),
                    // Add more ListTiles here if needed
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
