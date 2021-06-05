part of '../pages.dart';

class ParticipantsArgument {
  final Ideas idea;

  ParticipantsArgument(this.idea);
}

class Participants extends StatefulWidget {
  const Participants({Key key}) : super(key: key);

  static String routeName = "/participants";

  @override
  _ParticipantsState createState() => _ParticipantsState();
}

class _ParticipantsState extends State<Participants> {

  CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  CollectionReference ideaCollection = FirebaseFirestore.instance.collection("ideas");
  String uid = FirebaseAuth.instance.currentUser.uid;
  dynamic data;
  Users users;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    final ParticipantsArgument args = ModalRoute.of(context).settings.arguments as ParticipantsArgument;

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              StreamBuilder(
                stream: ideaCollection.doc(args.idea.ideaId).collection("participants").where('status', isEqualTo: 1).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Align(
                        alignment: Alignment.center,
                        child: Text("Error")
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ActivityServices.loadings();
                  }

                  return new ListView(
                    children: snapshot.data.docs.map((DocumentSnapshot doc) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: ParticipantMenu(
                          press: () {},
                          participantId: doc.data()['uid'],
                        ),
                      );
                    }).toList(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ParticipantMenu extends StatefulWidget {
  const ParticipantMenu({
    Key key, this.press, this.participantId,
  }) : super(key: key);

  final Function press;
  final String participantId;

  @override
  _ParticipantMenuState createState() => _ParticipantMenuState();
}

class _ParticipantMenuState extends State<ParticipantMenu> {

  CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  Users users;
  dynamic data;

  Future<dynamic> getDataUser() async {
    final DocumentReference document = userCollection.doc(widget.participantId);

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
  void initState() {
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: widget.press,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              child: CircleAvatar(
                backgroundImage: data()['pic'] == cDefaultPicture
                    ? AssetImage(data()['pic'])
                    : NetworkImage(data()['pic']),
              ),
            ),
            SizedBox(width: 15,),
            Expanded(
              child: Text(
                users.firstName,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}