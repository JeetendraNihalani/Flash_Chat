import 'package:flutter/material.dart';

class ReuseButton extends StatelessWidget {
  ReuseButton(
      {@required this.label,
      @required this.onPress,
      @required this.ButtonColor});

  String label;
  Function onPress;
  Color ButtonColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: ButtonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
