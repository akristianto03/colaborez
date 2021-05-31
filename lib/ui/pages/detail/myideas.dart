part of '../pages.dart';

class MyIdeas extends StatefulWidget {
  @override
  _MyIdeasState createState() => _MyIdeasState();

  static String routeName = "/myideaspost";
}

class _MyIdeasState extends State<MyIdeas> {

  String uid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference ideaCollection = FirebaseFirestore.instance.collection("ideas");
  bool isLoading = true;

  // bool show = false;
  // getDataIdea(Ideas ideas) {
  //   try {
  //     ideaCollection.doc(ideas.ideaBy).collection('participants').doc(uid).get();
  //     show =false;
  //   } catch (e) {
  //     show = true;
  //   }
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Ideas'
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      SingleChildScrollView(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: ideaCollection.where('ideaBy', isEqualTo: uid).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                            if (snapshot.hasError) {
                              return Text("Failed to load post");
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return ActivityServices.loadings();
                            }

                            return new Column(
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
                                  routename: MyDetailPost.routeName,
                                  argument: MyDetailArgument(ideas),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}