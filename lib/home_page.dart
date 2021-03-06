import 'package:bhavaniconnect/home_screens/dashboard.dart';
import 'package:bhavaniconnect/home_screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common_widgets/navigationBar.dart';
import 'common_widgets/offline_widgets/offline_widget.dart';

class HomePage extends StatelessWidget {
  final String currentUserId;
  const HomePage({Key key, this.currentUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_HomePage(
        currentUserId: currentUserId,
      ),
    );
  }
}

class F_HomePage extends StatefulWidget {
  final String currentUserId;
  final String title;
  F_HomePage({Key key, this.title, this.currentUserId}) : super(key: key);

  @override
  _F_HomePageState createState() => _F_HomePageState();
}

class _F_HomePageState extends State<F_HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return offlineWidget(context);
  }

  Widget offlineWidget(BuildContext context) {
    return CustomOfflineWidget(
      onlineChild: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Scaffold(
          body: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    Widget child;
    //final database = Provider.of<Database>(context, listen: false);

    switch (currentIndex) {
      case 0:
        child = Dashboard(
          currentUserId: widget.currentUserId,
        );
        break;
      case 1:
        child = ProfilePage(
          currentUserId: widget.currentUserId,
        );
        break;
    }
    return Scaffold(
      body: SizedBox.expand(
        child: child,
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) => setState(() {
          currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Home'),
            activeColor: Color(0XFF1F4B6E),
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
            activeColor: Color(0XFF1F4B6E),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
