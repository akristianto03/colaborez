part of 'services.dart';

class IdeaServices{

  static FirebaseAuth auth = FirebaseAuth.instance;

  //setup cloud firestore
  static CollectionReference ideaCollection = FirebaseFirestore.instance.collection("ideas");
  static CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
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

      ideaCollection.doc(ideaDocument.id).collection('participants').doc(auth.currentUser.uid).set({
        'uid' : auth.currentUser.uid,
        'status' : 1,
        'createdAt': dateNow,
        'updatedAt': dateNow,
      });

      return true;

    }

    return false;

  }

  static Future<bool> updateIdea(Ideas ideas, PickedFile imgFile) async {
    await Firebase.initializeApp();
    String dateNow = ActivityServices.dateNow();

    String uid = auth.currentUser.uid;

    await ideaCollection.doc(ideas.ideaId).update({
      'ideaTitle' : ideas.ideaTitle,
      'ideaDesc' : ideas.ideaDesc,
      'ideaCategory' : ideas.ideaCategory,
      'ideaMaxParticipants' : ideas.ideaMaxParticipants,
      'ideaParticipant' : ideas.ideaParticipant,
      'createdAt' : dateNow,
      'updatedAt' : dateNow,
    });

    if (imgFile != null) {
      ref = FirebaseStorage.instance.ref().child("images").child(ideas.ideaId+".png");
      uploadTask = ref.putFile(File(imgFile.path));

      await uploadTask.whenComplete(() =>
          ref.getDownloadURL().then((value) => imgUrl = value,)
      );

      await ideaCollection.doc(ideas.ideaId).update({
        'ideaImage' : imgUrl,
      });
    }

    return true;
  }

  static Future<bool> deleteIdea(String id) async {
    bool msg = true;
    await Firebase.initializeApp();

    await ideaCollection.doc(id).collection("participants").get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs){
        ds.reference.delete();
      }
    });
    
    await ideaCollection.doc(id).delete().then((value) {
      msg = true;
    }).catchError((onError) {
      msg = false;
    });

    return msg;
  }

  // static Future<bool> filterFeedsNotParticipated(String ideaId) async{
  //   String uid = auth.currentUser.uid;
  //   bool msg;
  //   DocumentSnapshot documentSnapshot = await ideaCollection.doc(ideaId).collection("participants").doc().get().then((value) {
  //     if (value.data()['status'] == 0) {
  //       msg = true;
  //     }else {
  //       msg = false;
  //     }
  //   }).catchError((onError) {
  //     msg = true;
  //   });
  //
  //   return msg;
  //
  // }

  static Future<bool> joinIdea(Ideas ideas) async {
    await Firebase.initializeApp();
    String dateNow = ActivityServices.dateNow();
    
    String uid = auth.currentUser.uid;
    bool msg;
    
    await ideaCollection.doc(ideas.ideaId).collection("participants").doc(uid).set({
      'uid': uid,
      'status': 0,
      'createdAt': dateNow,
      'updatedAt': dateNow,
    }).then((value) {
      msg = true;
    }).catchError((onError) {
      msg = false;
    });

    return msg;

  }

  static Future<bool> requestIdea(Ideas ideas, String idUser) async {
    await Firebase.initializeApp();
    String dateNow = ActivityServices.dateNow();
    bool msg;

    await ideaCollection.doc(ideas.ideaId).collection("participants").doc(idUser).update({
      'status': 1,
      'updatedAt': dateNow,
    }).then((value) {
      msg = true;
    }).catchError((onError) {
      msg = false;
    });

    if (msg) {
      int participant = ideas.ideaParticipant + 1;
      await ideaCollection.doc(ideas.ideaId).update({
        'ideaParticipant': participant,
        'updatedAt': dateNow,
      });
    }

    return msg;

  }

  static Future<bool> deleteRequestIdea(Ideas ideas, String idUser) async {
    await Firebase.initializeApp();
    bool msg;

    await ideaCollection.doc(ideas.ideaId).collection("participants").doc(idUser).delete().then((value) {
      msg = true;
    }).catchError((onError) {
      msg = false;
    });

    return msg;

  }

  static Future<bool> leaveIdea(Ideas ideas, String idUser) async {
    await Firebase.initializeApp();
    String dateNow = ActivityServices.dateNow();
    bool msg;

    await ideaCollection.doc(ideas.ideaId).collection("participants").doc(idUser).delete().then((value) {
      msg = true;
    }).catchError((onError) {
      msg = false;
    });

    if (msg) {
      int participant = ideas.ideaParticipant - 1;
      await ideaCollection.doc(ideas.ideaId).update({
        'ideaParticipant': participant,
        'updatedAt': dateNow,
      });
    }

    return msg;

  }

  static Future<bool> addFavoriteIdea(Ideas ideas) async {
    await Firebase.initializeApp();
    String uid = auth.currentUser.uid;
    String dateNow = ActivityServices.dateNow();

    bool msg;

    await userCollection.doc(uid).collection("favorites").doc(ideas.ideaId).set({
      'ideaId': ideas.ideaId,
      'favorite': true,
      'createdAt': dateNow,
      'updatedAt': dateNow,
    }).then((value) {
      msg = true;
    }).catchError((onError) {
      msg = false;
    });

    return msg;
  }

  static Future<bool> removeFavoriteIdea(Ideas ideas) async {
    await Firebase.initializeApp();
    String uid = auth.currentUser.uid;

    bool msg;

    await userCollection.doc(uid).collection("favorites").doc(ideas.ideaId).delete().then((value) {
      msg = true;
    }).catchError((onError) {
      msg = false;
    });

    return msg;
  }

}