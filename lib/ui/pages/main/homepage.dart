part of '../pages.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String uid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  CollectionReference ideaCollection = FirebaseFirestore.instance.collection("ideas");

  dynamic data;

  Future<dynamic> getDataUser() async {
    final DocumentReference document = userCollection.doc(uid);

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
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cPrimaryColor,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.menu,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {},
        // ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWithSearchBox(
              name: data()['firstName'],
              pic: data()['pic'],
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.02,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 24,
                    child: Stack(
                      children: [
                        Text(
                          "Recent Ideas",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'see all',
                      style: TextStyle(
                        color: cTextColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            StreamBuilder(
              stream: ideaCollection.where('ideaBy', isNotEqualTo: uid).snapshots(),
              builder: (BuildContext contex, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasError) {
                  return Text("Failed to load post");
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: new Row(
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
                      int size = 1;
                      bool showIdea = false;
                      bool block = false;
                      return StreamBuilder<QuerySnapshot>(
                        stream: ideaCollection.doc(ideas.ideaId).collection('participants').snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          if (snapshot.hasError) {
                            return Container();
                          }

                          return Row(
                            children: snapshot.data.docs.map((DocumentSnapshot doc) {
                              if (doc.data()['uid'] == uid) {
                                showIdea = false;
                                block = true;
                              } else if (snapshot.data.size > size) {
                                showIdea = false;
                              } else {
                                showIdea = true;
                              }
                              if (showIdea && !block) {
                                return RecentCardView(
                                  categoryName: ideas.ideaCategory,
                                  image: ideas.ideaImage,
                                  press: () {
                                    Navigator.pushNamed(
                                      context, DetailPost.routeName,
                                      arguments: DetailArgument(ideas),
                                    );
                                  },
                                );
                              }
                              size++;
                              return Container();
                            }).toList(),
                          );
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 24,
                    child: Stack(
                      children: [
                        Text(
                          "Discover New Friends",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'see all',
                      style: TextStyle(
                        color: cTextColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      )
                    ]
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NewFriends(
                        image: 'assets/images/men1.jpg',
                        firstName: 'Clent',
                      ),
                      NewFriends(
                        image: 'assets/images/men2.jpg',
                        firstName: 'Eddie',
                      ),
                      NewFriends(
                        image: 'assets/images/woman1.jpg',
                        firstName: 'Clara',
                      ),
                      NewFriends(
                        image: 'assets/images/woman2.jpg',
                        firstName: 'Lorenz',
                      ),
                      NewFriends(
                        image: 'assets/images/woman2.jpg',
                        firstName: 'Lorenz',
                      ),
                      NewFriends(
                        image: 'assets/images/woman2.jpg',
                        firstName: 'Lorenz',
                      ),
                      NewFriends(
                        image: 'assets/images/woman2.jpg',
                        firstName: 'Lorenz',
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

class NewFriends extends StatelessWidget {
  const NewFriends({
    Key key, this.image, this.firstName, this.idx,
  }) : super(key: key);

  final String image;
  final String firstName;
  final bool idx;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: getProportionateScreenWidth(15),
      ),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: Image.asset(
                image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(5),),
            Text(
              firstName
            )
          ],
        ),
      ),
    );
  }
}

class RecentCardView extends StatelessWidget {
  const RecentCardView({
    Key key, this.categoryName, this.image, this.press,
  }) : super(key: key);

  final String categoryName, image;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: getProportionateScreenWidth(15),
        top: getProportionateScreenWidth(15)/2,
        bottom: getProportionateScreenWidth(15) * 2.5
      ),
      width: SizeConfig.screenWidth * 0.35,
      child: GestureDetector(
        onTap: press,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
              child: image == cDefaultPicture
                  ? Image.asset(
                    image,
                    width: SizeConfig.screenWidth * 0.35,
                    height: 125,
                    fit: BoxFit.cover,
                  )
                  : Image.network(
                    image,
                    width: SizeConfig.screenWidth * 0.35,
                    height: 125,
                    fit: BoxFit.cover,
                  )
            ),
            Container(
              padding: EdgeInsets.only(
                top: 5,
                left: 5,
                right: 5,
                bottom: 15
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0,10),
                    blurRadius: 20,
                    color: cTextColor.withOpacity(0.23),
                  )
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    categoryName.toUpperCase()
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HeaderWithSearchBox extends StatelessWidget {
  const HeaderWithSearchBox({
    Key key, this.name, this.pic,
  }) : super(key: key);

  final String name;
  final String pic;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.23,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            height: SizeConfig.screenHeight * 0.2 -5,
            decoration: BoxDecoration(
              color: cPrimaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36)
              )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(30)),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Hi "+name+"!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 36
                            ),
                          ),
                          Text(
                            "Have a Nice Day",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: getProportionateScreenWidth(80),),
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: CircleAvatar(
                          backgroundImage: pic == cDefaultPicture
                              ? AssetImage(pic)
                              : NetworkImage(pic),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     alignment: Alignment.center,
          //     margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(25)),
          //     height: 60,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(20),
          //       boxShadow: [
          //         BoxShadow(
          //           offset: Offset(0, 10),
          //           blurRadius: 50,
          //           color: cTextColor.withOpacity(0.23)
          //         )
          //       ]
          //     ),
          //     child: TextField(
          //       decoration: InputDecoration(
          //         hintText: "Search Ideas",
          //         enabledBorder: InputBorder.none,
          //         focusedBorder: InputBorder.none,
          //         suffixIcon: Icon(
          //           Icons.search,
          //           color: cTextColor,
          //         ),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}