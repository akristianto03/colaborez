part of 'pages.dart';

class Register extends StatelessWidget {

  static String routeName = "/register";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.02,),
                Text(
                  "Register Account",
                  style: headingStyle
                ),
                Text(
                  "Complete your details or continue \nwith social media",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06,),
                RegisterForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.06,),
                // SocialCard(
                //   icon: "assets/icons/googleIcon.svg",
                //   press: () {},
                // ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Text(
                  "By continuing your confirm that you agree \nwith our Term and Condition",
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formkey = GlobalKey<FormState>();
  final ctrlEmail = TextEditingController();
  final ctrlPass = TextEditingController();
  final ctrlPass2 = TextEditingController();
  final List<String> errors = [];
  bool isVisible = true;

  void addError({String error}) {
    if (!errors.contains(error)) {
      errors.add(error);
    }
  }

  void removeError({String error}) {
    if (errors.contains(error)) {
      errors.remove(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          buildFormEmail(),
          SizedBox(height: getProportionateScreenHeight(30),),
          buildFormPassword(),
          SizedBox(height: getProportionateScreenHeight(30),),
          buildFormConfirmPassword(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40),),
          DefaultButton(
            press: () {
              if (_formkey.currentState.validate()) {
                if (ctrlPass2.text == ctrlPass.text) {
                  Navigator.pushNamed(
                    context,
                    CompleteRegister.routeName,
                    arguments: EmailPassArgument(ctrlEmail.text, ctrlPass.text),
                  );
                }
              }
            },
            text: "Continue",
          )
        ],
      ),
    );
  }

  TextFormField buildFormConfirmPassword() {
    return TextFormField(
      obscureText: isVisible,
      controller: ctrlPass2,
      onChanged: (value){
        if (ctrlPass2.text == ctrlPass.text) {
          setState(() {
            removeError(error: cMatchPassError);
          });
        }
      },
      validator: (value){
        if (value.isEmpty) {
          return "";
        } else if (ctrlPass2.text != ctrlPass.text) {
          setState(() {
            addError(error: cMatchPassError);
          });
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Confirm Password",
          hintText: "Re-enter your password",
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: new GestureDetector(
            onTap: () {
              setState(() {
                isVisible = !isVisible;
              });
            },
            child: CustomSuffixIcon(
              icon: Icon(
                  isVisible ?
                  Icons.visibility :
                  Icons.visibility_off
              ),
            ),
          )
      ),
    );
  }

  TextFormField buildFormPassword() {
    return TextFormField(
      obscureText: true,
      controller: ctrlPass,
      onChanged: (value){
        if (value.isNotEmpty) {
          setState(() {
            removeError(error: cPassNullError);
          });
        } if (value.length > 8 || value.isEmpty) {
          setState(() {
            removeError(error: cShortPassError);
          });
        }
      },
      validator: (value){
        if (value.isEmpty) {
          setState(() {
            addError(error: cPassNullError);
          });
          return "";
        } else if (value.length < 8) {
          setState(() {
            addError(error: cShortPassError);
          });
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Password",
          hintText: "Enter your password",
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSuffixIcon(icon: Icon(Icons.lock),)
      ),
    );
  }

  TextFormField buildFormEmail() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: ctrlEmail,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            removeError(error: cEmailNullError);
          });
        } if (emailValidatorRegExp.hasMatch(value) || value.isEmpty) {
          setState(() {
            removeError(error: cInvalidEmailError);
          });
        }
      },
      validator: (value){
        if (value.isEmpty) {
          setState(() {
            addError(error: cEmailNullError);
          });
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          setState(() {
            addError(error: cInvalidEmailError);
          });
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Email",
          hintText: "Enter your email",
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSuffixIcon(icon: Icon(Icons.email),)
      ),
    );
  }
}

