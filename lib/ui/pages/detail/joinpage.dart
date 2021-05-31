part of '../pages.dart';

class JoinIdea extends StatelessWidget {
  static String routeName = "/joinidea";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your request had been sent to Johnny!",
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
                    backgroundImage: AssetImage('assets/images/men1.jpg'),
                  ),
                ),
                SizedBox(height: 20,),
                ProfileMenu(
                  press: () {},
                  text: "Contact Him/Her",
                  icon: CupertinoIcons.phone,
                ),
                SizedBox(height: 20,),
                DefaultButton(
                  press: () {
                    Navigator.pushReplacementNamed(context, MainMenu.routeName);
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
