part of '../pages.dart';

class ProfileInfoArgument {
  final Users users;

  ProfileInfoArgument(this.users);
}

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({Key key}) : super(key: key);

  static String routeName = "/profileinfo";

  @override
  Widget build(BuildContext context) {

    final ProfileInfoArgument args = ModalRoute.of(context).settings.arguments as ProfileInfoArgument;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account Info"
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight * 0.02,),
                      ProfilePic(
                        img: args.users.pic,
                        name: args.users.firstName,
                      ),
                      SizedBox(height: getProportionateScreenHeight(30),),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 10),
                              blurRadius: 50,
                              color: cTextColor.withOpacity(0.23)
                            )
                          ]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconName(
                              name: args.users.firstName+" "+args.users.lastName,
                              icon: Icons.person,
                            ),
                            IconName(
                              name: args.users.phone,
                              icon: Icons.phone_android_outlined,
                            ),
                            IconName(
                              name: args.users.email,
                              icon: Icons.mail_outline,
                            ),
                            IconName(
                              name: args.users.address,
                              icon: Icons.location_on_outlined,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
