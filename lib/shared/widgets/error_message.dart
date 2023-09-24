import 'package:flutter/material.dart';

Widget buildErrorMessage(BuildContext context, String message,
    {Alignment alignment = Alignment.topLeft,
    EdgeInsets padding = const EdgeInsets.only(left: 14, bottom: 11)}) {
  return Container(
    alignment: alignment,
    padding: padding,
    child: Text(
      message,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(fontSize: 12, color: Colors.red),
    ),
  );
}
