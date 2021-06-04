part of '../pages.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool isLoading = false;
  String uid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile'
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: cTextColor,),
            onPressed: () {
              Navigator.pushNamed(context, ProfileSettings.routeName);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: userCollection.where('uid',isEqualTo: uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (snapshot.hasError) {
                return ProfilePic(
                  img: "assets/images/defaultProfilePic.png",
                  name: "none",
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return ActivityServices.loadings();
              }

              return new ListView(
                children: snapshot.data.docs.map((DocumentSnapshot doc) {
                  Users users;
                  users = new Users(
                    doc.data()['uid'],
                    doc.data()['email'],
                    doc.data()['password'],
                    doc.data()['firstName'],
                    doc.data()['lastName'],
                    doc.data()['phone'],
                    doc.data()['address'],
                    doc.data()['pic'],
                    doc.data()['createdAt'],
                    doc.data()['updatedAt'],
                  );

                  return Column(
                    children: [
                      ProfilePic(
                        name: users.firstName + " " + users.lastName,
                        img: users.pic,
                      ),
                      SizedBox(height: 20,),
                      ProfileMenu(
                        press: () {
                          Navigator.pushNamed(context, MyIdeas.routeName);
                        },
                        text: "My Ideas",
                        icon: Icons.lightbulb_outline,
                      ),
                      ProfileMenu(
                        press: () {},
                        text: "My Partnership",
                        icon: Icons.supervisor_account_outlined,
                      ),
                      ProfileMenu(
                        press: () {},
                        text: "My Favorites",
                        icon: Icons.favorite_border_outlined,
                      ),
                      ProfileMenu(
                        press: () {
                          print(users.pic);
                        },
                        text: "My History",
                        icon: Icons.history,
                      ),
                      ProfileMenu(
                        press: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await AuthServices.signOut().then((value) {
                            setState(() {
                              isLoading = false;
                            });
                            if (value == true) {
                              ActivityServices.showToast("Logout Success", cPrimaryColor);
                              Navigator.pushReplacementNamed(context, Login.routeName);
                            } else {
                              ActivityServices.showToast("Log Out Failed", cDangerColor);
                            }
                          });
                        },
                        text: "Log Out",
                        icon: Icons.logout_outlined,
                      ),
                    ],
                  );

                }).toList(),
              );
            },
          ),
          isLoading == true
              ? ActivityServices.loadings()
              : Container()
        ],
      ),
    );
  }
}

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key key, this.img, this.name,
  }) : super(key: key);

  final String img;
  final String name;

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {

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
                onPressed: () async {
                  await chooseFile("camera");
                  if (imageFile != null) {
                    await AuthServices.changeProfilePicture(imageFile).then((value) {
                      if (value == true) {
                        ActivityServices.showToast("Profile pic updated", cPrimaryColor);
                      } else {
                        ActivityServices.showToast("Error update profile", cDangerColor);
                      }
                    });
                  }
                },
                icon: Icon(Icons.camera_alt_outlined),
                label: Text("camera"),
              ),
              ElevatedButton.icon (
                onPressed: () async {
                  await chooseFile("gallery");
                  if (imageFile != null) {
                    await AuthServices.changeProfilePicture(imageFile).then((value) {
                      if (value == true) {
                        ActivityServices.showToast("Profile pic updated", cPrimaryColor);
                      } else {
                        ActivityServices.showToast("Error update profile", cDangerColor);
                      }
                    });
                  }
                },
                icon: Icon(Icons.picture_as_pdf_outlined),
                label: Text("Gallery"),
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 115,
          width: 115,
          child: Stack(
            fit: StackFit.expand,
            overflow: Overflow.visible,
            children: [
              CircleAvatar(
                backgroundImage: widget.img == cDefaultPicture
                    ? AssetImage(widget.img)
                    : NetworkImage(widget.img),
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
        Text(
          widget.name,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black
          ),
        )
      ],
    );
  }
}