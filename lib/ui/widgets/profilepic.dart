part of 'widgets.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key key, this.img, this.name,
  }) : super(key: key);

  final String img;
  final String name;

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {

  PickedFile imageFile;
  final ImagePicker imagePicker = ImagePicker();

  Future chooseFile(String type) async{
    ImageSource imgSrc;
    if (type == "camera") {
      imgSrc = ImageSource.camera;
    } else {
      imgSrc = ImageSource.gallery;
    }

    final selectedImage = await imagePicker.getImage(
      source: imgSrc,
      imageQuality: 50,
    );
    setState(() {
      imageFile = selectedImage;
    });
  }

  void showFileDialog(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text("Pick image from:"),
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  await chooseFile("camera");
                  if (imageFile != null) {
                    await AuthServices.changeProfilePicture(imageFile).then((value) {
                      if (value == true) {
                        ActivityServices.showToast("Profile pic updated", cPrimaryColor);
                      } else {
                        ActivityServices.showToast("Error update profile", cDangerColor);
                      }
                    });
                  }
                },
                icon: Icon(Icons.camera_alt_outlined),
                label: Text("camera"),
              ),
              ElevatedButton.icon (
                onPressed: () async {
                  await chooseFile("gallery");
                  if (imageFile != null) {
                    await AuthServices.changeProfilePicture(imageFile).then((value) {
                      if (value == true) {
                        ActivityServices.showToast("Profile pic updated", cPrimaryColor);
                      } else {
                        ActivityServices.showToast("Error update profile", cDangerColor);
                      }
                    });
                  }
                },
                icon: Icon(Icons.photo_album_rounded),
                label: Text("Gallery"),
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 115,
          width: 115,
          child: Stack(
            fit: StackFit.expand,
            overflow: Overflow.visible,
            children: [
              CircleAvatar(
                backgroundImage: widget.img == cDefaultPicture
                    ? AssetImage(widget.img)
                    : NetworkImage(widget.img),
              ),
              Positioned(
                right: -12,
                bottom: 0,
                child: SizedBox(
                  height: 46,
                  width: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      showFileDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: Colors.white)
                      ),
                      primary: cSeccondaryColor,
                      elevation: 0,
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: cTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          widget.name,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black
          ),
        )
      ],
    );
  }
}