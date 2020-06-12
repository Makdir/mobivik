import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProjectIcons{

  static final Widget settingsIcon = SvgPicture.asset(
    'assets/svg/settings.svg',
    semanticsLabel: 'Settings',
  );

  static final Widget goodsList = SvgPicture.asset(
    'assets/svg/goods_list.svg',
    semanticsLabel: 'Goods List',
  );

  static final Widget invoice = SvgPicture.asset(
    'assets/svg/invoice.svg',
    semanticsLabel: 'Invoice',
  );

  static final Widget save = SvgPicture.asset(
    'assets/svg/save.svg',
    semanticsLabel: 'Save',
  );

  static final Widget trash = SvgPicture.asset(
    'assets/svg/trash.svg',
    semanticsLabel: 'Trash',
  );

}