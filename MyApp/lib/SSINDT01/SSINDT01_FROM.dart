import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'SSINDT01_GRID_DETAIL.dart'; // Import the next page
import '../appbar.dart';
import '../drawer.dart';


class Ssindt01From extends StatefulWidget {
  final Map<String, String> item;

  const Ssindt01From({super.key, required this.item});

  @override
  _FromState createState() => _FromState();
}

class _FromState extends State<Ssindt01From> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _invoiceDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add this line

  @override
  void initState() {
    super.initState();
    _dateController.text = ''; // Initialize with an empty string or default value if needed
    _invoiceDateController.text = ''; // Initialize with an empty string or default value if needed
  }

  @override
  void dispose() {
    _dateController.dispose();
    _invoiceDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Navigate to Page3 if the form is valid
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Ssindt01GridDetail()), // Navigate to Page3
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final item = widget.item; // Access the passed item

    return Scaffold(
      appBar: const CustomAppBar(), // Use the CustomAppBar
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Add this line
          child: Column(
            children: [
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: const Size(10, 20),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'ย้อนกลับ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: const Size(10, 20),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    onPressed: () {
                      // Code for Cancel button
                    },
                    child: const Text(
                      'ยกเลิก',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(), // Pushes the 'Next' button to the right
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: const Size(10, 20),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    onPressed: _submitForm, // Update onPressed to call _submitForm
                    child: const Text(
                      'ถัดไป',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildFormFields(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDisabledTextField(
            label: 'เลขที่อ้างอิง (PO)*',
            initialValue: widget.item['title'] ?? 'PO-XX1234-5678',
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'ประเภทรายการ',
              border: OutlineInputBorder(),
            ),
            items: <String>['1', '2'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
          const SizedBox(height: 16.0),
          _buildDatePickerField(
            label: 'วันที่เลือก',
            controller: _dateController,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'เลขที่ใบแจ้งหนี้ *',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกเลขที่ใบแจ้งหนี้';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          _buildDatePickerField(
            label: 'วันที่ใบแจ้งหนี้',
            controller: _invoiceDateController,
          ),
          const SizedBox(height: 16.0),
          _buildTextField(
            label: 'หมายเหตุ',
          ),
          const SizedBox(height: 16.0),
          _buildDisabledTextField(
            label: 'ผู้ขาย',
            initialValue: 'AP-0000000',
          ),
          const SizedBox(height: 16.0),
          _buildDisabledTextField(
            label: 'เลขที่เอกสาร WMS*',
            initialValue: 'WM-D00-0000000',
          ),
          const SizedBox(height: 16.0),
          _buildDisabledTextField(
            label: 'รับเข้าคลัง',
            initialValue: 'WH000 วัตถุดิบรับจ้างผลิต',
          ),
          const SizedBox(height: 16.0),
          _buildDisabledTextField(
            label: 'เลขที่ใบรับคลัง',
            initialValue: ' ',
          ),
          const SizedBox(height: 16.0),
          _buildDisabledTextField(
            label: 'ผู้รับ',
            initialValue: 'ss-xxxx',
          ),
          const SizedBox(height: 16.0),
          _buildDisabledTextField(
            label: 'วันที่บันทึก',
            initialValue: 'วัน/เดือน/ปี ชัวโมง:นาที:วินาที',
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerField(
      {required String label, required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () {
            _selectDate(context, controller);
          },
        ),
      ),
      readOnly: true,
      onTap: () {
        _selectDate(context, controller);
      },
    );
  }

  Widget _buildTextField({required String label}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDisabledTextField(
      {required String label, required String initialValue}) {
    return TextFormField(
      initialValue: initialValue,
      enabled: false,
      style: const TextStyle(
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[300],
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.black87,
        ),
      ),
    );
  }
}
