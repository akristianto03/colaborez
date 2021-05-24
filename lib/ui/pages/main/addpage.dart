part of '../pages.dart';

class AddPost extends StatefulWidget {

  static String routeName = "/addpost";

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  PickedFile imageFile;
  final ImagePicker imagePicker = ImagePicker();
  final ctrlTitle = TextEditingController();
  final ctrlDesc = TextEditingController();
  String dropdownValue = "Culinary";
  int participant = 2;

  Future chooseFile(String type) async{
    ImageSource imgSrc;
    if (type == "camera") {
      imgSrc = ImageSource.camera;
    }else{
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
        builder: (ctx){
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text("Pick image from:"),
            actions: [
              ElevatedButton.icon(
                onPressed: () {chooseFile("camera");},
                icon: Icon(Icons.camera_alt),
                label: Text("Camera"),
              ),
              ElevatedButton.icon(
                onPressed: () {chooseFile("gallery");},
                icon: Icon(Icons.photo_album_rounded),
                label: Text("Gallery"),
              )
            ],
          );
        }
    );
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Idea'
        ),
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
                            // padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
                            color: cSeccondaryColor,
                            width: getProportionateScreenWidth(200),
                            height: getProportionateScreenHeight(150),
                            child: imageFile == null ? IconButton(
                              onPressed: () {
                                showFileDialog(context);
                              },
                              icon: Icon(
                                Icons.add_circle,
                                color: cTextColor,
                              ),
                              iconSize: 40,
                            ) : Semantics(
                              child: GestureDetector(
                                onTap: () {
                                  showFileDialog(context);
                                },
                                child: Image.file(
                                  File(imageFile.path),
                                  width: 100,
                                ),
                              )
                            )
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.05,),

                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                buildFormTitle(),
                                SizedBox(height: getProportionateScreenHeight(20),),
                                buildFormDesc(),
                                SizedBox(height: getProportionateScreenHeight(20),),
                                buildFormCategory(),
                                SizedBox(height: getProportionateScreenHeight(20),),
                                buildIdeaParticipant(),
                                SizedBox(height: getProportionateScreenHeight(20),),
                                FormError(errors: errors),
                                SizedBox(height: getProportionateScreenHeight(20),),
                                DefaultButton(
                                  press: () async {
                                    if (_formKey.currentState.validate() && imageFile != null) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      Ideas ideas = Ideas("", ctrlTitle.text, ctrlDesc.text, dropdownValue, "", participant, 1, "", "", "");
                                      await IdeaServices.addIdea(ideas, imageFile).then((value) {
                                        if (value == true) {
                                          ActivityServices.showToast("Idea posted", cPrimaryColor);
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.pushNamedAndRemoveUntil(context, MainMenu.routeName, ModalRoute.withName('/'));
                                        } else {
                                          ActivityServices.showToast("Error post idea", cPrimaryColor);
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.pushReplacementNamed(context, MainMenu.routeName);
                                        }
                                      });
                                    }
                                  },
                                  text: "Post Idea",
                                )
                              ],
                            ),
                          ),

                          SizedBox(height: SizeConfig.screenHeight * 0.05,),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        ),
      ),
    );
  }

  DropdownButtonFormField<String> buildFormCategory() {
    return DropdownButtonFormField<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      onChanged: (value) {
        setState(() {
          dropdownValue = value;
        });
      },
      items: <String>['Culinary', 'Services', 'Design', 'Photography/Viedography', 'Non-Profit', 'Industry']
        .map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
      }).toList(),
      decoration: InputDecoration(
        labelText: "Select Category",
        hintText: "Select Category",
        alignLabelWithHint: true,
      ),
    );
  }

  TextFormField buildFormDesc() {
    return TextFormField(
      controller: ctrlDesc,
      maxLines: 3,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            removeError(error: cDescNullError);
          });
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          setState(() {
            addError(error: cDescNullError);
          });
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Description",
        hintText: "Enter description for your idea",
        alignLabelWithHint: true,
      ),
    );
  }

  TextFormField buildFormTitle() {
    return TextFormField(
      controller: ctrlTitle,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            removeError(error: cTitleNullError);
          });
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          setState(() {
            addError(error: cTitleNullError);
          });
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Title",
        hintText: "Enter title for your idea",
      ),
    );
  }

  Container buildIdeaParticipant() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 8,
              offset: Offset(0, 3),
            )
          ]
      ),
      child: Column(
        children: [
          Text("Number of Participants"),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButtonBorder(
                  press: () {
                    setState(() {
                      if (participant > 2) {
                        participant--;
                      }else{
                        ActivityServices.showToast("Min participants is 2!", cDangerColor);
                      }
                    });
                  },
                  icon: Icons.remove,
                ),
                SizedBox(width: getProportionateScreenWidth(25),),
                Text(
                  participant.toString(),
                  style: TextStyle(
                    fontSize: 52,
                    color: cPrimaryColor,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(25),),
                IconButtonBorder(
                  press: () {
                    setState(() {
                      if (participant < 20) {
                        participant++;
                      }else{
                        ActivityServices.showToast("Max participants is 20!", cDangerColor);
                      }
                    });
                  },
                  icon: Icons.add,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
