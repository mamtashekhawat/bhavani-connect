import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AddStockScreen extends StatelessWidget {
  AddStockScreen({@required this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_AddStockScreen(
        title: title,
      ),
    );
  }
}

class F_AddStockScreen extends StatefulWidget {
  F_AddStockScreen({@required this.title});
  String title;
  @override
  _F_AddStockScreen createState() => _F_AddStockScreen();
}

class _F_AddStockScreen extends State<F_AddStockScreen> {
  final TextEditingController _addStockController = TextEditingController();
  final FocusNode _addStockFocusNode = FocusNode();
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: CustomAppBarDark(
          leftActionBar: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: Colors.white,
          ),
          leftAction: () {
            Navigator.pop(context, true);
          },
          primaryText: _title(),
          tabBarWidget: null,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "New ${widget.title} to be added",
                    style: titleStyle,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _addStockController,
                    //initialValue: _name,
                    textInputAction: TextInputAction.done,
                    obscureText: false,
                    validator: (value) => value.isNotEmpty
                        ? null
                        : '${widget.title} cant\'t be empty.',
                    focusNode: _addStockFocusNode,
                    //onSaved: (value) => _name = value,
                    decoration: new InputDecoration(
                      prefixIcon: Icon(
                        Icons.category,
                        color: backgroundColor,
                      ),
                      labelText: 'Enter ${widget.title} name',
                      //fillColor: Colors.redAccent,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(),
                      ),
                    ),

                    keyboardType: TextInputType.text,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${widget.title}'s which you have",
                    style: titleStyle,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                 
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                              Stockcard("Vasanth Steels", context),
                              Stockcard("Srivatsav Cements", context),
                              Stockcard("Vamsi Bricks", context),
                              Stockcard("Vasanth Steels", context),
                              Stockcard("Srivatsav Cements", context),
                              Stockcard("Vamsi Bricks", context),
                              Stockcard("Vasanth Steels", context),
                              Stockcard("Srivatsav Cements", context),
                              Stockcard("Vamsi Bricks", context),
                        ],
                      ),
                    ),
                  
                  SizedBox(
                    height: 500,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
//          GoToPage(
//              context,
//              AddInvoice(
//              ));
        },
        child: Icon(Icons.add),
        backgroundColor: backgroundColor,
      ),
    );
  } 

  String _title() {
    switch (widget.title) {
      case 'Item':
        return 'Items';
        break;

      case 'Category':
        return 'Categories';
        break;
      case 'Sub Category':
        return 'Sub Categories';
        break;
      case 'Unit':
        return 'Units';
        break;
      case 'Dealer':
        return 'Dealers';
        break;

      case 'Role':
        return 'Roles';
        break;
      case 'Construction Site':
        return 'Construction Sites';
        break;
    }
  }
}

Widget Stockcard(String name, BuildContext context) {
  return Slidable(
    actionPane: SlidableDrawerActionPane(),
    actionExtentRatio: 0.25,
    child: Card(
      elevation: 1,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  name,
                  style: subTitleStyle,
                ),
              )
            ],
          )),
    ),
//    actions: <Widget>[
//      IconSlideAction(
//        caption: 'Archive',
//        color: Colors.blue,
//        icon: Icons.archive,
//        //onTap: () => _showSnackBar('Archive'),
//      ),
//      IconSlideAction(
//        caption: 'Share',
//        color: Colors.indigo,
//        icon: Icons.share,
//        //onTap: () => _showSnackBar('Share'),
//      ),
//    ],
    secondaryActions: <Widget>[
      IconSlideAction(
        caption: 'Edit',
        color: Colors.black54,
        icon: Icons.mode_edit,
        //onTap: () => _showSnackBar('More'),
      ),
      IconSlideAction(
        caption: 'Delete',
        color: Colors.red,
        icon: Icons.delete,
        //  onTap: () => _showSnackBar('Delete'),
      ),
    ],
  );
}
