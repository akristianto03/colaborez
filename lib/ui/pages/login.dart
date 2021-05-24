part of 'pages.dart';

class Login extends StatefulWidget {

  static String routeName = "/login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final ctrlEmail = TextEditingController();
  final ctrlPass = TextEditingController();
  bool remember = false;
  bool isVisible = true;
  final List<String> errors = [];

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
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: SizeConfig.screenHeight * 0.02,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(0.025)),
                            padding: EdgeInsets.all(getProportionateScreenWidth(0.025)),
                            height: getProportionateScreenHeight(40),
                            width: getProportionateScreenWidth(40),
                            child: SvgPicture.asset(
                              "assets/icons/logopolos.svg",
                              color: cPrimaryColor,
                            ),
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.02,),
                          Text(
                            "Welcome Back",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(20),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Sign in with your email and password \nor continue with social media",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.05,),

                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                buildFormEmail(),
                                SizedBox(height: getProportionateScreenHeight(30),),
                                buildFormPassword(),
                                SizedBox(height: getProportionateScreenHeight(30),),
                                // Row(
                                //   children: [
                                //     Checkbox(
                                //       value: remember,
                                //       activeColor: cPrimaryColor,
                                //       onChanged: (value){
                                //         setState(() {
                                //           remember = value;
                                //         });
                                //       },
                                //     ),
                                //     Text("Remember me"),
                                //     Spacer(),
                                //     Text(
                                //       "Forgot Password",
                                //       style: TextStyle(decoration: TextDecoration.underline),
                                //     ),
                                //   ],
                                // ),
                                FormError(errors: errors),
                                SizedBox(height: getProportionateScreenHeight(20),),
                                DefaultButton(
                                  press: () async{
                                    if (_formKey.currentState.validate()) {
                                    // _formKey.currentState.save();
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await AuthServices.signIn(ctrlEmail.text, ctrlPass.text).then((value) {
                                        if (value == "success") {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          ActivityServices.showToast("Welcome!", cPrimaryColor);
                                          Navigator.pushReplacementNamed(context, MainMenu.routeName);
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          ActivityServices.showToast("Can't Login", cDangerColor);
                                        }
                                      });
                                    }
                                  },
                                  text: "Login",
                                )
                              ],
                            ),
                          ),

                          SizedBox(height: SizeConfig.screenHeight * 0.05,),
                          // SocialCard(
                          //   icon: "assets/icons/googleIcon.svg",
                          //   press: () {},
                          // ),
                          SizedBox(height: getProportionateScreenHeight(20),),
                          NoAccountText()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              isLoading == true
                  ? ActivityServices.loadings()
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildFormPassword() {
    return TextFormField(
      obscureText: isVisible,
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
              )
          )
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



