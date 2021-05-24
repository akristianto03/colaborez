part of 'widgets.dart';

class IconButtonBorder extends StatelessWidget {
  const IconButtonBorder({
    Key key, this.icon, this.press,
  }) : super(key: key);
  final IconData icon;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(
            border: Border.all(color: cTextColor, width: 2),
            borderRadius: BorderRadius.circular(13)
        ),
        child: InkWell(
          onTap: press,
          child: Padding(
            padding:EdgeInsets.all(4.0),
            child: Icon(
              icon,
              size: 25.0,
              color: cTextColor,
            ),
          ),
        ),
      ),
    );
  }
}