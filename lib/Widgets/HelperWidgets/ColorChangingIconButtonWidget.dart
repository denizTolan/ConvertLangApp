import 'package:flutter/material.dart';

class ColorChangingIconButton extends StatefulWidget {
  @override
  _ColorChangingIconButtonState createState() => _ColorChangingIconButtonState();
}

class _ColorChangingIconButtonState extends State<ColorChangingIconButton> {
  bool isClicked = false;

  void handleClick() {
    setState(() {
      isClicked = !isClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.multitrack_audio),
      color: isClicked ? Colors.blue : Colors.black,
      onPressed: handleClick,
    );
  }
}
