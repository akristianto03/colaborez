part of '../pages.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cPrimaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWithSearchBox(),
            SizedBox(height: SizeConfig.screenHeight * 0.02,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 24,
                    child: Stack(
                      children: [
                        Text(
                          "Recent Ideas",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'see all',
                      style: TextStyle(
                        color: cTextColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  RecentCardView(
                    categoryName: 'Culinary',
                    image: 'assets/images/food.jpg',
                    press: () {},
                  ),
                  RecentCardView(
                    categoryName: 'Visual',
                    image: 'assets/images/visual.jpg',
                    press: () {},
                  ),
                  RecentCardView(
                    categoryName: 'Marketing',
                    image: 'assets/images/marketing.jpg',
                    press: () {},
                  ),
                  RecentCardView(
                    categoryName: 'Culinary',
                    image: 'assets/images/food.jpg',
                    press: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 24,
                    child: Stack(
                      children: [
                        Text(
                          "Discover New Friends",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'see all',
                      style: TextStyle(
                        color: cTextColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      )
                    ]
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NewFriends(
                        image: 'assets/images/men1.jpg',
                        firstName: 'Clent',
                      ),
                      NewFriends(
                        image: 'assets/images/men2.jpg',
                        firstName: 'Eddie',
                      ),
                      NewFriends(
                        image: 'assets/images/woman1.jpg',
                        firstName: 'Clara',
                      ),
                      NewFriends(
                        image: 'assets/images/woman2.jpg',
                        firstName: 'Lorenz',
                      ),
                      NewFriends(
                        image: 'assets/images/woman2.jpg',
                        firstName: 'Lorenz',
                      ),
                      NewFriends(
                        image: 'assets/images/woman2.jpg',
                        firstName: 'Lorenz',
                      ),
                      NewFriends(
                        image: 'assets/images/woman2.jpg',
                        firstName: 'Lorenz',
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

class NewFriends extends StatelessWidget {
  const NewFriends({
    Key key, this.image, this.firstName, this.idx,
  }) : super(key: key);

  final String image;
  final String firstName;
  final bool idx;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: getProportionateScreenWidth(15),
      ),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: Image.asset(
                image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(5),),
            Text(
              firstName
            )
          ],
        ),
      ),
    );
  }
}

class RecentCardView extends StatelessWidget {
  const RecentCardView({
    Key key, this.categoryName, this.image, this.press,
  }) : super(key: key);

  final String categoryName, image;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: getProportionateScreenWidth(15),
        top: getProportionateScreenWidth(15)/2,
        bottom: getProportionateScreenWidth(15) * 2.5
      ),
      width: SizeConfig.screenWidth * 0.35,
      child: GestureDetector(
        onTap: press,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
              child: Image.asset(
                image,
                width: SizeConfig.screenWidth * 0.35,
                height: 125,
                fit: BoxFit.cover,
              )
            ),
            Container(
              padding: EdgeInsets.only(
                top: 5,
                left: 5,
                right: 5,
                bottom: 15
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0,10),
                    blurRadius: 20,
                    color: cTextColor.withOpacity(0.23),
                  )
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    categoryName.toUpperCase()
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HeaderWithSearchBox extends StatelessWidget {
  const HeaderWithSearchBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.23,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            height: SizeConfig.screenHeight * 0.2 -5,
            decoration: BoxDecoration(
              color: cPrimaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36)
              )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(30)),
                  child: Text(
                    'Hi Fredo!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 36
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(25)),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: cTextColor.withOpacity(0.23)
                  )
                ]
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Ideas",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.search,
                    color: cTextColor,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}