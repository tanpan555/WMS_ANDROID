import 'package:flutter/material.dart';
// import 'package:wms_android/custom_appbar.dart';
// import 'package:wms_android/custom_drawer.dart';

class Ssindt01Form extends StatefulWidget {
  // final Map<String, dynamic> datas;
  // const Ssindt01Form({Key? key, required this.poReceiveNo}) : super(key: key);
  // const Ssindt01Form({Key? key) : super(key: key);
  const Ssindt01Form({Key? key}) : super(key: key);
  @override
  _Ssindt01FormState createState() => _Ssindt01FormState();
}

class _Ssindt01FormState extends State<Ssindt01Form> {
  
  @override
  Widget build(BuildContext context) {
    // final TextEditingController _firstNameController = TextEditingController(text: datas['po_no']);
    // final TextEditingController _lastNameController = TextEditingController(text: datas['l_name']);
    // final TextEditingController _fullNameController = TextEditingController(text: datas['full_name']);
    // final TextEditingController _nickNameController = TextEditingController(text: datas['nick_name']);
    // final TextEditingController _ageController = TextEditingController(text: datas['age'].toString());
    // final TextEditingController _companyController = TextEditingController(text: datas['company']);
    // final TextEditingController _positionController = TextEditingController(text: datas['position']);
    // final TextEditingController _salaryController = TextEditingController(text: datas['salary'].toStringAsFixed(2));
    // final TextEditingController _stockController = TextEditingController(text: datas['stock'].toStringAsFixed(2));
    // final TextEditingController _bonusController = TextEditingController(text: datas['bonus'].toStringAsFixed(2));
    // final TextEditingController _annualExpensesController = TextEditingController(text: datas['annual_expenses'].toStringAsFixed(2));
    return Scaffold(
      // appBar: const CustomAppBar(),
      // drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // child: Column(
          // children: [
          //   TextField(
          //           controller: _po_noController,
          //           decoration: const InputDecoration(labelText: 'เลขที่อ้างอิง (PO)'),
          //         ),
          //   TextField(
          //           controller: _firstNameController,
          //           decoration: const InputDecoration(labelText: 'ประเภทการรับ'),
          //         ),
          //   TextField(
          //           controller: _firstNameController,
          //           decoration: const InputDecoration(labelText: 'วันที่ตรวจรับ'),
          //         ),
          //   TextField(
          //           controller: _firstNameController,
          //           decoration: const InputDecoration(labelText: 'เลขที่ใบแจ้งหนี้'),
          //         ),
          //   TextField(
          //           controller: _firstNameController,
          //           decoration: const InputDecoration(labelText: 'วันที่ใบแจ้งหนี้'),
          //         ),
          //   TextField(
          //           controller: _firstNameController,
          //           decoration: const InputDecoration(labelText: 'หมายเหตุ'),
          //         ),
          //   TextField(
          //           controller: _firstNameController,
          //           decoration: const InputDecoration(labelText: 'ผู้ขาย'),
          //         ),
          //   TextField(
          //           controller: _firstNameController,
          //           decoration: const InputDecoration(labelText: 'เลขที่เอกสาร WMS'),
          //         ),
          //   TextField(
          //           controller: _firstNameController,
          //           decoration: const InputDecoration(labelText: 'รับเข้าคลัง'),
          //         ),
          //   TextField(
          //           controller: _firstNameController,
          //           decoration: const InputDecoration(labelText: 'เลขที่ใบรับคลัง'),
          //         ),
          //   TextField(
          //           controller: _firstNameController,
          //           decoration: const InputDecoration(labelText: 'ผู้รับ'),
          //         ),
          //   TextField(
          //           controller: _firstNameController,
          //           decoration: const InputDecoration(labelText: 'วันที่บันทึก'),
          //         ),
          // ],
        // ),
      ),
    );
  }
}
