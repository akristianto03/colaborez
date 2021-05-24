part of 'services.dart';

class IdeaServices{

  static FirebaseAuth auth = FirebaseAuth.instance;

  //setup cloud firestore
  static CollectionReference ideaCollection = FirebaseFirestore.instance.collection("ideas");
  static DocumentReference ideaDocument;

  //setup storage
  static Reference ref;
  static UploadTask uploadTask;
  static String imgUrl;

  static Future<bool> addIdea(Ideas ideas, PickedFile imgFile) async {
    await Firebase.initializeApp();
    String dateNow = ActivityServices.dateNow();
    ideaDocument = await ideaCollection.add({
      'ideaTitle' : ideas.ideaTitle,
      'ideaDesc' : ideas.ideaDesc,
      'ideaCategory' : ideas.ideaCategory,
      'ideaMaxParticipants' : ideas.ideaMaxParticipants,
      'ideaParticipant' : ideas.ideaParticipant,
      'ideaBy' : auth.currentUser.uid,
      'createdAt' : dateNow,
      'updatedAt' : dateNow,
    });

    if (ideaDocument != null) {
      ref = FirebaseStorage.instance.ref().child("images").child(ideaDocument.id+".png");
      uploadTask = ref.putFile(File(imgFile.path));

      await uploadTask.whenComplete(() =>
        ref.getDownloadURL().then((value) => imgUrl = value,)
      );

      ideaCollection.doc(ideaDocument.id).update({
        'ideaId' : ideaDocument.id,
        'ideaImage' : imgUrl,
      });

      return true;

    }

    return false;

  }

  static Future<String> getUserIdeaUserFirstName(String ideaBy) async {
     await FirebaseFirestore.instance
        .collection("users")
        .doc(ideaBy)
        .snapshots()
        .listen((DocumentSnapshot ds) {
      if (ds.exists) {
        return ds.data()['firstName'];
      }
    });
    return "nama";
  }

}