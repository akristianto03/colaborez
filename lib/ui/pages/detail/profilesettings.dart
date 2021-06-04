part of '../pages.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key key}) : super(key: key);

  static String routeName = "/profilesettings";

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {

  CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  String uid = FirebaseAuth.instance.currentUser.uid;
  dynamic data;
  Users users;
  bool isLoading = false;

  Future<dynamic> getDataUser() async {

    final DocumentReference document = userCollection.doc(uid);

    await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
      setState(() {
        data =snapshot.data;
        users = new Users(
            data()['uid'],
            data()['email'],
            data()['password'],
            data()['firstName'],
            data()['lastName'],
            data()['phone'],
            data()['address'],
            data()['pic'],
            data()['createdAt'],
            data()['updatedAt'],
        );
      });
    });
  }

  @override
  void initState() {

    super.initState();
    getDataUser();
  }

  void showConfirmDialog(BuildContext ctx, Users users) {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text("Are you sure want to delete this Account?"),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await AuthServices.deleteUser(users.uid).then((value) {
                    setState(() {
                      isLoading = false;
                    });
                    if (value == true) {
                      ActivityServices.showToast("Your account has deleted!", cDangerColor);
                      Navigator.pushNamedAndRemoveUntil(context, Login.routeName, ModalRoute.withName('/'));
                    } else {
                      ActivityServices.showToast("Can't delete account", cDangerColor);
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                    primary: cPrimaryColor
                ),
                child: Text("Yes"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                    primary: cDangerColor
                ),
                child: Text("No"),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.02,),
                    SettingMenu(
                      text: "Edit Profile",
                      icon: CupertinoIcons.square_pencil,
                      color: cPrimaryColor,
                      press: () {
                        Navigator.pushNamed(
                          context, EditProfile.routeName,
                          arguments: EditProfileArgument(users)
                        );
                      },
                    ),
                    SizedBox(height: getProportionateScreenHeight(30),),
                    SettingMenu(
                      text: "Delete Profile",
                      icon: CupertinoIcons.delete,
                      color: cDangerColor,
                      press: () {
                        showConfirmDialog(context, users);
                      },
                    )
                  ],
                ),
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
}

class SettingMenu extends StatelessWidget {
  const SettingMenu({
    Key key, this.press, this.text, this.icon, this.color,
  }) : super(key: key);

  final Function press;
  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
          ),
          SizedBox(width: 15,),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: cTextColor
          )
        ],
      ),
    );
  }
}
