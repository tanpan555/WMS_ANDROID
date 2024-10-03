import 'package:flutter/material.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import '../styles.dart';
import 'SSFGPC04_WAREHOUSE.dart';

class SSFGPC04_CARD extends StatefulWidget {
  final String soNo;
  final String date;
  final List<Map<String, dynamic>> selectedItems;

  const SSFGPC04_CARD({
    Key? key,
    required this.soNo,
    required this.date,
    required this.selectedItems,
  }) : super(key: key);

  @override
  _SSFGPC04_CARDState createState() => _SSFGPC04_CARDState();
}

class _SSFGPC04_CARDState extends State<SSFGPC04_CARD> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'ประมวลผลก่อนการตรวจนับ'),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final selectedItems = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SSFGPC04_WAREHOUSE(),
                      ),
                    );
                    if (selectedItems != null) {
                      setState(() {
                        widget.selectedItems.clear();
                        widget.selectedItems.addAll(selectedItems);
                      });
                    }
                  },
                  child: const Text(
                    'เลือกคลังสินค้า',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: AppStyles.cancelButtonStyle(),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => SSFGDT04_SCANBARCODE(
                    //       po_doc_no: widget.po_doc_no, // ส่งค่า po_doc_no
                    //       po_doc_type: widget.po_doc_type, // ส่งค่า po_doc_type
                    //       pWareCode: widget.pWareCode,
                    //       setqc: setqc ?? '',
                    //     ),
                    //   ),
                    // );
                  },
                  style: AppStyles.NextButtonStyle(),
                  child: Image.asset(
                    'assets/images/right.png', // เปลี่ยนเป็นเส้นทางของรูปภาพของคุณ
                    width: 20, // ปรับขนาดตามที่ต้องการ
                    height: 20, // ปรับขนาดตามที่ต้องการ
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedItems.length,
                itemBuilder: (context, index) {
                  final item = widget.selectedItems[index];
                  return Card(
                    child: ListTile(
                      title: Text(item['ware_code'] ?? 'null'),
                      subtitle: Text(item['ware_name'] ?? 'null'),
                    ),
                  );
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
