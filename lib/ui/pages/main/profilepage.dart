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
                          Navigator.pushNamed(
                            context, ProfileInfo.routeName,
                            arguments: ProfileInfoArgument(users)
                          );
                        },
                        text: "Account Info",
                        icon: Icons.account_box_outlined,
                      ),
                      ProfileMenu(
                        press: () {
                          Navigator.pushNamed(context, MyIdeas.routeName);
                        },
                        text: "My Ideas",
                        icon: Icons.lightbulb_outline,
                      ),
                      ProfileMenu(
                        press: () {
                          Navigator.pushNamed(context, MyPartnerIdeas.routeName);
                        },
                        text: "My Partnership",
                        icon: Icons.supervisor_account_outlined,
                      ),
                      ProfileMenu(
                        press: () {
                          Navigator.pushNamed(context, MyFavorIdeas.routeName);
                        },
                        text: "My Favorites",
                        icon: Icons.favorite_border_outlined,
                      ),
                      // ProfileMenu(
                      //   press: () {
                      //     print(users.pic);
                      //   },
                      //   text: "My History",
                      //   icon: Icons.history,
                      // ),
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