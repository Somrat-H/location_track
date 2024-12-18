import 'package:flutter/material.dart';

void navigateTo({required BuildContext context, required Widget widget}) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => widget),
  );
}
void navigateReplaceTo({required BuildContext context, required Widget widget}) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => widget),
  );
}
