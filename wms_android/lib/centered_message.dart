import 'package:flutter/material.dart';

class CenteredMessage extends StatelessWidget {
  final String message;
  final TextStyle style;

  const CenteredMessage({
    Key? key,
    this.message = 'No data found',
    this.style = const TextStyle(color: Colors.white),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: style,
      ),
    );
  }
}
