import 'package:flutter/material.dart';
import 'SSINDT01_POPUP.dart'; // Import the popup.dart file
import '../appbar.dart';
import '../drawer.dart';
import 'SSINDT01_SCANBARCODE.dart';


class Ssindt01GridDetail extends StatefulWidget {
  const Ssindt01GridDetail({super.key});

  @override
  _GridDetailState createState() => _GridDetailState();
}

class _GridDetailState extends State<Ssindt01GridDetail> {
  static const Map<int, TableColumnWidth> _columnWidths = {
    0: FixedColumnWidth(100),
    1: FixedColumnWidth(100),
    2: FixedColumnWidth(50),
    3: FixedColumnWidth(100),
    4: FixedColumnWidth(100),
    5: FixedColumnWidth(100),
    6: FixedColumnWidth(100),
  };

  // State variable to keep track of selected item
  String _selectedItem = '';
  int _selectedItemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // Use the CustomAppBar
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: Size(10, 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
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
                      minimumSize: Size(10, 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    onPressed: () {
                      // Code for Cancel button
                    },
                    child: const Text(
                      'ดึง PO',
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
                      minimumSize: Size(10, 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    onPressed: () {
                      // Code for Delete button
                    },
                    child: const Text(
                      'ลบ PO',
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
                      minimumSize: Size(10, 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    onPressed: () {
                      // Code for Print Tag button
                    },
                    child: const Text(
                      'พิมพ์ Tag',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 35),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: Size(10, 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Ssindt01Scanbarcode(),
                        ),
                      ); // Code for Next button
                    },
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
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: _buildFormFields(),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.yellow[200], // Light yellow background
              border: Border.all(
                  color: Colors.black,
                  width: 2.0), // Black border with width 2.0
              borderRadius: BorderRadius.circular(0),
            ),
            child: Center(
              child: Text(
                'PO-CP0000-0000',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28, // Adjust the font size as needed
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Text(
            'เลขที่เอกสาร WMS*',
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 14, // Adjust the font size as needed
            ),
          ),
          const SizedBox(height: 8.0),
          Center(
            child: Text(
              'WM-D00-0000000',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24, // Adjust the font size as needed
              ),
            ),
          ),
          const SizedBox(height: 25),
          _buildTable(),
          // Add more fields here as needed
        ],
      ),
    );
  }

  int getTotalRowCount() {
    return 2;
  }

  Widget _buildTable() {
  final int totalRowCount = getTotalRowCount();

  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color:  Color.fromARGB(255, 224, 224, 224), width: 2.0), // Border around the table
          borderRadius: BorderRadius.circular(4.0), // Optional: for rounded corners
        ),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Container(
                    color: Colors.grey[200], // Light gray background for header
                    child: Table(
                      border: TableBorder(
                          // Optional: Add border styling if needed
                          ),
                      columnWidths: _columnWidths, // Use the defined constant
                      children: [
                        TableRow(
                          children: [
                            _buildTableCell('Item', true),
                            _buildTableCell('จำนวนรับ', true),
                            _buildTableCell(' ', true),
                            _buildTableCell('ค้างรับ', true),
                            _buildTableCell('Locator', true),
                            _buildTableCell('จำนวน', true),
                            _buildTableCell('UOM', true),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 300, // Set a fixed height to the table body
                    child: Table(
                      border: TableBorder.all(
                          color: Color.fromARGB(255, 224, 224, 224), width: 1.5),
                      columnWidths: _columnWidths, // Use the defined constant
                      children: List<TableRow>.generate(
                        totalRowCount, // Number of rows
                        (index) => TableRow(
                          children: [
                            _buildTableCell('Item $index', false, onTap: () {
                              setState(() {
                                _selectedItem = 'Item $index';
                                _selectedItemCount = 1; // Simulating selection of one item
                              });
                            }),
                            _buildTableCell('10', false),
                            _buildTableCellWithButton('Lot', false),
                            _buildTableCell('5', false),
                            _buildTableCell('A1', false),
                            _buildTableCell('15', false),
                            _buildTableCell('PCS', false),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[200], // Light gray background
                border: Border.all(
                  color: Color.fromARGB(255, 224, 224, 224), // Border color
                  width: 2.0, // Border width
                ),
                borderRadius: BorderRadius.circular(4.0), // Optional: for rounded corners
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items to opposite ends
                children: [
                  Visibility(
                    visible: _selectedItemCount > 0, // Show only when items are selected
                    child: Text(
                      '$_selectedItemCount rows selected',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    'Total $totalRowCount',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16.0),
      // Add the display-only TextField here
      TextField(
        controller: TextEditingController(text: _selectedItem),
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Item Desc',
          border: OutlineInputBorder(),
        ),
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 16.0),
      Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // Set desired fraction of screen width
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white, // Light yellow background
            border: Border.all(color: Colors.black, width: 2.0), // Black border with width 2.0
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: Center(
            child: Text(
              '0 : 0',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 28, // Adjust the font size as needed
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

  Widget _buildTableCell(String text, bool isHeader, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              fontSize: isHeader ? 14 : 16,
            ),
            overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
            maxLines: 1, // Ensure single line
          ),
        ),
      ),
    );
  }

  Widget _buildTableCellWithButton(String buttonText, bool isHeader) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isHeader ? Colors.grey[200] : Color.fromARGB(255, 52, 60, 84),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            minimumSize: Size(40, 30),
          ),
          onPressed: () {
            showLotDialog(context);
          },
          child: Text(
            buttonText,
            style: TextStyle(
              color: isHeader ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
