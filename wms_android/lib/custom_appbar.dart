import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showExitWarning;

  const CustomAppBar({
    super.key,
    this.title = 'WMS',
    this.showExitWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    print('showExitWarning : $showExitWarning');
    // return AppBar(
    //   centerTitle: false,
    //   backgroundColor: const Color.fromARGB(255, 17, 0, 56),
    //   iconTheme: const IconThemeData(
    //     color: Colors.white,
    //     size: 18, // Set the back icon color to white
    //   ),
    final isHomePage = ModalRoute.of(context)?.settings.name == '/home';
    return AppBar(
      automaticallyImplyLeading: false, //กำหนดการแสดงของ icon
      centerTitle: false,

      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      leading: isHomePage
          // padding: const EdgeInsets.symmetric(horizontal: 0),
          ? null //SizedBox()
          : IconButton(
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              ),
              onPressed: () async {
                if (showExitWarning) {
                  bool shouldLeave = await showExitWarningDialog(context);
                  if (shouldLeave) {
                    Navigator.pop(context);
                  }
                } else {
                  Navigator.pop(context);
                }
              },
            ),
      title: GestureDetector(
        onTap: () {
          // Navigate back to the main page
          // Navigator.popUntil(context, (route) => route.isFirst);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/images/app-logo.png',
              height: 40.0, // Adjust the height as needed
            ),
            const SizedBox(width: 5),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> showExitWarningDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(
                  Icons.notification_important,
                  color: Colors.red,
                ),
                SizedBox(width: 8),
                Text('แจ้งเตือน'),
              ],
            ),
            content: Text('คุณต้องการออกจากหน้านี้โดยไม่บันทึกหรือไม่?'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text('OK'),
                  ),
                ],
              )
              // TextButton(
              //   onPressed: () => Navigator.of(context).pop(false),
              //   child: Text('Cancel'),
              // ),
              // TextButton(
              //   onPressed: () => Navigator.of(context).pop(true),
              //   child: Text('OK'),
              // ),
            ],
          ),
        ) ??
        false; // กรณีผู้ใช้ปิด dialog โดยไม่เลือก จะคืนค่า false
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
