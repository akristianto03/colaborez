part of 'widgets.dart';

class IdeaPostCardView extends StatefulWidget {
  const IdeaPostCardView({
    Key key, this.ideas, this.argument, this.routename,
  }) : super(key: key);

  final Ideas ideas;
  final Object argument;
  final String routename;

  @override
  _IdeaPostCardViewState createState() => _IdeaPostCardViewState();
}

class _IdeaPostCardViewState extends State<IdeaPostCardView> {

  CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  dynamic data;

  Future<dynamic> getDataUser() async {

    final DocumentReference document = userCollection.doc(widget.ideas.ideaBy);

    await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
      setState(() {
        data =snapshot.data;
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context, widget.routename,
          arguments: widget.argument,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.ideas.ideaImage),
                      fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)
                  )
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      spreadRadius: 5,
                      color: Colors.grey.withOpacity(0.2),
                      offset: Offset(0, 3),
                    )
                  ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.ideas.ideaTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(5),),
                  Row(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_circle,
                            color: cTextColor,
                          ),
                          Text(
                              data()['firstName']
                          )
                        ],
                      ),
                      SizedBox(width: getProportionateScreenWidth(15),),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_box,
                            color: cTextColor,
                          ),
                          Text(
                              widget.ideas.ideaMaxParticipants.toString() + ' Peoples'
                          )
                        ],
                      ),
                      SizedBox(width: getProportionateScreenWidth(15),),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category,
                            color: cTextColor,
                          ),
                          Text(
                              widget.ideas.ideaCategory,
                              overflow: TextOverflow.ellipsis
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}