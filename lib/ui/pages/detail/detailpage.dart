part of '../pages.dart';

class DetailArgument {
  final Ideas idea;

  DetailArgument(this.idea);
}

class DetailPost extends StatefulWidget {

  static String routeName = "/detailpost";

  @override
  _DetailPostState createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {

  bool isLoading = false;

  void showConfirmDialog(BuildContext ctx, Ideas ideas) {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text("Are you sure want to send parnership request to this idea?"),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await IdeaServices.joinIdea(ideas).then((value) {
                    setState(() {
                      isLoading = false;
                    });
                    if (value == true) {
                      ActivityServices.showToast("Your request has been send!", cPrimaryColor);
                      Navigator.pushReplacementNamed(context, JoinIdea.routeName);
                    } else {
                      ActivityServices.showToast("Can't request join idea", cDangerColor);
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: cPrimaryColor
                ),
                child: Text("Yes"),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    primary: cDangerColor
                ),
                child: Text("No"),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final DetailArgument args = ModalRoute.of(context).settings.arguments as DetailArgument;

    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CustomAppbar(),
      body: Column(
        children: [
          SizedBox(
            width: getProportionateScreenWidth(238),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                args.idea.ideaImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [
                ProductDescription(
                  pressOnSeeMore: () {},
                  idea: args.idea,
                ),
                TopRoundedContainer(
                  color: Color(0xFFF5F6F9),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)
                        ),
                        child: Row(
                          children: [
                            ...List.generate(
                              4,
                                (index) => ParticipantCircleView()
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios),
                              color: cTextColor,
                            )
                          ],
                        ),
                      ),
                      TopRoundedContainer(
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: SizeConfig.screenWidth * 0.15,
                                right: SizeConfig.screenWidth * 0.15,
                                top: getProportionateScreenWidth(15),
                                bottom: getProportionateScreenWidth(40)
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: DefaultButton(
                                  text: "Join Partnership!",
                                  press: () {
                                    showConfirmDialog(context, args.idea);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}