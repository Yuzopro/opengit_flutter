import 'package:flutter/material.dart';

class HeaderItem extends StatelessWidget {
  const HeaderItem({this.titleColor, this.leftIcon, this.title, Key key})
      : super(key: key);

  final Color titleColor;
  final IconData leftIcon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 8.0,
        ),
        Container(
          color: Colors.white,
          height: 56.0,
          padding: EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                leftIcon ?? Icons.whatshot,
                color: titleColor ?? Colors.blueAccent,
              ),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: titleColor ?? Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
