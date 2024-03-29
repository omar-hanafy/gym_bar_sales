import 'package:flutter/material.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';

class TextStyles {
  final context;

  TextStyles({@required this.context});

  homeTitlesStyle() => TextStyle(
        fontSize: Dimensions(context).widthPercent(5),
        fontFamily: 'Tajawal',
      );

  billTitleStyle() =>
      TextStyle(fontSize: Dimensions(context).widthPercent(3), fontWeight: FontWeight.w900, fontFamily: 'Tajawal');

  //font 35 = percent 4
  billSearchTitleStyle() =>
      TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions(context).widthPercent(1.9), fontFamily: 'Tajawal');

  searchListItemStyle() => TextStyle(
        fontSize: Dimensions(context).widthPercent(1.5),
        fontFamily: 'Tajawal',
      );

  searchTextFieldStyle() => TextStyle(fontSize: Dimensions(context).widthPercent(1.5), color: Colors.grey[600]);

  searchTextFieldHintStyle() => TextStyle(fontSize: Dimensions(context).widthPercent(1.5), color: Colors.black54);

//font 25 = percent 1.9

  billTableTitleStyle() => TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: Dimensions(context).widthPercent(2.2),
      fontFamily: 'Tajawal',
      color: Colors.black);

// font 30 = 2.2
  billTableContentStyle() =>
      TextStyle(fontSize: Dimensions(context).widthPercent(1.9), fontFamily: 'Tajawal', color: Colors.black);

  billInfoStyle() =>
      TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions(context).widthPercent(1.9), fontFamily: 'Tajawal');

  billCustomInfoStyle(billChange) => TextStyle(
      color: billChange > 0 ? Colors.black : Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: Dimensions(context).widthPercent(1.9),
      fontFamily: 'Tajawal');

  billButtonStyle() =>
      TextStyle(fontSize: Dimensions(context).widthPercent(1.9), fontFamily: 'Tajawal', color: Colors.black);

  chipLabelStyleLight() =>
      TextStyle(fontSize: Dimensions(context).widthPercent(1.9), fontFamily: 'Tajawal', color: Colors.black);

  chipLabelStyle() =>
      TextStyle(fontSize: Dimensions(context).widthPercent(2.5), fontFamily: 'Tajawal', color: Colors.black);

  profileNameTitleStyle() => TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: Dimensions(context).widthPercent(2.2),
      fontFamily: 'Tajawal',
      color: Colors.black);

  listCashStyle(String type) => TextStyle(
        color: type == 'دائن' ? Colors.red : Colors.green,
        fontSize: Dimensions(context).widthPercent(5.5),
        fontFamily: 'Tajawal',
      );

  popupMenuButtonStyle() =>
      TextStyle(fontSize: Dimensions(context).widthPercent(2), fontFamily: 'Tajawal', color: Colors.black);

  appBarCalculationsStyle(cash) {
    if (double.parse(cash) <= 0) {
      return TextStyle(fontSize: Dimensions(context).widthPercent(2.2), fontFamily: 'Tajawal', color: Colors.red);
    }
    if (double.parse(cash) > 0) {
      return TextStyle(fontSize: Dimensions(context).widthPercent(2.2), fontFamily: 'Tajawal', color: Colors.green);
    }
  }

  appBarTextStyle() {
    return TextStyle(fontSize: Dimensions(context).widthPercent(2.0), fontFamily: 'Tajawal', color: Colors.black);
  }

// home_item styles
  itemImageTitle() => TextStyle(
      fontSize: Dimensions(context).widthPercent(4),
      fontWeight: FontWeight.bold,
      fontFamily: 'Tajawal',
      color: Colors.white);

  itemImageTitleSmall() => TextStyle(
      fontSize: Dimensions(context).widthPercent(2.5),
      fontWeight: FontWeight.bold,
      fontFamily: 'Tajawal',
      color: Colors.white);

  itemImageStatistics() =>
      TextStyle(fontSize: Dimensions(context).widthPercent(2), fontFamily: 'Tajawal', color: Colors.white);

// form_widget styles
  formLabelsStyle() => TextStyle(
        fontSize: Dimensions(context).widthPercent(1.5),
        fontFamily: 'Tajawal',
      );

  formButtonStyle() =>
      TextStyle(fontSize: Dimensions(context).widthPercent(1.9), fontFamily: 'Tajawal', color: Colors.white);

  formTitleStyle() =>
      TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions(context).widthPercent(1.9), fontFamily: 'Tajawal');

  // clients_tables styles
  clientTableTitleStyle() => TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: Dimensions(context).widthPercent(2.2),
      fontFamily: 'Tajawal',
      color: Colors.black);

  clientTableContentStyle() =>
      TextStyle(fontSize: Dimensions(context).widthPercent(1.5), fontFamily: 'Tajawal', color: Colors.black);

// clients_widgets styles
  iconTitle() => TextStyle(
      fontSize: Dimensions(context).widthPercent(1.5),
      fontWeight: FontWeight.bold,
      fontFamily: 'Tajawal',
      color: Colors.black);

  warningStyle() => TextStyle(fontSize: Dimensions(context).widthPercent(5));

  listTileTitleStyle() => TextStyle(fontSize: Dimensions(context).widthPercent(2));

  listTileSubtitleStyle(String type) => TextStyle(
        color: type == 'دائن' ? Colors.red : Colors.green,
        fontSize: Dimensions(context).widthPercent(1.5),
        fontFamily: 'Tajawal',
      );
}
