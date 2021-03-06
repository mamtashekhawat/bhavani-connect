import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/button_widget/to_do_button.dart';
import 'package:bhavaniconnect/common_widgets/loading_page.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_page.dart';
import 'package:bhavaniconnect/home_screens/authentication_screen/registrtion_screens/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPPage extends StatelessWidget {
  OTPPage({@required this.phoneNo, @required this.newUser});
  String phoneNo;
  bool newUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_OTPPage(),
    );
  }
}

class F_OTPPage extends StatefulWidget {
//  F_OTPPage({@required this.model, @required this.phoneNo, @required this.newUser});
//  final OtpModel model;
//  String phoneNo;
//  bool newUser;

//  static Widget create(BuildContext context, String phoneNo, bool newUser) {
//
//    final AuthBase auth = Provider.of<AuthBase>(context);
//    return ChangeNotifierProvider<OtpModel>(
//      create: (context) => OtpModel(auth: auth),
//      child: Consumer<OtpModel>(
//        builder: (context, model, _) => F_OTPPage(model: model, phoneNo: phoneNo, newUser: newUser,),
//      ),
//    );
//  }

  @override
  _F_OTPPageState createState() => _F_OTPPageState();
}

class _F_OTPPageState extends State<F_OTPPage> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  // String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

//  OtpModel get model => widget.model;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomOfflineWidget(
      onlineChild: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Scaffold(
          body: _buildContent(context),
        ),
      ),
    );
  }

  @override
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
              'Verify Mobile Number',
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Enter OTP sent to +91 9585753459.',
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
              keyboardType: TextInputType.number,
              controller: _otpController,
              textInputAction: TextInputAction.done,
              obscureText: false,
              focusNode: _otpFocusNode,
              //onEditingComplete:() =>_submit(),
              //onChanged: model.updateOtp,
              decoration: new InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: backgroundColor,
                ),
                labelText: "Enter OTP",
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                  borderSide: new BorderSide(),
                ),
              ),
              onChanged: (value) {
                this.smsOTP = value;
              },
              validator: (val) {
                if (val.length == 0) {
                  return "One Time Password cannot be empty";
                } else {
                  return null;
                }
              },
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
              text: 'Verify',
              textColor: Colors.white,
              backgroundColor: activeButtonBackgroundColor,
              onPressed: () {
                GoToPage(context, HomePage());
              },
              //onPressed: model.canSubmit ? () => _submit() : null,
              // onPressed: () {
              //   _auth.currentUser().then((user) {
              //     if (user != null) {
              //       GoToPage(context, HomePage());
              //       // Navigator.of(context).pop();
              //       // Navigator.of(context).pushReplacementNamed('/homepage');
              //     } else {
              //       signIn();
              //     }
              //   });
              // },
            ),
            SizedBox(height: 10.0),
            ToDoButton(
              assetName: 'images/googl-logo.png',
              text: 'Edit phone number',
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

  // Future<bool> smsOTPDialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return new AlertDialog(
  //           title: Text('Enter SMS Code'),
  //           content: Container(
  //             height: 85,
  //             child: Column(children: [
  //               TextField(
  //                 onChanged: (value) {
  //                   this.smsOTP = value;
  //                 },
  //               ),
  //               (errorMessage != ''
  //                   ? Text(
  //                       errorMessage,
  //                       style: TextStyle(color: Colors.red),
  //                     )
  //                   : Container())
  //             ]),
  //           ),
  //           contentPadding: EdgeInsets.all(10),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text('Done'),
  //               onPressed: () {
  //                 _auth.currentUser().then((user) {
  //                   if (user != null) {
  //                     GoToPage(context, HomePage());
  //                     // Navigator.of(context).pop();
  //                     // Navigator.of(context).pushReplacementNamed('/homepage');
  //                   } else {
  //                     signIn();
  //                   }
  //                 });
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final AuthResult user = await _auth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.user.uid == currentUser.uid);
      GoToPage(context, SignUpPage());
      // Navigator.of(context).pop();
      // Navigator.of(context).pushReplacementNamed('/homepage');
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
        // Navigator.of(context).pop();
        // smsOTPDialog(context).then((value) {
        //   print('sign in');
        // });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

//  @override
//  Future<void> _submit() async {
//    try {
//      widget.phoneNo == '8333876209' ? EMPLOYEE_PNO = widget.phoneNo : '';
//      print('otp${widget.newUser}');
//      if(widget.newUser){
//        await model.submit();
//        GoToPage(context, SignUpPage(phoneNo: widget.phoneNo));
//      }else{
//        await model.submit();
//        GoToPage(context, LandingPage());
//      }
//    } on PlatformException catch (e) {
//      PlatformExceptionAlertDialog(
//        title: 'Otp Verification failed',
//        exception: e,
//      ).show(context);
//    }
//  }
}
