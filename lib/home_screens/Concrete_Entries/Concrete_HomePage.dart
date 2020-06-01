import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/firebase_widget.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Concrete_Entries/Entry_description.dart';
import 'package:bhavaniconnect/home_screens/Concrete_Entries/Print_entries.dart';
import 'package:bhavaniconnect/home_screens/Concrete_Entries/add_concrete_entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ConcreteEntries extends StatelessWidget {
  final String currentUserId;
  const ConcreteEntries({Key key, this.currentUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_ConcreteEntries(currentUserId: currentUserId),
    );
  }
}

class F_ConcreteEntries extends StatefulWidget {
  final String currentUserId;
  const F_ConcreteEntries({Key key, this.currentUserId}) : super(key: key);
  @override
  _F_ConcreteEntries createState() => _F_ConcreteEntries();
}

class _F_ConcreteEntries extends State<F_ConcreteEntries> {
  int _n = 0;
  DocumentSnapshot usersDetail;
  String userRole, userDisplayName;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    usersDetail = await usersRef.document(widget.currentUserId).get();

    setState(() {
      userRole = usersDetail.data['role'];
      print('$userRole ----------------- userrole');
    });
  }

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
    var size = MediaQuery.of(context).size;
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
          rightActionBar: Icon(
            Icons.print,
            size: 25,
            color: Colors.white,
          ),
          rightAction: userRole != "Site Engineer"
              ? () {
                  GoToPage(context,
                      PrintEntries(currentUserid: widget.currentUserId));
                }
              : null,
          primaryText: 'Concrete Entries',
          tabBarWidget: null,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 560,
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 20),
                  child: userRole != "Site Engineer"
                      ? StreamBuilder<QuerySnapshot>(
                          stream: concreteEntryRef.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                              );
                            } else {
                              var itemData = snapshot.data.documents;
                              List<Widget> items = [];
                              for (int i = 0; i < itemData.length; i++) {
                                items.add(
                                    _buildConcrete(itemData[i], context, size));
                              }
                              return ListView(children: items);
                            }
                          },
                        )
                      : noAccessWidget(),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: userRole != "Site Engineer"
          ? FloatingActionButton(
              onPressed: () {
                GoToPage(
                    context,
                    AddConcreteEntry(
                      currentUserId: widget.currentUserId,
                    ));
              },
              child: Icon(Icons.add),
              backgroundColor: backgroundColor,
            )
          : Container(),
    );
  }

  Widget noAccessWidget() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('images/no_content.svg', height: 260.0),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "No access widget",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildConcrete(doc, BuildContext context, Size size) {
    var timestamp = doc['dateTime'];
    final constructionDate = (timestamp as Timestamp).toDate();

    return concreteEntry(
      size,
      context,
      '${DateFormat('d MMM, yyyy').format(constructionDate)} ',
      doc['constructionSite'],
      doc['concreteType'],
      doc['block'],
      doc['totalProgress'],
      doc['createdBy'],
      doc,
    );
  }
}

class ItemInfo {
  String slNo;
  String createdBy;
  String date;
  String site;
  String block;
  String concreteType;
  String yestProg;
  String totalProg;
  String remarks;

  ItemInfo({
    this.slNo,
    this.date,
    this.createdBy,
    this.site,
    this.block,
    this.concreteType,
    this.yestProg,
    this.totalProg,
    this.remarks,
  });
}

var items = <ItemInfo>[
  ItemInfo(
      slNo: '1',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      concreteType: "Strong Cement",
      block: "8th",
      yestProg: "30",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '2',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      concreteType: "Strong Cement",
      yestProg: "30",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '3',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      concreteType: "Strong Cement",
      yestProg: "30",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '4',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      concreteType: "Strong Cement",
      yestProg: "30",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '5',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      concreteType: "Strong Cement",
      yestProg: "30",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'),
];

Widget concreteEntry(
    Size size,
    BuildContext context,
    String date,
    String site,
    String concreteType,
    String block,
    String total,
    String createdBy,
    DocumentSnapshot doc) {
  return GestureDetector(
    onTap: () {
      GoToPage(context, EntryDescription(currentUserId: createdBy, doc: doc));
    },
    child: Padding(
      padding: const EdgeInsets.only(right: 15.0, left: 15, top: 20),
      child: Container(
        width: double.infinity,
        height: 190,
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 15,
              top: 0,
              child: Text(date, style: descriptionStyleDarkBlur3),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  left: 24,
                  top: 24,
                  right: size.width * .35,
                ),
                height: 165,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFEAEAEA).withOpacity(.45),
                  borderRadius: BorderRadius.circular(29),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(site, style: subTitleStyle1),
                    SizedBox(height: 10),
                    Text(
                      "Block: $block",
                      style: descriptionStyleDarkBlur1,
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Text(concreteType,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: subTitleStyleDark1),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: SizedBox(
                height: 50,
                width: size.width * .40,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Text("Progress: $total", style: subTitleStyleLight),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
