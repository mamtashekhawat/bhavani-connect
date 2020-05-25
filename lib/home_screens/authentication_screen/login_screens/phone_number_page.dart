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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bhavaniconnect/common_widgets/firebase_widget.dart';

class PhoneNumberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_PhoneNumberPage(),
    );
  }
}

class F_PhoneNumberPage extends StatefulWidget {
//  F_PhoneNumberPage({@required this.model});
//  final PhoneNumberModel model;
//
//  static Widget create(BuildContext context) {
//    final AuthBase auth = Provider.of<AuthBase>(context);
//    return ChangeNotifierProvider<PhoneNumberModel>(
//      create: (context) => PhoneNumberModel(auth: auth),
//      child: Consumer<PhoneNumberModel>(
//        builder: (context, model, _) => F_PhoneNumberPage(model: model),
//      ),
//    );
//  }

  @override
  _F_PhoneNumberPageState createState() => _F_PhoneNumberPageState();
}

class _F_PhoneNumberPageState extends State<F_PhoneNumberPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  // PhoneNumberModel get model => widget.model;
  bool _btnEnabled = false;
  bool _optBtnEnabled = false;

  Future<bool> didCheckPhoneNumber;

  // verifyPhone() {
  //   GoToPage(context, OTPPage());
  // }
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
                if (value.length == 10) {
                  setState(() {
                    _btnEnabled = true;
                  });
                } else {
                  setState(() {
                    _btnEnabled = false;
                  });
                }
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
              onPressed: _btnEnabled ? verifyPhone : null,
              // onPressed: verifyPhone,
              // onPressed: () {
              //   GoToPage(context, OTPPage());
              // },
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
                    print(value.length);
                    if (value.length == 6) {
                      setState(() {
                        _optBtnEnabled = true;
                      });
                    } else {
                      setState(() {
                        _optBtnEnabled = false;
                      });
                    }
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
                  _optBtnEnabled
                      ? _auth.currentUser().then((user) {
                          if (user != null) {
                            checkUserInFirestore(user.uid);
                          } else {
                            signIn();
                          }
                        })
                      : print('null----------');
                },
              )
            ],
          );
        });
  }

  checkUserInFirestore(String userId) async {
    await usersRef.document(userId).get().then((doc) {
      if (doc.exists) {
        print('HomePage 1--------------------');
        Navigator.of(context).pop();
        GoToPage(context, HomePage());
      } else {
        print('SignUpPage 1------------------');
        DocumentReference documentReference = usersRef.document(userId);
        documentReference.setData({
          "phoneNumber": '+91${this.phoneNo}',
          "status": 0,
          "joinedDate": DateTime.now().toUtc(),
        }).then((val) {
          // String documentId = documentReference.documentID;
          Navigator.of(context).pop();
          GoToPage(
              context,
              SignUpPage(
                documentId: userId,
                phoneNo: _phoneNumberController.value.text,
              ));
        });
      }
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
      print('SignUpPage 2---------------');
      // Navigator.of(context).pop();
      // GoToPage(context, SignUpPage());
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
          print('sign in - handleError');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  // _checkForUser(BuildContext context) async {
  //   try {
  //     usersRef
  //         .where('phoneNumber',
  //             isEqualTo: '+91${_phoneNumberController.value.text}')
  //         .snapshots()
  //         .listen((data) => {
  //               print('data=$data'),
  //               if (data.documents.length == 0)
  //                 {
  //                   // model.submit(),
  //                   GoToPage(
  //                       context,
  //                       OTPPage(
  //                           phoneNo: _phoneNumberController.value.text,
  //                           newUser: true))
  //                 }
  //               else
  //                 {
  //                   //model.submit(),
  //                   GoToPage(
  //                       context,
  //                       OTPPage(
  //                           phoneNo: _phoneNumberController.value.text,
  //                           newUser: false))
  //                 }
  //             });
  //   } on PlatformException catch (e) {
  //     PlatformExceptionAlertDialog(
  //       title: 'Phone number failed',
  //       exception: e,
  //     ).show(context);
  //   }
  // }
}
