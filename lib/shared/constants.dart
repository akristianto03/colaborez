part of 'shared.dart';

const cPrimaryColor = Color(0xFFFF8C10);
const cPrimaryLightColor = Color(0xFFFFECDF);
const cDangerColor = Color(0xFFFF7751);
const cSuccessColor = Color(0xFF5CDB32);
const cPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)]
);
const cSeccondaryColor = Color(0xFFF5F6F9);
const cTextColor = Color(0xFF757575);

const cAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
    fontSize: getProportionateScreenWidth(28),
    fontWeight: FontWeight.bold,
    color: Colors.black,
    height: 1.5,
);
const String cDefaultPicture = "assets/images/defaultProfilePic.png";

//Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String cEmailNullError = "Please Enter your email";
const String cInvalidEmailError = "Please enter valid email";
const String cPassNullError = "Please enter your password";
const String cShortPassError = "Password is too short";
const String cMatchPassError = "Passwords don't match";
const String cNameNullError = "Please enter your name";
const String cPhoneNumberNullError = "Please enter your phone number";
const String cAddressNullError = "Please enter  your address";
//main form
const String cTitleNullError = "Please enter title for your idea";
const String cDescNullError = "Please enter description for your idea";
