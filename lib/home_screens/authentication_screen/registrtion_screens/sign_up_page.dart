import 'dart:io';
import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/button_widget/to_do_button.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_page.dart';
import 'package:device_info/device_info.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:bhavaniconnect/common_widgets/firebase_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({@required this.documentId, @required this.phoneNo});
  String documentId;
  String phoneNo;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_SignUpPage(
        documentId: documentId,
        phoneNo: phoneNo,
      ),
    );
  }
}

class F_SignUpPage extends StatefulWidget {
  F_SignUpPage({@required this.documentId, @required this.phoneNo});
  String documentId;
  String phoneNo;
//  F_SignUpPage({this.model, @required this.phoneNo});
//  final SignUpModel model;
//  String phoneNo;

//  static Widget create(BuildContext context, String phoneNo) {
//    final AuthBase auth = Provider.of<AuthBase>(context);
//
//    return ChangeNotifierProvider<SignUpModel>(
//      create: (context) => SignUpModel(auth: auth),
//      child: Consumer<SignUpModel>(
//        builder: (context, model, _) => F_SignUpPage(model: model, phoneNo: phoneNo),
//      ),
//    );
//  }
  @override
  _F_SignUpPageState createState() => _F_SignUpPageState();
}

class _F_SignUpPageState extends State<F_SignUpPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _formKey = GlobalKey<FormState>();
  int group = 1;
  File _profilePic;
  bool isUploading = false;
  bool isEdit = false;
  String fileEdit;
  Position _currentPosition;
  String role;
  String constructonSite;
  String deviceToken;
  DateTime selectedDate = DateTime.now();
  var customFormat = DateFormat("dd MMMM yyyy 'at' HH:mm:ss 'UTC+5:30'");
  var customFormat2 = DateFormat("dd MMMM yyyy");

//  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://bconnect-9d1b5.appspot.com/');
//  StorageUploadTask _uploadTask;
  String _profilePicPathURL;

  bool _loading;
  double _progressValue;

  @override
  void initState() {
    super.initState();
    _loading = false;
    _progressValue = 0.0;
  }

  final StorageReference storageRef = FirebaseStorage.instance.ref();
  Future<Null> showPicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1930),
      lastDate: DateTime(2010),
    );
    if (picked != null) {
      setState(() {
        print(customFormat.format(picked));
        selectedDate = picked;
      });
    }
  }

  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();

  //SignUpModel get model => widget.model;

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return offlineWidget(context);
  }

  Widget offlineWidget(BuildContext context) {
    return CustomOfflineWidget(
      onlineChild: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Scaffold(
          body: SingleChildScrollView(child: _buildContent(context)),
        ),
      ),
    );
  }

//  Future<void> _captureImage() async{
//    File profileImage = await ImagePicker.pickImage(source: IMAGE_SOURCE);
//setState(() {
//  _profilePic = profileImage;
//  print(_profilePic);
//});
//  }

  Widget signupContent(Widget signInBtn) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Create your own \naccount today',
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'To create an Account enter your name and date of birth.',
                    style: descriptionStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: <Widget>[
                  GestureDetector(
                    child: _profilePic == null
                        ? Container(
                            width: 120,
                            height: 120,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 50, left: 25),
                              child: Text(
                                'Add Photo',
                                style: descriptionStyle,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                          )
                        : Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: FileImage(
                                  _profilePic,
                                ), //here add your image filepath
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    onTap: handleChooseFromGallery,
                  ),
                  SizedBox(height: 40.0),
                  SizedBox(
                    height: 20,
                  ),
                  new TextFormField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.done,
                    obscureText: false,
                    focusNode: _usernameFocusNode,
                    // onEditingComplete: () => _imageUpload(),
                    // onChanged: model.updateUsername,
                    decoration: new InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: backgroundColor,
                      ),
                      labelText: "Enter your name",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    validator: (val) {
                      var newVal = val.trim();
                      if ((newVal.length == 0) && (newVal.isEmpty)) {
                        return "Username cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(height: 20.0),
                  DropdownSearch(
                    showSelectedItem: true,
                    maxHeight: 400,
                    mode: Mode.MENU,
                    items: [
                      "Manager",
                      "Site Engineer",
                      "Store Manager",
                      "Accountant",
                      "Security"
                    ],
                    label: "Employee Role",
                    onChanged: print,
                    selectedItem: "Choose your role",
                    showSearchBox: true,
                    // validate: (val) {
                    //   var newVal = val.trim();
                    //   if ((newVal.length == 0) && (newVal.isEmpty)) {
                    //     return "Role cannot be empty";
                    //   } else {
                    //     return null;
                    //   }
                    // },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownSearch(
                    showSelectedItem: true,
                    maxHeight: 400,
                    mode: Mode.MENU,
                    items: [
                      "Bhavani Vivan",
                      "Bahavani Aravindham",
                      "Bhavani Vivan",
                      "Bahavani Aravindham",
                      "Bhavani Vivan",
                      "Bahavani Aravindham",
                    ],
                    label: "Construction Site",
                    onChanged: print,
                    selectedItem: "Choose Construction Site",
                    showSearchBox: true,
                    // validate: (val) {
                    //   var newVal = val.trim();
                    //   if ((newVal.length == 0) && (newVal.isEmpty)) {
                    //     return "Construction Site cannot be empty";
                    //   } else {
                    //     return null;
                    //   }
                    // },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0, bottom: 10),
                    child: Container(
                      child: RaisedButton(
                        color: Colors.white,
                        child: Container(
                          height: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                'Select your date of birth.',
                                style: descriptionStyle,
                                textAlign: TextAlign.center,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.date_range,
                                          size: 18.0,
                                          color: backgroundColor,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                            '${customFormat2.format(selectedDate)}',
                                            style: subTitleStyle),
                                      ],
                                    ),
                                  ),
                                  Text('Change', style: subTitleStyle),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        onPressed: () => showPicker(context),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  signInBtn,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Create your own \naccount today',
                      style: titleStyle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'To create an Account enter your name and date of birth.',
                      style: descriptionStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      child: _profilePic == null
                          ? Container(
                              width: 120,
                              height: 120,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 50, left: 25),
                                child: Text(
                                  'Add Photo',
                                  style: descriptionStyle,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                shape: BoxShape.circle,
                              ),
                            )
                          : Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: FileImage(
                                    _profilePic,
                                  ), //here add your image filepath
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      onTap: handleChooseFromGallery,
                    ),
                    SizedBox(height: 40.0),
                    new TextFormField(
                      controller: _usernameController,
                      textInputAction: TextInputAction.done,
                      obscureText: false,
                      focusNode: _usernameFocusNode,
                      // onEditingComplete: () => _imageUpload(),
                      // onChanged: model.updateUsername,
                      decoration: new InputDecoration(
//                      prefixIcon: Icon(
//                        Icons.account_circle,
//                        color: backgroundColor,
//                      ),
                        labelText: "Enter your name",
                        labelStyle: descriptionStyleDark,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      validator: (val) {
                        var newVal = val.trim();
                        if ((newVal.length == 0) && (newVal.isEmpty)) {
                          return "Username cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    DropdownSearch(
                      showSelectedItem: true,
                      maxHeight: 400,
                      mode: Mode.MENU,
                      items: [
                        "Manager",
                        "Site Engineer",
                        "Store Manager",
                        "Accountant",
                        "Security"
                      ],
                      label: "Employee Role",
                      onChanged: print,
                      selectedItem: "Choose your role",
                      showSearchBox: true,
                      // validate: (val) {
                      //   var newVal = val.trim();
                      //   if ((newVal.length == 0) && (newVal.isEmpty)) {
                      //     return "Role cannot be empty";
                      //   } else {
                      //     return null;
                      //   }
                      // },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    DropdownSearch(
                      showSelectedItem: true,
                      maxHeight: 400,
                      mode: Mode.MENU,
                      items: [
                        "Bhavani Vivan",
                        "Bahavani Aravindham",
                        "Bhavani Vivan",
                        "Bahavani Aravindham",
                        "Bhavani Vivan",
                        "Bahavani Aravindham",
                      ],
                      label: "Construction Site",
                      onChanged: print,
                      selectedItem: "Choose Construction Site",
                      showSearchBox: true,
                      // validate: (val) {
                      //   var newVal = val.trim();
                      //   if ((newVal.length == 0) && (newVal.isEmpty)) {
                      //     return "Construction Site cannot be empty";
                      //   } else {
                      //     return null;
                      //   }
                      // },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0, bottom: 10),
                      child: Container(
                        child: RaisedButton(
                          color: Colors.white,
                          child: Container(
                            height: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  'Select your date of birth.',
                                  style: descriptionStyle,
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.date_range,
                                            size: 18.0,
                                            color: backgroundColor,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              '${customFormat2.format(selectedDate)}',
                                              style: subTitleStyle),
                                        ],
                                      ),
                                    ),
                                    Text('Change', style: subTitleStyle),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          onPressed: () => showPicker(context),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Gender",
                          style: subTitleStyle1,
                        ),
                        Radio(
                          value: 1,
                          groupValue: group,
                          onChanged: (T) {
                            print(T);
                            setState(() {
                              group = T;
                            });
                          },
                        ),
                        Text(
                          "Male",
                          style: descriptionStyleDarkBlur2,
                        ),
                        Radio(
                          value: 2,
                          groupValue: group,
                          onChanged: (T) {
                            print(T);
                            setState(() {
                              group = T;
                            });
                          },
                        ),
                        Text(
                          "Female",
                          style: descriptionStyleDarkBlur2,
                        ),
                      ],
                    ),
                    SizedBox(height: 25.0),
                    ToDoButton(
                      assetName: 'images/googl-logo.png',
                      text: 'Register',
                      textColor: Colors.white,
                      backgroundColor: activeButtonBackgroundColor,
                      onPressed: isUploading ? nothing() : () => handleSubmit(),
                      // onPressed: () {
                      //   GoToPage(context, HomePage());
                      // },
                      //onPressed: model.canSubmit ? () => _imageUpload() : null,
                    ),
                    SizedBox(height: 50.0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

//    if (_uploadTask != null) {
//      return StreamBuilder<StorageTaskEvent>(
//          stream: _uploadTask.events == null ? null :_uploadTask.events,
//          builder: (context, snapshot) {
//            var event = snapshot?.data?.snapshot;
//
//            _progressValue =
//            event != null ? event.bytesTransferred / event.totalByteCount : 0;
//
//            return signupContent(
//              Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                LinearProgressIndicator(
//                  value: _progressValue,
//                ),
//                Text('${(_progressValue * 100).round()}%'),
//              ],
//            ),
//            );
//          }
//      );
//    }else{
//      return signupContent(
//          ToDoButton(
//            assetName: 'images/googl-logo.png',
//            text: 'Register',
//            textColor: Colors.white,
//            backgroundColor: activeButtonBackgroundColor,
//            onPressed: model.canSubmit ? () => _imageUpload() : null,
//          ),
//      );
//
//    }
  }

  Future<void> handleChooseFromGallery() async {
    File profileImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      // fileEdit = null;
      this._profilePic = profileImage;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(_profilePic.readAsBytesSync());
    final compressedImageFile = File('$path/${widget.documentId}.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      //  fileEdit = null;
      _profilePic = compressedImageFile;
    });
  }

  _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      setState(() {
        deviceToken = iosDeviceInfo.identifierForVendor; // unique ID on iOS
      });
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      setState(() {
        deviceToken = androidDeviceInfo.androidId; // unique ID on Android
      });
    }
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        storageRef.child("userImg/${widget.documentId}.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  createUserInFirestore({
    String mediaUrl,
    String userName,
    String dob,
    int gender,
    String role,
    String constructionSite,
    double latitude,
    double longitude,
    String dToken,
  }) {
    print(widget.phoneNo);
    usersRef.document(widget.documentId).updateData({
      // "phoneNumber": widget.phoneNo,
      "profilePic": mediaUrl,
      "userName": userName.toLowerCase(),
      "dob": dob,
      "gender": gender,
      "role": role,
      "constructionSite": constructionSite,
      "status": 1,
      "joinedDate": DateTime.now().toUtc(),
      "latitude": latitude,
      "longitude": longitude,
      "divice_token": dToken,
    });
  }

  handleSubmit() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();

    await _getCurrentLocation();
    await _getId();

    setState(() {
      isUploading = true;
    });

    String mediaUrl;
    if (_profilePic != null) {
      await compressImage();
      mediaUrl = await uploadImage(_profilePic);
    } else {
      mediaUrl = fileEdit;
    }

    createUserInFirestore(
      mediaUrl: mediaUrl,
      userName: _usernameController.text,
      gender: group,
      dob: customFormat2.format(selectedDate),
      role: "",
      constructionSite: "",
      latitude: _currentPosition.latitude,
      longitude: _currentPosition.longitude,
      dToken: deviceToken,
    );
    _usernameController.clear();
    // customFormat2 = null;
    setState(() {
      _profilePic = null;
      isUploading = false;
    });

    GoToPage(context, HomePage());
  }

  nothing() {
    print('null');
  }

//  Future<void> _submit(String path) async {
//
//    try {
//      FirebaseUser user = await FirebaseAuth.instance.currentUser();
//      final employeeDetails = EmployeeDetails(
//        username: _usernameController.value.text,
//        phoneNumber: '+91${widget.phoneNo}',
//        gender: 'Not mentioned',
//        dateOfBirth: Timestamp.fromDate(selectedDate),
//        joinedDate: Timestamp.fromDate(DateTime.now()),
//        latitude: '',
//        longitude: '',
//        role: 'Not assigned',
//        employeeImagePath: path,
//        deviceToken: DEVICE_TOKEN,
//      );
//
//      await FirestoreService.instance.setData(
//        path: APIPath.employeeDetails(user.uid),
//        data: employeeDetails.toMap(),
//      );
//      GoToPage(context, LandingPage());
//
//    } on PlatformException catch (e) {
//      PlatformExceptionAlertDialog(
//        title: 'Something went wrong.',
//        exception: e,
//      ).show(context);
//    }
//  }
//
//  void _imageUpload() async {
//    _loading = !_loading;
//    if (_profilePic != null ) {
//      String _profilePicPath = 'profile_pic_images/${DateTime.now()}.png';
//      setState(() {
//        _uploadTask =
//            _storage.ref().child(_profilePicPath).putFile(_profilePic);
//      });
//      _profilePicPathURL = await (await _storage
//          .ref()
//          .child(_profilePicPath)
//          .putFile(_profilePic)
//          .onComplete)
//          .ref
//          .getDownloadURL();
//
//      _submit(_profilePicPathURL);
//    }
//  }
}
