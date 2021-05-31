part of 'services.dart';

class AuthServices {

  static FirebaseAuth auth = FirebaseAuth.instance;
  static CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  static DocumentReference userDoc;

  //setup storage
  static Reference ref;
  static UploadTask uploadTask;
  static String imgUrl;

  static Future<String> signUp(Users users) async {

    await Firebase.initializeApp();
    String dateNow = ActivityServices.dateNow();
    String msg = "";
    String token = "";
    String uid = "";

    UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: users.email, password: users.password);
    uid = userCredential.user.uid;
    token = await FirebaseMessaging.instance.getToken();
    userCredential.user.getIdToken();

    await userCollection.doc(uid).set({
      'uid': uid,
      'email': users.email,
      'password': users.password,
      'firstName': users.firstName,
      'lastName': users.lastName,
      'phone': users.phone,
      'address': users.address,
      'pic': users.pic,
      'token': token,
      'createdAt': dateNow,
      'updatedAt': dateNow,
    }).then((value) {
      msg = 'success';
    }).catchError((onError) {
      msg = ""+onError;
    });

    auth.signOut();
    return msg;

  }

  static Future<String> signIn(String email, String password) async {

    await Firebase.initializeApp();
    String dateNow = ActivityServices.dateNow();
    String msg = "";
    String token = "";
    String uid = "";

    UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
    uid = userCredential.user.uid;
    token = await FirebaseMessaging.instance.getToken();

    await userCollection.doc(uid).update({
      'isOn': '1',
      'token': token,
      'updatedAt': dateNow,
    }).then((value) {
      msg = 'success';
    }).catchError((onError) {
      msg = ""+onError;
    });

    return msg;

  }

  static Future<bool> signOut() async {

    await Firebase.initializeApp();
    String dateNow = ActivityServices.dateNow();
    String uid = auth.currentUser.uid;
    await auth.currentUser.uid;

    await auth.signOut().whenComplete(() {
      userCollection.doc(uid).update({
        'isOn': '0',
        'token': '-',
        'updatedAt': dateNow,
      });
    });

    return true;

  }

  static Future<bool> changeProfilePicture(PickedFile imgFile) async {
    await Firebase.initializeApp();
    String dateNow = ActivityServices.dateNow();

    String uid = auth.currentUser.uid;

    ref = FirebaseStorage.instance.ref().child("images").child(uid+".png");
    uploadTask = ref.putFile(File(imgFile.path));

    await uploadTask.whenComplete(() =>
      ref.getDownloadURL().then((value) => imgUrl = value)
    );

    await userCollection.doc(uid).update({
      'pic' : imgUrl,
      'updatedAt' : dateNow,
    });

    return true;
  }

}