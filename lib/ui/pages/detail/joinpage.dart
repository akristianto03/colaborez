part of '../pages.dart';

class JoinArgument {
  final Users users;

  JoinArgument(this.users);
}

class JoinIdea extends StatefulWidget {
  static String routeName = "/joinidea";

  @override
  _JoinIdeaState createState() => _JoinIdeaState();
}

class _JoinIdeaState extends State<JoinIdea> {

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
    final JoinArgument args = ModalRoute.of(context).settings.arguments as JoinArgument;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your request had been sent to "+args.users.firstName+"!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  height: 115,
                  width: 115,
                  child: CircleAvatar(
                    backgroundImage: args.users.pic == cDefaultPicture
                        ? AssetImage(args.users.pic)
                        : NetworkImage(args.users.pic),
                  ),
                ),
                SizedBox(height: 20,),
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
                SizedBox(height: 20,),
                DefaultButton(
                  press: () {
                    Navigator.pushNamedAndRemoveUntil(context, MainMenu.routeName, ModalRoute.withName('/'));
                  },
                  text: "Back to Main Menu",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
