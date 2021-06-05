part of '../pages.dart';

class OtherUserArgument {
  final Users users;

  OtherUserArgument(this.users);
}

class OtherUser extends StatefulWidget {
  const OtherUser({Key key}) : super(key: key);

  static String routeName = "/otheruserinfo";

  @override
  _OtherUserState createState() => _OtherUserState();
}

class _OtherUserState extends State<OtherUser> {

  void launchWA(String phone) async {
    String url = "whatsapp://send?phone="+phone+"&text=test";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {

    final OtherUserArgument args = ModalRoute.of(context).settings.arguments as OtherUserArgument;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            args.users.firstName+" Info"
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

                      SizedBox(
                        height: 115,
                        width: 115,
                        child: Stack(
                          fit: StackFit.expand,
                          overflow: Overflow.visible,
                          children: [
                            CircleAvatar(
                              backgroundImage: args.users.pic == cDefaultPicture
                                  ? AssetImage(args.users.pic)
                                  : NetworkImage(args.users.pic),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        args.users.firstName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black
                        ),
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
                      ),
                      SizedBox(height: getProportionateScreenHeight(30),),
                      GestureDetector(
                        onTap: () {
                          launchWA(args.users.phone);
                        },
                        child: Container(
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
                                name: "Contact via Whatsapp",
                                icon: CupertinoIcons.phone,
                              ),
                            ],
                          ),
                        ),
                      ),
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
