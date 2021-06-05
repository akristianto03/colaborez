part of 'widgets.dart';

class IconName extends StatelessWidget {
  const IconName({
    Key key,
    @required this.name, this.icon,
  }) : super(key: key);

  final String name;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: cPrimaryColor,
          ),
          SizedBox(width: getProportionateScreenWidth(8),),
          Expanded(
            child: Text(
                name
            ),
          )
        ],
      ),
    );
  }
}