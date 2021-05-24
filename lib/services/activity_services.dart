part of 'services.dart';

class ActivityServices {

  static String dateNow() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String dateResult = formatter.format(now);
    return dateResult;
  }

  static void showToast(String msg, Color mycolor) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: mycolor,
      textColor: Colors.white,
      fontSize: 12
    );
  }

  static Container loadings() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      color: cSeccondaryColor,
      child: SpinKitChasingDots(
        size: 50,
        color: cPrimaryColor,
      ),
    );

  }
}