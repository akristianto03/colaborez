part of 'widgets.dart';

class ParticipantCircleView extends StatelessWidget {
  const ParticipantCircleView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      height: getProportionateScreenWidth(40),
      width: getProportionateScreenWidth(40),
      child: CircleAvatar(
        backgroundImage: AssetImage(cDefaultPicture),
      ),
    );
  }
}

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key key, this.pressOnSeeMore, this.idea,
  }) : super(key: key);

  final GestureTapCallback pressOnSeeMore;
  final Ideas idea;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {

  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    Ideas idea = widget.idea;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20),),
          child: Text(
            idea.ideaTitle,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(15)),
              width: getProportionateScreenWidth(64),
              decoration: BoxDecoration(
                  color: isFavorite == true
                      ? Color(0xFFFFE6E6)
                      : Color(0xFFF5F6F9)
                  ,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20)
                  )
              ),
              child: Icon(
                  isFavorite == true
                      ? Icons.favorite
                      : Icons.favorite_border_outlined
                  ,
                  color: isFavorite == true
                      ? cDangerColor
                      : cTextColor
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(64),
          ),
          child: Text(
            idea.ideaDesc,
            maxLines: 3,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: 10
          ),
          child: GestureDetector(
            onTap: widget.pressOnSeeMore,
            child: Row(
              children: [
                Text(
                  "See More Detail",
                  style: TextStyle(
                      color: cPrimaryColor,
                      fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(width: 5,),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: cPrimaryColor,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class TopRoundedContainer extends StatelessWidget {
  const TopRoundedContainer({
    Key key, this.child, this.color,
  }) : super(key: key);

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: getProportionateScreenWidth(20)),
      padding: EdgeInsets.only(top: getProportionateScreenWidth(20)),
      width: double.infinity,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40)
          )
      ),
      child: child,
    );
  }
}

class CustomAppbar extends PreferredSize {
  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RoundedIconButton(
              press: () => Navigator.pop(context),
              icon: Icons.arrow_back_ios,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14)
              ),
              child: Row(
                children: [
                  Text(
                    "Lorentz",
                    style: TextStyle(
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}