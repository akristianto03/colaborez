part of 'widgets.dart';

class ParticipantCircleView extends StatefulWidget {
  const ParticipantCircleView({
    Key key, this.participantId,
  }) : super(key: key);

  final String participantId;

  @override
  _ParticipantCircleViewState createState() => _ParticipantCircleViewState();
}

class _ParticipantCircleViewState extends State<ParticipantCircleView> {

  CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  Users users;
  dynamic data;

  Future<dynamic> getDataUser() async {
    final DocumentReference document = userCollection.doc(widget.participantId);

    await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
      setState(() {
        data =snapshot.data;
        // users = new Users(
        //   data()['uid'],
        //   data()['email'],
        //   data()['password'],
        //   data()['firstName'],
        //   data()['lastName'],
        //   data()['phone'],
        //   data()['address'],
        //   data()['pic'],
        //   data()['createdAt'],
        //   data()['updatedAt'],
        // );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      height: getProportionateScreenWidth(40),
      width: getProportionateScreenWidth(40),
      child: CircleAvatar(
        backgroundImage: data()['pic'] == cDefaultPicture
            ? AssetImage(data()['pic'])
            : NetworkImage(data()['pic']),
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
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  dynamic data;

  Future<dynamic> getDataUser() async {
    String uid = auth.currentUser.uid;
    final DocumentReference document = userCollection.doc(uid).collection("favorites").doc(widget.idea.ideaId);
    await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
      setState(() {
        data =snapshot.data;

        try {
          print('oeee '+ data()['favorite'].toString());
          isFavorite = data()['favorite'];
        } catch (e) {
          isFavorite = false;
        }
      });
    });
  }

  @override
  void initState() {

    super.initState();
    getDataUser();
  }

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
            onTap: () async {
              // if (con==1) {
                setState(() {
                  isFavorite = !isFavorite;
                });

                if (isFavorite) {
                  await IdeaServices.addFavoriteIdea(idea).then((value) {
                    if (value) {
                      ActivityServices.showToast("Added to favorite", cPrimaryColor);
                    } else {
                      ActivityServices.showToast("Request failed", cDangerColor);
                    }
                  });
                } else {
                  await IdeaServices.removeFavoriteIdea(idea).then((value) {
                    if (value) {
                      ActivityServices.showToast("Remove from favorite", cDangerColor);
                    } else {
                      ActivityServices.showToast("Request failed", cDangerColor);
                    }
                  });
                }
              // }
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
        // Padding(
        //   padding: EdgeInsets.symmetric(
        //       horizontal: getProportionateScreenWidth(20),
        //       vertical: 10
        //   ),
        //   child: GestureDetector(
        //     onTap: widget.pressOnSeeMore,
        //     child: Row(
        //       children: [
        //         Text(
        //           "See More Detail",
        //           style: TextStyle(
        //               color: cPrimaryColor,
        //               fontWeight: FontWeight.w600
        //           ),
        //         ),
        //         SizedBox(width: 5,),
        //         Icon(
        //           Icons.arrow_forward_ios,
        //           size: 12,
        //           color: cPrimaryColor,
        //         )
        //       ],
        //     ),
        //   ),
        // )
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
    return Expanded(
      child: Container(
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
      ),
    );
  }
}

class CustomAppbar extends PreferredSize {
  CustomAppbar(this.name);

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  final String name;

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
                    name,
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