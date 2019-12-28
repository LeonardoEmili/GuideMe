import 'package:GuideMe/commons/user.dart';
import 'package:GuideMe/fragments/explore_visited.dart';
import 'package:GuideMe/pages/feedback.dart';
import 'package:GuideMe/fragments/add_itinerary.dart';
import 'package:GuideMe/fragments/explore.dart';
import 'package:GuideMe/fragments/favourites.dart';
import 'package:GuideMe/pages/login.dart';
import 'package:GuideMe/utils/data.dart';
import 'package:flutter/material.dart';



class DrawerItem {
  String title;
  IconData icon;
  bool isMenuItem;
  
  DrawerItem(this.title, {this.icon=Icons.radio_button_unchecked, this.isMenuItem=true});
}

class AndroidLayout extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Esplora", icon: Icons.explore),
    new DrawerItem("Crea itinerario", icon: Icons.add_circle_outline),
    new DrawerItem("Itinerari seguiti", icon: Icons.done_outline),
    new DrawerItem("Preferiti", icon: Icons.favorite),
    new DrawerItem("Esci", icon: Icons.exit_to_app),
    /* not in menù indexed pages */
    new DrawerItem("Recensione", isMenuItem: false),
  ];


  int _staticIndex;
  int _title;

  AndroidLayout({Key key, int staticIndex = 0}) : super(key: key){
    this._staticIndex = staticIndex;
  }

  @override
  State<StatefulWidget> createState() => new AndroidLayoutState();
}

class AndroidLayoutState extends State<AndroidLayout> {
  int _selectedDrawerIndex = null;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new ExploreFragment();
      case 1:
        return new AddItinearyFragment();
      case 2:
        return new ExploreVisitedFragment();
      case 3:
        return new FavouritesFragment();
      case 5:
        return new FeedbackFragment();
      default:
        return new Text("Some error occured.");
    }
  }

  _onSelectItem(int index) {
    if (index == this.widget.drawerItems.where((item)=> item.isMenuItem).length-1) {
      Route route = MaterialPageRoute(builder: (context) => LoginPage());
      Navigator.pushReplacement(context, route);
      return;
    }
    if (index != _selectedDrawerIndex) {
      // Avoid reloading the current fragment
      setState(() => _selectedDrawerIndex = index);
    }
    // Close the drawer
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if(this._selectedDrawerIndex==null) this._selectedDrawerIndex = this.widget._staticIndex;

    var drawerOptions = <Widget>[];
    var menuItems = this.widget.drawerItems.where((item)=> item.isMenuItem).toList();
    for (int i = 0; i < menuItems.length; i++) {
      var d = menuItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }
    User currentUser = Data.users[Data.currentUserIndex];
    return new Scaffold(
      // Avoid the Scaffold to resize himself when
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName:
                  new Text('${currentUser.name} ${currentUser.surname}'),
              accountEmail: new Text(currentUser.email),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.white,
                child: new Text(currentUser.name[0].toUpperCase()),
              ),
            ),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),

      floatingActionButton: Visibility(
        child: FloatingActionButton(
          child: Icon(Icons.done),
          onPressed: ()=> setState(() => _selectedDrawerIndex = 0),
        ),
        visible: (_selectedDrawerIndex == 1),
      )
    );
  }
}
