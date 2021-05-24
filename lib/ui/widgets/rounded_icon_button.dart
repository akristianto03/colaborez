part of 'widgets.dart';

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton({
    Key key, this.icon, this.press,
  }) : super(key: key);

  final IconData icon;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenWidth(40),
      width: getProportionateScreenWidth(40),
      child: ElevatedButton(
        onPressed: press,
        child: Icon(
          icon,
          color: cTextColor,
        ),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            elevation: 0,
            primary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            )
        ),
      ),
    );
  }
}