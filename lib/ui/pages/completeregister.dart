part of 'pages.dart';

class EmailPassArgument {
  final String email;
  final String pass;

  EmailPassArgument(this.email, this.pass);
}

class CompleteRegister extends StatefulWidget {
  static String routeName = '/complete_register';

  @override
  _CompleteRegisterState createState() => _CompleteRegisterState();
}

class _CompleteRegisterState extends State<CompleteRegister> {

  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();
  final ctrlFirstName = TextEditingController();
  final ctrlLastName = TextEditingController();
  final ctrlPhoneNumber = TextEditingController();
  final ctrlAddress = TextEditingController();

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
    final EmailPassArgument args = ModalRoute.of(context).settings.arguments as EmailPassArgument;

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * 0.02,),
                        Text(
                          "Complete Profile",
                          style: headingStyle,
                        ),
                        Text(
                          "Complete your details or continue \nwith social media",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.06,),

                        Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              buildFormFirstName(),
                              SizedBox(height: getProportionateScreenHeight(30),),
                              buildFormLastName(),
                              SizedBox(height: getProportionateScreenHeight(30),),
                              buildFormPhoneNumber(),
                              SizedBox(height: getProportionateScreenHeight(30),),
                              buildFormAddress(),
                              FormError(errors: errors),
                              SizedBox(height: getProportionateScreenHeight(30),),
                              DefaultButton(
                                text: "Create Account",
                                press: () async {
                                  if (_formkey.currentState.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    Users u = new Users("",args.email,args.pass,ctrlFirstName.text,ctrlLastName.text,ctrlPhoneNumber.text,ctrlAddress.text,cDefaultPicture,"","");
                                    await AuthServices.signUp(u).then((value){
                                      setState(() {
                                        isLoading = false;
                                      });
                                      if (value == "success") {
                                        ActivityServices.showToast("Sign Up Success", cPrimaryColor);
                                        Navigator.pushNamedAndRemoveUntil(context, Login.routeName, ModalRoute.withName('/'));
                                      }else {
                                        ActivityServices.showToast("Failed to Sign Up", cDangerColor);
                                      }
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: SizeConfig.screenHeight * 0.06,),
                        Text(
                          "By continuing your confirm that you agree \nwith our Term and Condition",
                          textAlign: TextAlign.center,
                        )
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
    );
  }

  TextFormField buildFormAddress() {
    return TextFormField(
      controller: ctrlAddress,
      onChanged: (value){
        if (value.isNotEmpty) {
          removeError(error: cAddressNullError);
        }
        return null;
      },
      validator: (value){
        if (value.isEmpty) {
          addError(error: cAddressNullError);
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Address",
          hintText: "Enter your address",
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSuffixIcon(icon: Icon(Icons.pin_drop_outlined),)
      ),
    );
  }

  TextFormField buildFormPhoneNumber() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: ctrlPhoneNumber,
      onChanged: (value){
        if (value.isNotEmpty) {
          removeError(error: cPhoneNumberNullError);
        }
        return null;
      },
      validator: (value){
        if (value.isEmpty) {
          addError(error: cPhoneNumberNullError);
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Phone Number",
          hintText: "Enter your phone number",
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSuffixIcon(icon: Icon(CupertinoIcons.phone),)
      ),
    );
  }

  TextFormField buildFormLastName() {
    return TextFormField(
      controller: ctrlLastName,
      onChanged: (value){
        if (value.isNotEmpty) {
          removeError(error: cNameNullError);
        }
        return null;
      },
      validator: (value){
        if (value.isEmpty) {
          addError(error: cNameNullError);
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Last Name",
          hintText: "Enter your lastname",
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSuffixIcon(icon: Icon(CupertinoIcons.profile_circled),)
      ),
    );
  }

  TextFormField buildFormFirstName() {
    return TextFormField(
      controller: ctrlFirstName,
      onChanged: (value){
        if (value.isNotEmpty) {
          removeError(error: cNameNullError);
        }
        return null;
      },
      validator: (value){
        if (value.isEmpty) {
          addError(error: cNameNullError);
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "First Name",
          hintText: "Enter your firstname",
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSuffixIcon(icon: Icon(CupertinoIcons.profile_circled),)
      ),
    );
  }

}