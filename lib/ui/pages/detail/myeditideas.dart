part of '../pages.dart';

class MyEditArgument {
  final Ideas idea;

  MyEditArgument(this.idea);
}

class EditPost extends StatefulWidget {

  static String routeName = "/myeditideas";

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  PickedFile imageFile;
  final ImagePicker imagePicker = ImagePicker();
  String dropdownValue;
  int participant;
  TextEditingController ctrlTitle = TextEditingController();
  TextEditingController ctrlDesc = TextEditingController();

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
                style: ElevatedButton.styleFrom(
                  primary: cPrimaryColor
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {chooseFile("gallery");},
                icon: Icon(Icons.photo_album_rounded),
                label: Text("Gallery"),
                style: ElevatedButton.styleFrom(
                    primary: cPrimaryColor
                ),
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

  void initState() {
    super.initState();
  }
  int con=0;
  @override
  Widget build(BuildContext context) {
    final MyEditArgument args = ModalRoute.of(context).settings.arguments as MyEditArgument;
    if(con==0) {
      ctrlTitle = TextEditingController(text: args.idea.ideaTitle);
      ctrlDesc = TextEditingController(text: args.idea.ideaDesc);
      dropdownValue = args.idea.ideaCategory;
      participant = args.idea.ideaMaxParticipants;
    }
    con=1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Edit Idea'
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
                                child: imageFile == null ? Semantics(
                                    child: GestureDetector(
                                      onTap: () {
                                        showFileDialog(context);
                                      },
                                      child: Image.network(
                                        args.idea.ideaImage,
                                        width: 100,
                                      ),
                                    )
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
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        Ideas ideas = Ideas(args.idea.ideaId, ctrlTitle.text, ctrlDesc.text, dropdownValue, "", participant, 1, args.idea.ideaBy, "", "");

                                        await IdeaServices.updateIdea(ideas, imageFile).then((value) {
                                          if (value == true) {
                                            ActivityServices.showToast("Idea updated", cPrimaryColor);
                                            setState(() {
                                              isLoading = false;
                                            });
                                            Navigator.pushNamedAndRemoveUntil(context, MyIdeas.routeName, ModalRoute.withName(MainMenu.routeName));
                                          } else {
                                            ActivityServices.showToast("Error update idea", cPrimaryColor);
                                            setState(() {
                                              isLoading = false;
                                            });
                                            Navigator.pushNamedAndRemoveUntil(context, MainMenu.routeName, ModalRoute.withName('/'));
                                          }
                                        });
                                      }
                                    },
                                    text: "Edit Idea",
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
      items: <String>['Culinary', 'Services', 'Design', 'Studio', 'Non-Profit', 'Industry']
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
