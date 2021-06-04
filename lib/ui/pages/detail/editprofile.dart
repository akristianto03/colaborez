part of '../pages.dart';

class EditProfileArgument {
  final Users users;

  EditProfileArgument(this.users);
}

class EditProfile extends StatefulWidget {
  static String routeName = '/editprofile';

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();
  TextEditingController ctrlFirstName = TextEditingController();
  TextEditingController ctrlLastName = TextEditingController();
  TextEditingController ctrlPhoneNumber = TextEditingController();
  TextEditingController ctrlAddress = TextEditingController();

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

  PickedFile imageFile;
  final ImagePicker imagePicker = ImagePicker();

  Future chooseFile(String type) async{
    ImageSource imgSrc;
    if (type == "camera") {
      imgSrc = ImageSource.camera;
    } else {
      imgSrc = ImageSource.gallery;
    }

    final selectedImage = await imagePicker.getImage(
      source: imgSrc,
      imageQuality: 50,
    );
    setState(() {
      imageFile = selectedImage;
    });
  }

  void showFileDialog(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text("Pick image from:"),
            actions: [
              ElevatedButton.icon(
                onPressed: () {
                  chooseFile("camera");
                },
                icon: Icon(Icons.camera_alt_outlined),
                label: Text("camera"),
              ),
              ElevatedButton.icon (
                onPressed: () {
                  chooseFile("gallery");
                },
                icon: Icon(Icons.picture_as_pdf_outlined),
                label: Text("Gallery"),
              )
            ],
          );
        }
    );
  }

  int con=0;
  @override
  Widget build(BuildContext context) {
    final EditProfileArgument args = ModalRoute.of(context).settings.arguments as EditProfileArgument;
    if (con==0) {
      ctrlAddress = TextEditingController(text: args.users.address);
      ctrlFirstName = TextEditingController(text: args.users.firstName);
      ctrlLastName = TextEditingController(text: args.users.lastName);
      ctrlPhoneNumber = TextEditingController(text: args.users.phone);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
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

                        //profilepic
                        SizedBox(
                          height: 115,
                          width: 115,
                          child: Stack(
                            fit: StackFit.expand,
                            overflow: Overflow.visible,
                            children: [
                              imageFile == null
                              ? CircleAvatar(
                                backgroundImage: args.users.pic == cDefaultPicture
                                      ?AssetImage(args.users.pic)
                                      :NetworkImage(args.users.pic)
                              )
                              : Semantics(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9999),
                                  child: Image.file(
                                    File(imageFile.path)
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -12,
                                bottom: 0,
                                child: SizedBox(
                                  height: 46,
                                  width: 46,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showFileDialog(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50),
                                          side: BorderSide(color: Colors.white)
                                      ),
                                      primary: cSeccondaryColor,
                                      elevation: 0,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: cTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(30),),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: SizeConfig.screenWidth * 0.4,
                                    height: getProportionateScreenHeight(56),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (_formkey.currentState.validate()) {
                                          setState(() {
                                            isLoading = true;
                                          });

                                          Users u = new Users(args.users.uid, args.users.email, args.users.password, ctrlFirstName.text, ctrlLastName.text, ctrlPhoneNumber.text, ctrlAddress.text, "", "", "");
                                          await AuthServices.upDate(u, imageFile).then((value){
                                            setState(() {
                                              isLoading = false;
                                            });
                                            if (value == true) {
                                              ActivityServices.showToast("Profile Updated", cPrimaryColor);
                                              Navigator.pushNamedAndRemoveUntil(context, MainMenu.routeName, ModalRoute.withName('/'));
                                            }else {
                                              ActivityServices.showToast("Failed to Update Profile", cDangerColor);
                                            }
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: cSuccessColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15)
                                          )
                                      ),
                                      child: Text(
                                        "Save",
                                        style: TextStyle(
                                            fontSize: getProportionateScreenWidth(18),
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    width: SizeConfig.screenWidth * 0.4,
                                    height: getProportionateScreenHeight(56),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: cDangerColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15)
                                          )
                                      ),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            fontSize: getProportionateScreenWidth(18),
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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