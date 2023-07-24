import 'package:flutter/material.dart';

class DefaultColor {
  static double spacing = 10;
  //static const Color primary_color = Colors.blueGrey;
  //static const Color border_color = Colors.blueGrey;
  //static const Color refresh_text_color = Colors.blueGrey;
  //static const Color home_sub_title_color = Colors.blueGrey;
  //static const Color order_item_text_color = Colors.blueGrey;
  //static const Color message_item_text_color = Colors.blueGrey;
  //static const Color message_person_name_color = Colors.blueGrey;

  //static const Color pagebgCol = Color.fromARGB(201, 234, 238, 241);
  static const Color pagebgCol = Color.fromRGBO(177, 213, 200, 1);
  static const Color itembgCol = Colors.white;
  static const Color ButtonCol = Colors.black;
  static const Color DividerCol = Colors.black38;
  //static const Color ButtonCol = Colors.black;

}

class DefaultDecoration {
  static double spacing = 10;
  static double insert = 10;
  static double outsert = 10;

  static Decoration homePageItemDec = BoxDecoration(
    //border: Border.all(width: 2),
    //border: Border.all(width: 0),
    color: Colors.white,
    //boxShadow: [BoxShadow(color: Colors.white10)],
    borderRadius: BorderRadius.circular(12),
  );

  static Decoration gooditemDec = BoxDecoration(
      borderRadius: BorderRadius.circular(20.0), color: DefaultColor.itembgCol
      //border: Border.all(color: Colors.black38),
      );

  static Decoration buttonDec = BoxDecoration(
      borderRadius: BorderRadius.circular(40.0), color: DefaultColor.ButtonCol
      //border: Border.all(color: Colors.black38),
      );

  static Decoration userDec = const BoxDecoration(
      border: Border(
          left: BorderSide(color: Colors.black38),
          bottom: BorderSide.none,
          right: BorderSide.none,
          top: BorderSide(color: Colors.black38)));

  static Decoration UnderLineDecoration = const BoxDecoration(
      border: Border(
          left: BorderSide.none,
          bottom: BorderSide(color: Colors.black38),
          right: BorderSide.none,
          top: BorderSide.none));
}

class TextStyleDefault {
  static TextStyle UserSetFirst =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 15);

  static TextStyle IndividualText =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

  static TextStyle DetailedBook_Title =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

  static TextStyle DetailedBook_Price =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
}

class EdgeInsetsDefault {
  static EdgeInsets BookInfoBoxInset = EdgeInsets.all(20);
  static EdgeInsets BookImageInset = EdgeInsets.all(15);
}
