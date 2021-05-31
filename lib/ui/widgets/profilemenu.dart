part of 'widgets.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key key, this.press, this.icon, this.text,
  }) : super(key: key);

  final Function press;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
          onPressed: press,
          style: ElevatedButton.styleFrom(
            primary: cSeccondaryColor,
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: cPrimaryColor,
              ),
              SizedBox(width: 20,),
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              )
            ],
          )
      ),
    );
  }
}