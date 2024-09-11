import 'package:flutter/material.dart';
import '../custom_appbar.dart';
import '../bottombar.dart';

class SSFGDT04_Screen_5 extends StatefulWidget {
  // final String pWareCode; // ware code ที่มาจาก lov
  final String po_doc_no;
  // final String po_doc_type;
  // // final String p_ref_no;
  // // final String mo_do_no;

  SSFGDT04_Screen_5({
      Key? key,
    //   required this.pWareCode,
    required this.po_doc_no,
    //   required this.po_doc_type,
    //   // required this.p_ref_no,
    //   // required this.mo_do_no,
  }) : super(key: key);
  @override
  _SSFGDT04Screen5State createState() => _SSFGDT04Screen5State();
}

class _SSFGDT04Screen5State extends State<SSFGDT04_Screen_5> {
  // List<String> _items = ['Item 1', 'Item 2', 'Item 3']; // ตัวอย่างข้อมูล
  late TextEditingController _docNoController;
  List<String> _deletedItems = [];

  @override
  void initState() {
    super.initState();
    // fetchGridItems();
    _docNoController = TextEditingController(text: widget.po_doc_no);
  }

  @override
  void dispose() {
    _docNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)'),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  // onPressed: fetchGetPo,
                  onPressed: () {},
                  child: Image.asset(
                    'assets/images/business.png', // เปลี่ยนเป็นเส้นทางของรูปภาพของคุณ
                    width: 30, // ปรับขนาดตามที่ต้องการ
                    height: 30, // ปรับขนาดตามที่ต้องการ
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(60, 40),
                    padding: const EdgeInsets.all(0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => SSFGDT04_Screen_5(
                    //         //       po_doc_no:
                    //         //                     widget.po_doc_no, // ส่งค่า po_doc_no
                    //         //                 po_doc_type: widget.po_doc_type ??
                    //         //                     '', // ส่งค่า po_doc_type
                    //         //                 pWareCode: widget.pWareCode,
                    //         //                 // p_ref_no: _refNoController.text ?? '',
                    //         //                 // mo_do_no: _moDoNoController.text ?? '',
                    //         ),
                    //   ),
                    // );
                    // await fetchData();
                    // เพิ่มโค้ดสำหรับการทำงานของปุ่มถัดไปที่นี่
                  },
                  child: Image.asset(
                    'assets/images/right.png', // เปลี่ยนเป็นเส้นทางของรูปภาพของคุณ
                    width: 20, // ปรับขนาดตามที่ต้องการ
                    height: 20, // ปรับขนาดตามที่ต้องการ
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(60, 40),
                    padding: const EdgeInsets.all(0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                borderRadius:
                    BorderRadius.circular(8), // Rounded corners (optional)
              ),
              child: Text(
                '${widget.po_doc_no}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
