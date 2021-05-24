part of '../pages.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  String uid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference ideaCollection = FirebaseFirestore.instance.collection("ideas");
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: cTextColor.withOpacity(0.23)
                )
              ]
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search Ideas.',
            ),
          ),
        ),
        backgroundColor: cPrimaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white,),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        height: SizeConfig.screenHeight * 0.1 -5,
                        color: cPrimaryColor,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)
                              )
                          ),
                        ),
                      )
                    ],
                  ),

                  StreamBuilder<QuerySnapshot>(
                    stream: ideaCollection.snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if (snapshot.hasError) {
                        return Text("Failed to load post");
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ActivityServices.loadings();
                      }

                      return Expanded(
                        child: new ListView(
                          children: snapshot.data.docs.map((DocumentSnapshot doc) {
                            Ideas ideas;
                            ideas = new Ideas(
                              doc.data()['ideaId'],
                              doc.data()['ideaTitle'],
                              doc.data()['ideaDesc'],
                              doc.data()['ideaCategory'],
                              doc.data()['ideaImage'],
                              doc.data()['ideaMaxParticipants'],
                              doc.data()['ideaParticipant'],
                              doc.data()['ideaBy'],
                              doc.data()['createdAt'],
                              doc.data()['updatedAt'],
                            );
                            return IdeaPostCardView(
                              ideas: ideas,
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class IdeaPostCardView extends StatefulWidget {
  const IdeaPostCardView({
    Key key, this.ideas,
  }) : super(key: key);

  final Ideas ideas;

  @override
  _IdeaPostCardViewState createState() => _IdeaPostCardViewState();
}

class _IdeaPostCardViewState extends State<IdeaPostCardView> {

  CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context, DetailPost.routeName,
          arguments: DetailArgument(widget.ideas),
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
                          StreamBuilder<QuerySnapshot>(
                            stream: userCollection.where('uid',isEqualTo: widget.ideas.ideaBy).snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                              if (snapshot.hasError) {
                                return Text(
                                  "nama"
                                );
                              }

                              return Column(
                                children: snapshot.data.docs.map((DocumentSnapshot doc) {
                                  String firstName = doc.data()['firstName'];
                                  return Text(
                                    firstName
                                  );
                                }).toList(),
                              );
                            },
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