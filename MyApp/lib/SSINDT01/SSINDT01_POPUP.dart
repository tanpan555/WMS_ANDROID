import 'package:flutter/material.dart';

void showLotDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Lot Detail'),
        content: SizedBox(
          width:
              MediaQuery.of(context).size.width * 0.8, // Adjust width as needed
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 103, 58, 183),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        minimumSize: Size(10, 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 55),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 103, 58, 183),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        minimumSize: Size(10, 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                      ),
                      onPressed: () {
                        // Code for Generate LOT button
                      },
                      child: const Text(
                        'Generate LOT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 103, 58, 183),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        minimumSize: Size(10, 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                      ),
                      onPressed: () {
                        // Code for Save button
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Item',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'จำนวน LOT',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 103, 58, 183),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              minimumSize: Size(10, 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                            ),
                            onPressed: () {
                              // Code for new button 1
                            },
                            child: const Text(
                              'เพิ่ม',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 103, 58, 183),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              minimumSize: Size(10, 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                            ),
                            onPressed: () {
                              // Code for new button 2
                            },
                            child: const Text(
                              'ลบ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Table
                      _buildTable(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

int getTotalRowCount() {
    return 2;
  }

Widget _buildTable() {
  final int totalRowCount = getTotalRowCount();
  final Map<int, TableColumnWidth> columnWidths = {
    0: FixedColumnWidth(100),
    1: FixedColumnWidth(100),
    2: FixedColumnWidth(50),
    3: FixedColumnWidth(100),
    4: FixedColumnWidth(100),
    5: FixedColumnWidth(100),
    6: FixedColumnWidth(100),
  };

  String _selectedItem = '';
  int _selectedItemCount = 0;

  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromARGB(255, 224, 224, 224), width: 2.0),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Container(
                    color: Colors.grey[200],
                    child: Table(
                      border: TableBorder(
                        horizontalInside: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      columnWidths: columnWidths,
                      children: [
                        TableRow(
                          children: [
                            _buildTableCell(' ', true),
                            _buildTableCell('Seq', true),
                            _buildTableCell('Lot QTY', true),
                            _buildTableCell('Lot ผู้ผลิต', true),
                            _buildTableCell('MFG Date.', true),
                            _buildTableCell('Lot NO.', true),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 300,
                    child: Table(
                      border: TableBorder.all(
                        color: Color.fromARGB(255, 224, 224, 224),
                        width: 1.5,
                      ),
                      columnWidths: columnWidths,
                      children: List<TableRow>.generate(
                        totalRowCount, // Number of rows
                        (index) => TableRow(
                          children: [
                            _buildTableCellWithButton('EDIT', false),
                            _buildTableCell('Seq $index', false, onTap: () {
                              // setState(() {
                              //   _selectedItem = 'Seq $index';
                              //   _selectedItemCount =
                              //       1; // Simulating selection of one item
                              // });
                            }),
                            _buildTableCell(' ', false),
                            _buildTableCell(' ', false),
                            _buildTableCell(' ', false),
                            _buildTableCell('212224', false),
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
                borderRadius:
                    BorderRadius.circular(4.0), // Optional: for rounded corners
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Align items to opposite ends
                children: [
                  Visibility(
                    visible: _selectedItemCount >
                        0, // Show only when items are selected
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

      const SizedBox(height: 8.0),
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
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
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
          backgroundColor:
              isHeader ? Colors.grey[200] : Color.fromARGB(255, 52, 60, 84),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          minimumSize: Size(40, 30),
        ),
        onPressed: () {
          // showLotDialog(context);
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
