part of '../pages.dart';

class MyFavorIdeas extends StatefulWidget {
  @override
  _MyFavorIdeasState createState() => _MyFavorIdeasState();

  static String routeName = "/myfavorideas";
}

class _MyFavorIdeasState extends State<MyFavorIdeas> {

  String uid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference ideaCollection = FirebaseFirestore.instance.collection("ideas");
  CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'My Favorite Ideas'
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
                          stream: ideaCollection.snapshots(),
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
                                return StreamBuilder<QuerySnapshot>(
                                  stream: userCollection.doc(uid).collection('favorites').where('ideaId', isEqualTo: ideas.ideaId).snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                    if (snapshot.hasError) {
                                      return Text("Failed to load post");
                                    }

                                    int con = 0;
                                    return Column(
                                      children: snapshot.data.docs.map((DocumentSnapshot doc) {
                                        if (con==0) {
                                          con = 1;
                                          return IdeaPostCardView(
                                            ideas: ideas,
                                            routename: ideas.ideaBy == uid
                                            ? MyDetailPost.routeName
                                            : DetailPost.routeName,
                                            argument: ideas.ideaBy == uid
                                            ? MyDetailArgument(ideas)
                                            : DetailArgument(ideas),
                                          );
                                        }
                                        return Container();
                                      }).toList(),
                                    );
                                  },
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
            ),
          ],
        ),
      ),
    );
  }
}