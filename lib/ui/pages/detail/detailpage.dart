part of '../pages.dart';

class DetailArgument {
  final Ideas idea;

  DetailArgument(this.idea);
}

class DetailPost extends StatefulWidget {

  static String routeName = "/detailpost";

  @override
  _DetailPostState createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {

  bool isLoading = false;

  void showConfirmDialog(BuildContext ctx, Ideas ideas) {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text("Are you sure want to send parnership request to this idea?"),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await IdeaServices.joinIdea(ideas).then((value) {
                    setState(() {
                      isLoading = false;
                    });
                    if (value == true) {
                      ActivityServices.showToast("Your request has been send!", cPrimaryColor);
                      Navigator.pushReplacementNamed(
                        context, JoinIdea.routeName,
                        arguments: JoinArgument(users)
                      );
                    } else {
                      ActivityServices.showToast("Can't request join idea", cDangerColor);
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
                  Navigator.pop(context);
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
  Users users;
  dynamic data;

  Future<dynamic> getDataUser(Ideas ideas) async {

    final DocumentReference document = userCollection.doc(ideas.ideaBy);

    await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
      setState(() {
        data =snapshot.data;
        users = new Users(
          data()['uid'],
          data()['email'],
          data()['password'],
          data()['firstName'],
          data()['lastName'],
          data()['phone'],
          data()['address'],
          data()['pic'],
          data()['createdAt'],
          data()['updatedAt'],
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final DetailArgument args = ModalRoute.of(context).settings.arguments as DetailArgument;
    getDataUser(args.idea);

    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CustomAppbar(users.firstName),
      body: Column(
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

                              int size=0;
                              return Row(
                                children: snapshot.data.docs.map((DocumentSnapshot doc) {
                                  if (size < 8){
                                    return ParticipantCircleView(
                                      participantId: doc.data()['uid'],
                                    );
                                  }
                                  size++;
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
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Info",
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          "Category :"
                                      ),
                                      Spacer(),
                                      Text(
                                          args.idea.ideaCategory
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Participants :"
                                      ),
                                      Spacer(),
                                      Text(
                                        args.idea.ideaParticipant.toString()
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          "Max Participants :"
                                      ),
                                      Spacer(),
                                      Text(
                                          args.idea.ideaMaxParticipants.toString()
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: SizeConfig.screenWidth * 0.15,
                                right: SizeConfig.screenWidth * 0.15,
                                top: getProportionateScreenWidth(15),
                                bottom: getProportionateScreenWidth(40)
                              ),
                              child: args.idea.ideaParticipant < args.idea.ideaMaxParticipants
                              ? Align(
                                alignment: Alignment.bottomCenter,
                                child: DefaultButton(
                                  text: "Join Partnership!",
                                  press: () {
                                    showConfirmDialog(context, args.idea);
                                  },
                                ),
                              )
                              : Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "Participant full!",
                                ),
                              )
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
    );
  }
}