part of '../pages.dart';

class Notification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification'
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                CardNotification(),
                CardNotification(),
                CardNotification(),
                CardNotification(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CardNotification extends StatelessWidget {
  const CardNotification({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              child: Image.asset(
                'assets/images/men2.jpg',
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
                    "Eddie ingin bekerja sama denganmu",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Aku ingin mencari partner kerja sama gan",
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
                    onPressed: () {},
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
                    onPressed: () {},
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