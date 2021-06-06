part of '../pages.dart';

class MyDetailPartnerArgument {
  final Ideas idea;

  MyDetailPartnerArgument(this.idea);
}

class MyDetailPartner extends StatefulWidget {

  static String routeName = "/mydetailpartner";

  @override
  _MyDetailPartnerState createState() => _MyDetailPartnerState();
}

class _MyDetailPartnerState extends State<MyDetailPartner> {

  bool isLoading = false;
  String uid = FirebaseAuth.instance.currentUser.uid;

  void showConfirmDialog(BuildContext ctx, Ideas ideas, String uid) {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text("Are you sure want to leave this partnership?"),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await IdeaServices.deleteRequestIdea(ideas, uid).then((value) {
                    setState(() {
                      isLoading = false;
                    });
                    if (value == true) {
                      ActivityServices.showToast("You left idea", cDangerColor);
                      Navigator.pushNamedAndRemoveUntil(context, MyPartnerIdeas.routeName, ModalRoute.withName(MainMenu.routeName));
                    } else {
                      ActivityServices.showToast("Can't left idea", cDangerColor);
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                    primary: cPrimaryColor
                ),
                child: Text("Yes"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                    primary: cDangerColor
                ),
                child: Text("No"),
              ),
            ],
          );
        }
    );
  }

  CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  CollectionReference ideaCollection = FirebaseFirestore.instance.collection("ideas");

  dynamic data;

  Future<dynamic> getDataUser(Ideas ideas) async {

    final DocumentReference document = userCollection.doc(ideas.ideaBy);

    await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
      setState(() {
        data =snapshot.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final MyDetailPartnerArgument args = ModalRoute.of(context).settings.arguments as MyDetailPartnerArgument;
    getDataUser(args.idea);

    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CustomAppbar(data()['firstName']),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                width: getProportionateScreenWidth(238),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    args.idea.ideaImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              TopRoundedContainer(
                color: Colors.white,
                child: Column(
                  children: [
                    ProductDescription(
                      pressOnSeeMore: () {},
                      idea: args.idea,
                    ),
                    TopRoundedContainer(
                      color: Color(0xFFF5F6F9),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Participants.routeName,
                                  arguments: ParticipantsArgument(args.idea)
                              );
                            },
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(20)
                                ),
                                child: StreamBuilder(
                                  stream: ideaCollection.doc(args.idea.ideaId).collection("participants").where("status", isEqualTo: 1).snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return Text("Error");
                                    }

                                    return Row(
                                      children: snapshot.data.docs.map((DocumentSnapshot doc) {
                                        return ParticipantCircleView(
                                          participantId: doc.data()['uid'].toString(),
                                        );
                                      }).toList(),
                                    );
                                  },
                                )
                            ),
                          ),
                          TopRoundedContainer(
                            color: Colors.white,
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.screenWidth * 0.08,
                                      right: SizeConfig.screenWidth * 0.08,
                                      top: getProportionateScreenWidth(15),
                                      bottom: getProportionateScreenWidth(40)
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                      width: SizeConfig.screenWidth * 0.6,
                                      height: getProportionateScreenHeight(56),
                                      child: OutlineButton(
                                        onPressed: () {
                                          showConfirmDialog(context, args.idea, uid);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          "Leave Partnership",
                                          style: TextStyle(
                                              fontSize: getProportionateScreenWidth(18),
                                              color: cDangerColor
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          isLoading == true
              ? ActivityServices.loadings()
              : Container()
        ],
      ),
    );
  }
}
