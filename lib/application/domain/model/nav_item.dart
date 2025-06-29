
import 'package:flutter/cupertino.dart';

class NavItem {
  final String id;
  final String title;
  final String iconPath;
  final Widget Function(BuildContext)? screenBuilder;
  final void Function(BuildContext)? onTap;


  NavItem({
    required this.id,
    required this.title,
    required this.iconPath,
    this.screenBuilder,
    this.onTap
  });
}

