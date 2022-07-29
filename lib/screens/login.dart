import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoho_crm_clone/api_models/forgotpass.dart';
import 'package:zoho_crm_clone/api_models/loginapi.dart';
import 'package:zoho_crm_clone/constants/constants.dart';
import 'package:zoho_crm_clone/screens/dashboard.dart';
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  dynamic emailnewController = TextEditingController();
  dynamic fpassemailnewController = TextEditingController();
  dynamic passwordController = TextEditingController();
  final _formnewkey = GlobalKey<FormState>();
  final _formnewkey1 = GlobalKey<FormState>();
  GoogleSignInAccount _currentUser;
  Future glogin(String email, String token) async {
    var uri = "$customurl/login.php";
    // print('ttt-$token2');
    final response = await http.post(uri, body: {
      'email': email,
      'type': 'glogin',
      'fb_token': 'abc',
      'token': token2
    }, headers: <String, String>{
      'Accept': 'application/json',
    });
    var convertedDatatoJson = json.decode(response.body);
    if (debug == 'yes') {
      print(convertedDatatoJson);
    }
    return convertedDatatoJson;
  }

  String message = '';
  bool visible = false;
  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    // _googleSignIn.signInSilently();
    _handleSignOut();
  }

  /* Future lll(String email) async {
    print(email);
    var uri = "https://oauth2.googleapis.com/tokeninfo?id_token=$email";
    final response = await http.get(
        uri,
        headers: <String, String>{
          'Accept': 'application/json',
        });
    var convertedDatatoJson = json.decode(response.body);
    print(convertedDatatoJson);
    return convertedDatatoJson;
    //BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyProfileClickedEvent);
  }*/
  String token2 = '';
  Future<void> _handleSignIn() async {
    //  await _googleSignIn.signIn();
    _googleSignIn.signIn().then((result) {
      result.authentication.then((googleKey) {
        //   print(googleKey.accessToken);
        //  print(googleKey.idToken);
        setState(() {
          token2 = googleKey.idToken;
        });

        //   print(_googleSignIn.currentUser.email);
      }).catchError((err) {
        print('inner error');
      });
    }).catchError((err) {
      print('error occured');
    });
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }

  String validateEmail(String value) {
    if (emailnewController.text != '') {
      Pattern pattern =
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?)*$";
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return 'Enter a valid email address';
      else
        return null;
    }
  }

  String btnstate;
  bool dark = true;
  String otp = '';
  Future show() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
        ),
        isScrollControlled: true,
        enableDrag: false,
        context: context,
        isDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Spacer(),
                    Container(
                      child: Image.asset(
                        'assets/images/loading.gif',
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 5,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: [
                            Text(
                              "Hold On!",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 10,
                                  color: Colors.black,
                                  letterSpacing: 1),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Fetching your details",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 18,
                                  color: Colors.black,
                                  letterSpacing: 1),
                            ),
                          ],
                        )),
                    Spacer(),
                  ],
                ),
              );
            }),
          );
        });
  }

  Future showfpassloader() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
        ),
        isScrollControlled: true,
        enableDrag: false,
        context: context,
        isDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Spacer(),
                    Container(
                      child: Image.asset(
                        'assets/images/loading.gif',
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 5,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: [
                            Text(
                              "Hold On!",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 10,
                                  color: Colors.black,
                                  letterSpacing: 1),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "We are matching details",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 18,
                                  color: Colors.black,
                                  letterSpacing: 1),
                            ),
                          ],
                        )),
                    Spacer(),
                  ],
                ),
              );
            }),
          );
        });
  }

  var fpassemailapistatus = 'got it';
  var mymsg = 'abc';
  var fpassresponse;
  Future forgotpass() {
    if (fpassemailapistatus == 'not got it') {
      Navigator.pop(context);
      Toast.show(mymsg, context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.white.withOpacity(0.5),
          textColor: Colors.black,
          backgroundRadius: 1);
    }
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
        ),
        isScrollControlled: true,
        enableDrag: false,
        context: context,
        isDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _formnewkey1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.cancel,
                              size: 50,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                fpassemailnewController.clear();
                                fpassemailapistatus = 'got it';
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 5,
                      ),
                      Image.asset(
                        'assets/images/fpass.jpg',
                        height: 200,
                        width: 200,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 15,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Step 1. Enter email address',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize:
                                    MediaQuery.of(context).size.width / 30,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        height: MediaQuery.of(context).size.height / 18,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.blue,
                          ),
                          borderRadius: new BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 15, right: 15, top: 0),
                          child: TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                      color: Colors.blue,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      fontWeight: FontWeight.w300)),
                              style: TextStyle(color: Colors.blue),
                              controller: fpassemailnewController,
                              validator: validateEmail),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () async {
                            if (fpassemailnewController.text != '' &&
                                fpassemailnewController.text.contains('@')) {
                              var email = fpassemailnewController.text;
                              Navigator.pop(context);
                              showfpassloader();
                              var fpass = await fpassemail(email);
                              print(fpass);
                              if (fpass.containsKey('status')) {
                                if (fpass['status'] == true) {
                                  fpassresponse = fpass;
                                  fpassemailapistatus = 'got it';
                                  fpassemailnewController.clear();
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    forgotpassotp();
                                  });
                                } else {
                                  mymsg = fpass['msg'];
                                  fpassemailapistatus = 'not got it';
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    forgotpass();
                                  });
                                }
                              }
                            } else {
                              Toast.show(
                                  "Please fill the correct email address to continue",
                                  context,
                                  duration: Toast.LENGTH_SHORT,
                                  gravity: Toast.BOTTOM,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.5),
                                  textColor: Colors.black,
                                  backgroundRadius: 1);
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height / 20,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 1.0,
                                  ),
                                ]),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Proceed to next step',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25,
                                        color: Colors.black),
                                  ),
                                  Icon(Icons.forward),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  Future forgotpassotp() {
    Toast.show('Enter the otp sent on your registered mobile number', context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.white.withOpacity(0.5),
        textColor: Colors.black,
        backgroundRadius: 1);
    Navigator.pop(context);
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
        ),
        isScrollControlled: true,
        enableDrag: false,
        context: context,
        isDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, top: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            size: 50,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 5,
                    ),
                    Image.asset(
                      'assets/images/fpass.jpg',
                      height: 200,
                      width: 200,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          'Enter OTP',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width / 15,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Step 2. Enter OTP',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: MediaQuery.of(context).size.width / 30,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 0),
                      child: OTPTextField(
                        length: 6,
                        width: MediaQuery.of(context).size.width / 1.3,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: MediaQuery.of(context).size.width / 10,
                        fieldStyle: FieldStyle.underline,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 20,
                        ),
                        onCompleted: (pin) {
                          otp = pin;
                          print(otp);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () async {
                          if (otp == '') {
                            Toast.show('Please Fill OTP', context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.BOTTOM,
                                backgroundColor: Colors.white.withOpacity(0.5),
                                textColor: Colors.black,
                                backgroundRadius: 1);
                          } else {
                            showfpassloader();
                            var otprespo = await fpassotp(
                                otp,
                                fpassresponse['data']['id'],
                                fpassresponse['data']['client_id'],
                                fpassresponse['data']['client_name']);
                            print(otprespo);
                            if (otprespo.containsKey('status')) {
                              if (otprespo['status'] == true) {
                                Future.delayed(const Duration(seconds: 2), () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              } else {
                                Future.delayed(const Duration(seconds: 2), () {
                                  Navigator.pop(context);
                                  Toast.show(otprespo['msg'], context,
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.BOTTOM,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.5),
                                      textColor: Colors.black,
                                      backgroundRadius: 1);
                                });
                              }
                            }
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 20,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 1.0,
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Submit',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                      color: Colors.black),
                                ),
                                Icon(Icons.check),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer()
                  ],
                ),
              );
            }),
          );
        });
  }

  var condition = '';
  var msg = '';

  @override
  Widget build(BuildContext context) {
    if (_currentUser != null) {
      return AlertDialog(
        backgroundColor: Colors.white,
        elevation: 30,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Center(
            child: Text('Approve Login',
                style: TextStyle(fontWeight: FontWeight.bold))),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Center(
                  child: Text(
                "Login with",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )),
              Center(
                  child: Text(
                "${_currentUser.email} ?",
                style: TextStyle(
                    color: Colors.indigo, fontWeight: FontWeight.bold),
              )),
              Divider(
                thickness: 5,
                color: Colors.white,
              ),
              Center(
                  child: Text(
                message,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
              Divider(
                thickness: 5,
                color: Colors.white,
              ),
              if (message == 'login failed')
                Center(child: Text("Please Try With Correct Email Id")),
              Visibility(
                  visible: visible,
                  child: Container(
                    // margin: EdgeInsets.only(bottom: 10,top: 10),
                    child: Container(
                      child: Image.asset(
                        'assets/images/loading.gif',
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 5,
                      ),
                    ),
                  )),
            ],
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            onPressed: () async {
              setState(() {
                message = 'please wait';
              });
              try {
                print(_currentUser.email);
                print(_currentUser.id);
                print(_currentUser.authentication);
                var rsp = await glogin(_currentUser.email, _currentUser.id);
                if (debug == 'yes') {
                  print(rsp);
                }
                if (rsp.containsKey('status')) {
                  setState(() {
                    message = rsp['error'];
                    visible = false;
                  });
                  if (rsp['status'] == true) {
                    setState(() {
                      visible = false;
                      message = 'login scuccessful';
                    });
                    SharedPreferences preferencename =
                        await SharedPreferences.getInstance();
                    preferencename.setString('name', rsp['data']['name']);
                    SharedPreferences preferenceuid =
                        await SharedPreferences.getInstance();
                    preferenceuid.setString('user_id', rsp['data']['uid']);
                    SharedPreferences preferenceusertype =
                        await SharedPreferences.getInstance();
                    preferenceusertype.setString(
                        'user_type', rsp['data']['upriv']);
                    SharedPreferences preferenceclient =
                        await SharedPreferences.getInstance();
                    preferenceclient.setString(
                        'client_name', rsp['data']['client']);
                    SharedPreferences preferencecompany =
                        await SharedPreferences.getInstance();
                    preferencecompany.setString(
                        'company', rsp['data']['company_name']);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    );
                  } else {
                    setState(() {
                      visible = false;
                      message = 'login failed';
                    });
                  }
                }
              } catch (error) {
                Toast.show('Unable To Reach Server, Please Check Your Internet',
                    context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                setState(() {
                  btnstate = 'show';
                  message = '';
                });

                return false;
              }
              Login();
            },
            color: Colors.amber,
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Row(
                children: [
                  Container(
                      child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  )),
                  Center(
                    child: Text(
                      "Proceed To Login",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              _handleSignOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return Login();
              }));
            },
            color: Colors.red,
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Icon(Icons.cancel),
                Text(
                  "Choose Another Email",
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 2.2, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height / 30,
          color: Colors.white,
          child: Align(
              alignment: Alignment.center,
              child: Text(
                'A Product of 30Days Technologies Pvt Ltd.',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 25,
                    fontWeight: FontWeight.w600),
              )),
        ),
        body: Form(
          key: _formnewkey,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/user.png',
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 18,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.blue,
                    ),
                    borderRadius: new BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: TextStyle(
                              color: Colors.blue,
                              fontSize: MediaQuery.of(context).size.height / 50,
                              fontWeight: FontWeight.w300)),
                      style: TextStyle(color: Colors.blue),
                      controller: emailnewController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 18,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.blue,
                    ),
                    borderRadius: new BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: TextStyle(
                              color: Colors.blue,
                              fontSize: MediaQuery.of(context).size.height / 50,
                              fontWeight: FontWeight.w300)),
                      style: TextStyle(color: Colors.blue),
                      controller: passwordController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'password missing';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_formnewkey.currentState.validate()) {
                      var email = emailnewController.text;
                      var password = passwordController.text;
                      var rsp = await loginUser(email, password);
                      show();
                      if (rsp.containsKey('status')) {
                        if (rsp['status'] == true) {
                          SharedPreferences preferencename =
                              await SharedPreferences.getInstance();
                          preferencename.setString('name', rsp['data']['name']);
                          SharedPreferences preferenceuid =
                              await SharedPreferences.getInstance();
                          preferenceuid.setString(
                              'user_id', rsp['data']['uid']);
                          SharedPreferences preferenceusertype =
                              await SharedPreferences.getInstance();
                          preferenceusertype.setString(
                              'user_type', rsp['data']['upriv']);
                          SharedPreferences preferenceclient =
                              await SharedPreferences.getInstance();
                          preferenceclient.setString(
                              'client_name', rsp['data']['client']);
                          SharedPreferences preferencecompany =
                              await SharedPreferences.getInstance();
                          preferencecompany.setString(
                              'company', rsp['data']['company_name']);
                          setState(() {
                            condition = 'true';
                            msg = rsp['msg'];
                          });
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => Dashboard()));
                          });

                          print(preferencecompany.getString('company'));
                        } else {
                          setState(() {
                            condition = 'error';
                            msg = rsp['msg'];
                          });
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                          });
                        }
                      } else {
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.pop(context);
                          setState(() {
                            condition = 'unhandle';
                          });
                        });
                      }
                      if (debug == 'yes') {
                        print(rsp);
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: MediaQuery.of(context).size.height / 20,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3.0,
                          ),
                        ]),
                    child: Center(
                      child: Text(
                        Constants.signInbtn,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width / 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          forgotpass();
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 23),
                        )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Spacer(),
                    Container(
                        width: MediaQuery.of(context).size.width / 7,
                        child: LinearProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                          backgroundColor: Colors.blue,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          'OR',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: MediaQuery.of(context).size.width / 20,
                              fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 7,
                        child: LinearProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                          backgroundColor: Colors.blue,
                        )),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () => [
                    {
                      // Navigator.pop(context),
                      // set state while we fetch data from API
                      _handleSignIn()
                    }
                  ],
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: MediaQuery.of(context).size.height / 20,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3.0,
                          ),
                        ],
                        color: Colors.white,
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Image.asset(
                            'assets/images/glogo.png',
                            width: MediaQuery.of(context).size.width / 15,
                          ),
                          Spacer(),
                          Text(
                            Constants.gsign,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 25,
                                color: Colors.black),
                          ),
                          Spacer(),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
                if (condition == 'true')
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: MediaQuery.of(context).size.height / 20,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3.0,
                          ),
                        ],
                        color: Colors.green,
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Center(
                      child: Text(
                        msg,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width / 25,
                            color: Colors.white),
                      ),
                    ),
                  ),
                if (condition == 'true') Spacer(),
                if (condition == 'error')
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: MediaQuery.of(context).size.height / 20,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3.0,
                          ),
                        ],
                        color: Colors.red,
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Center(
                      child: Text(
                        msg,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width / 25,
                            color: Colors.white),
                      ),
                    ),
                  ),
                if (condition == 'error') Spacer(),
                if (condition == 'unhandle')
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: MediaQuery.of(context).size.height / 20,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3.0,
                          ),
                        ],
                        color: Colors.red,
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Center(
                      child: Text(
                        'Unable to process the request this time, please retry',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width / 25,
                            color: Colors.white),
                      ),
                    ),
                  ),
                if (condition == 'unhandle') Spacer(),
                /* TextButton(onPressed: (){},
                    child: Text('Register a new user',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/23
                    ),)),*/
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
