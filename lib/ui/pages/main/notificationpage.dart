part of '../pages.dart';

class Notification extends StatefulWidget {

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  bool isLoading = false;

  String uid = FirebaseAuth.instance.currentUser.uid;

  CollectionReference ideaCollection = FirebaseFirestore.instance.collection("ideas");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification'
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              ListView(
                children: [
                  SingleChildScrollView(
                    child: StreamBuilder(
                      stream: ideaCollection.where('ideaBy',isEqualTo: uid).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if (snapshot.hasError) {
                          return Align(
                            alignment: Alignment.center,
                            child: Text("Error")
                          );
                        }

                        // if (snapshot.connectionState == ConnectionState.waiting) {
                        //   return ActivityServices.loadings();
                        // }

                        return new Column(
                          children: snapshot.data.docs.map((DocumentSnapshot doc) {
                            Ideas ideas = new Ideas(
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
                              stream: ideaCollection.doc(ideas.ideaId).collection('participants').where('status', isEqualTo: 0).snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                if (snapshot.hasError) {
                                  return Text("Failed to load post");
                                }
                                // if (snapshot.connectionState == ConnectionState.waiting) {
                                //   return ActivityServices.loadings();
                                // }

                                return Column(
                                  children: snapshot.data.docs.map((DocumentSnapshot doc) {
                                    return CardNotification(
                                      ideas: ideas,
                                      participantId: doc.data()['uid'],
                                    );
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
            ],
          ),
        ),
      ),
    );
  }
}

class CardNotification extends StatefulWidget {
  const CardNotification({
    Key key, this.ideas, this.participantId,
  }) : super(key: key);

  final Ideas ideas;
  final String participantId;

  @override
  _CardNotificationState createState() => _CardNotificationState();
}

class _CardNotificationState extends State<CardNotification> {

  CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  dynamic data;

  Future<dynamic> getDataUser() async {
    final DocumentReference document = userCollection.doc(widget.participantId);

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
    getDataUser();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              spreadRadius: 5,
              color: Colors.grey.withOpacity(0.2),
              offset: Offset(0, 3),
            )
          ]
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: data()['pic'] == cDefaultPicture
                ? Image.asset(
                    cDefaultPicture,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    data()['pic'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
            ),
            SizedBox(width: 20,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data()['firstName']+" want to join partnership",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.ideas.ideaTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11
                    ),
                  )
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 40,
                  child: IconButton(
                    onPressed: () async{
                      await IdeaServices.requestIdea(widget.ideas, widget.participantId).then((value) {
                        if (value) {
                          ActivityServices.showToast ("Now " + data()['firstName'] + " is your partner!", cSuccessColor);
                        } else {
                          ActivityServices.showToast("Can't accept request", cDangerColor);
                        }
                      });
                    },
                    icon: Icon(
                      Icons.check_circle,
                      color: cSuccessColor,
                    ),
                    iconSize: 40,
                  ),
                ),
                Container(
                  width: 40,
                  child: IconButton(
                    onPressed: () async{
                      await IdeaServices.deleteRequestIdea(widget.ideas, widget.participantId).then((value) {
                        if (value) {
                          ActivityServices.showToast (data()['firstName'] + " rejected", cPrimaryColor);
                        } else {
                          ActivityServices.showToast("Can't reject request", cDangerColor);
                        }
                      });
                    },
                    icon: Icon(
                      Icons.remove_circle_rounded,
                      color: cDangerColor,
                    ),
                    iconSize: 40,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}