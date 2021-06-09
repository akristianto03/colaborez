part of '../pages.dart';

class MyPartnerIdeas extends StatefulWidget {
  @override
  _MyPartnerIdeasState createState() => _MyPartnerIdeasState();

  static String routeName = "/mypartnerideas";
}

class _MyPartnerIdeasState extends State<MyPartnerIdeas> {

  String uid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference ideaCollection = FirebaseFirestore.instance.collection("ideas");
  CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'My Partnership'
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
                          stream: ideaCollection.where('ideaBy', isNotEqualTo: uid).snapshots(),
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
                                  stream: ideaCollection.doc(ideas.ideaId).collection('participants').where('status', isEqualTo: 1).snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                    if (snapshot.hasError) {
                                      return Text("Failed to load post");
                                    }

                                    int con = 0;
                                    return Column(
                                      children: snapshot.data.docs.map((DocumentSnapshot doc) {
                                        if (con==0 && doc.data()['uid'] == uid) {
                                          con = 1;
                                          return IdeaPostCardView(
                                            ideas: ideas,
                                            routename: MyDetailPartner.routeName,
                                            argument: MyDetailPartnerArgument(ideas),
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