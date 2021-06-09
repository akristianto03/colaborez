part of '../pages.dart';

class MainMenu extends StatefulWidget {
  static const String routeName = "/mainmenu";
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  int _selectedIndex = 0;
  int _iconIndex = 0;
  int temp = 0;
  static List<Widget> _widgetOption = [
    HomePage(),
    Search(),
    Notification(),
    Profile()
  ];

  void _onItemTapped(int index){
    setState(() {
      if (index == 2) {
        Navigator.pushNamed(context, AddPost.routeName);
      } else if(index>2){
        _selectedIndex = index-1;
      } else {
        _selectedIndex = index;
      }
      _iconIndex = index;
      if (_iconIndex == 2) {
        _iconIndex = temp;
      } else {
        temp = _iconIndex;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOption.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color:
                  Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                )
              ]
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 20,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                    color: cTextColor,
                  ),
                  activeIcon: Icon(
                    Icons.home_outlined,
                    color: cPrimaryColor,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.explore_outlined,
                    color: cTextColor,
                  ),
                  activeIcon: Icon(
                    Icons.explore_outlined,
                    color: cPrimaryColor,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_circle,
                    color: cTextColor,
                  ),
                  activeIcon: Icon(
                    Icons.add_circle,
                    color: cPrimaryColor,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: cTextColor,
                  ),
                  activeIcon: Icon(
                    Icons.notifications_outlined,
                    color: cPrimaryColor,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.people_outlined,
                    color: cTextColor,
                  ),
                  activeIcon: Icon(
                    Icons.people_outlined,
                    color: cPrimaryColor,
                  ),
                  label: '',
                ),
              ],
              currentIndex: _iconIndex,
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}
