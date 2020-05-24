import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/button_widget/to_do_button.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/common_widgets/platform_alert/platform_exception_alert_dialog.dart';
import 'package:bhavaniconnect/home_page.dart';
import 'package:bhavaniconnect/home_screens/authentication_screen/login_screens/otp_page.dart';
import 'package:bhavaniconnect/home_screens/authentication_screen/registrtion_screens/sign_up_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PageViewDemo extends StatefulWidget {
  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      children: [
        FPhoneNumberPage(),
        MyPage2Widget(),
        MyPage3Widget(),
      ],
    );
  }
}

class FPhoneNumberPage extends StatefulWidget {
  @override
  _FPhoneNumberPageState createState() => _FPhoneNumberPageState();
}

class _FPhoneNumberPageState extends State<FPhoneNumberPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _phoneNumberFocusNode = FocusNode();

  Future<bool> didCheckPhoneNumber;
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _phoneNumberController.dispose();
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
          body: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          children: <Widget>[],
        ),
        Column(
          children: <Widget>[
            Text(
              'Enter Mobile Number',
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'To create an Account or SignIn \nuse your phone number.',
              style: descriptionStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Column(
          children: <Widget>[],
        ),
        Column(
          children: <Widget>[
            new TextFormField(
              controller: _phoneNumberController,
              textInputAction: TextInputAction.done,
              obscureText: false,
              focusNode: _phoneNumberFocusNode,
              // onEditingComplete: () => _submit(context),
              //  onChanged: model.updatePhoneNumber,
              onChanged: (value) {
                this.phoneNo = value;
              },
              decoration: new InputDecoration(
                prefixIcon: Icon(
                  Icons.phone,
                  color: backgroundColor,
                ),
                labelText: "Enter your mobile no.",
                //fillColor: Colors.redAccent,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                  borderSide: new BorderSide(),
                ),
              ),
              // autovalidate: true,
              validator: (val) {
                if (val.length == 0) {
                  return "Phone number cannot be empty";
                } else if (val.length == 10) {
                  return null;
                } else {
                  return "Phone number you entered is invalid.";
                }
              },
              keyboardType: TextInputType.phone,
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            (errorMessage != ''
                ? Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  )
                : Container()),
            SizedBox(height: 20.0),
            ToDoButton(
              assetName: 'images/googl-logo.png',
              text: 'Get OTP',
              textColor: Colors.white,
              backgroundColor: activeButtonBackgroundColor,
              // onPressed: _btnEnabled == true ? verifyPhone : null,
              onPressed: verifyPhone,
            ),
            SizedBox(height: 10.0),
            ToDoButton(
              assetName: 'images/googl-logo.png',
              text: 'back',
              textColor: Colors.black,
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });

      // _checkForUser(context);
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: '+91${this.phoneNo}', // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  _auth.currentUser().then((user) {
                    if (user != null) {
                      // GoToPage(context, HomePage());
                      Navigator.of(context).pop();
                      GoToPage(context, HomePage());
                    } else {
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final AuthResult user = await _auth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.user.uid == currentUser.uid);
      // GoToPage(context, HomePage());
      Navigator.of(context).pop();
      GoToPage(context, SignUpPage());
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        // _checkForUser(context);
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  _checkForUser(BuildContext context) async {
    try {
      Firestore.instance
          .collection('employees')
          .where('employee_contact_number',
              isEqualTo: '+91${_phoneNumberController.value.text}')
          .snapshots()
          .listen((data) => {
                print('data=$data'),
                if (data.documents.length == 0)
                  {
                    // model.submit(),
                    GoToPage(
                      context,
                      OTPPage(
                        phoneNo: _phoneNumberController.value.text,
                        newUser: true,
                      ),
                    ),
                  }
                else
                  {
                    //model.submit(),
                    GoToPage(
                      context,
                      OTPPage(
                        phoneNo: _phoneNumberController.value.text,
                        newUser: false,
                      ),
                    ),
                  }
              });
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Phone number failed',
        exception: e,
      ).show(context);
    }
  }
}

class MyPage2Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            MyBox(darkBlue, height: 50),
            MyBox(darkBlue, height: 50),
          ],
        ),
        Row(
          children: [
            MyBox(lightBlue),
            MyBox(lightBlue),
          ],
        ),
        MyBox(mediumBlue, text: 'PageView 2'),
        Row(
          children: [
            MyBox(lightBlue),
            MyBox(lightBlue),
          ],
        ),
      ],
    );
  }
}

class MyPage3Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            MyBox(darkRed),
            MyBox(darkRed),
          ],
        ),
        MyBox(mediumRed, text: 'PageView 3'),
        Row(
          children: [
            MyBox(lightRed),
            MyBox(lightRed),
            MyBox(lightRed),
          ],
        ),
      ],
    );
  }
}

const lightBlue = Color(0xff00bbff);
const mediumBlue = Color(0xff00a2fc);
const darkBlue = Color(0xff0075c9);

final lightGreen = Colors.green.shade300;
final mediumGreen = Colors.green.shade600;
final darkGreen = Colors.green.shade900;

final lightRed = Colors.red.shade300;
final mediumRed = Colors.red.shade600;
final darkRed = Colors.red.shade900;

class MyBox extends StatelessWidget {
  final Color color;
  final double height;
  final String text;

  MyBox(this.color, {this.height, this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(10),
        color: color,
        height: (height == null) ? 150 : height,
        child: (text == null)
            ? null
            : Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}
