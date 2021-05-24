part of 'shared.dart';

ThemeData lightTheme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Color(0xFFf2f2f2),
    primarySwatch: Colors.deepOrange,
    primaryColor: cPrimaryColor,
    accentColor: cPrimaryColor,

    fontFamily: "Muli",
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: Colors.white,
      elevation: 0,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      textTheme: TextTheme(
        headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18)
      ),
    ),
    textTheme:  TextTheme(
      bodyText1: TextStyle(color: cTextColor),
      bodyText2: TextStyle(color: cTextColor),
    ),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: cTextColor),
      gapPadding: 10
  );
  OutlineInputBorder outlineFocusBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: cPrimaryColor),
      gapPadding: 10
  );
  return InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 36, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineFocusBorder,
    border: outlineInputBorder,
  );
}