import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:zoho_crm_clone/api_models/change_password%20api.dart';
import 'package:zoho_crm_clone/constants/constants.dart';
import 'package:flutter/cupertino.dart';

import 'dashboard.dart';

class ChangePass extends StatefulWidget {
  ChangePass({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  double _sigmaX = 0.0; // from 0-10
  double _sigmaY = 0.0; // from 0-10
  double _opacity = 0.1;
  bool dark = true;
  DateTime _chosenDateTime;
  dynamic oldpassController = TextEditingController();
  dynamic newpassController = TextEditingController();
  dynamic confnewpassController = TextEditingController();
  var currdt = DateTime.now();
  String username = '';
  String userid = '';
  String usertype = '';
  String clientname = '';
  String comapnyname = '';
  String mydropdownstate = 'hide';
  String mydropdown;
  Future Retrivedetails() async {
    SharedPreferences preferencename = await SharedPreferences.getInstance();
    SharedPreferences preferenceuid = await SharedPreferences.getInstance();
    SharedPreferences preferenceusertype =
        await SharedPreferences.getInstance();
    SharedPreferences preferenceclient = await SharedPreferences.getInstance();
    SharedPreferences preferencecompany = await SharedPreferences.getInstance();
    setState(() {
      username = preferencename.getString('name');
      userid = preferenceuid.getString('user_id');
      usertype = preferenceusertype.getString('user_type');
      clientname = preferenceclient.getString('client_name');
      comapnyname = preferencecompany.getString('company');
    });
  }

  @override
  void initState() {
    Retrivedetails();
    super.initState();
  }

  void _showDatePicker(ctx) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 500,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 400,
                    child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (val) {
                          setState(() {
                            _chosenDateTime = val;
                          });
                        }),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(ctx).pop(),
                  )
                ],
              ),
            ));
  }

  final _formKey = GlobalKey<FormState>();
  Future UpdateLeadLoader() {

    setState(() {

    });
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
                        'assets/images/updating.gif',
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
                              "Processing your request",
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 40,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.indigo,
                  ],
                ),
              ),
            ),
            title: Text(
              'Change Password',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 20,
                  fontWeight: FontWeight.w300),
            ),
            centerTitle: false,
            leading: IconButton(
                icon: Icon(Icons.west_sharp),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return Dashboard();
                  }));
                }),
            actions: [
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    var oldpass = oldpassController.text;
                    var newpass = newpassController.text;
                    var confirm = confnewpassController.text;
                    if (newpassController.text == oldpassController.text) {
                      Toast.show(
                          "old password and new password should not be same",
                          context,
                          duration: Toast.LENGTH_LONG,
                          gravity: Toast.CENTER);
                      setState(() {});
                    } else if (newpassController.text !=
                        confnewpassController.text) {
                      Toast.show(
                          "confirm password and new password didn't matched",
                          context,
                          duration: Toast.LENGTH_LONG,
                          gravity: Toast.CENTER);
                      setState(() {
                        //  mybtn ='show';
                      });
                    } else if (confnewpassController.text ==
                        oldpassController.text) {
                      Toast.show(
                          "confirm password and old password should not be same",
                          context,
                          duration: Toast.LENGTH_LONG,
                          gravity: Toast.CENTER);
                      setState(() {});
                    } else if (confnewpassController.text ==
                            newpassController.text &&
                        confnewpassController.text != oldpassController.text &&
                        oldpassController.text != newpassController.text) {
                      setState(() {
                        //  mybtn ='hide';
                      });
                      UpdateLeadLoader();
                      var rsp = await cpass(username, userid, oldpass, newpass);
                      if (rsp.containsKey('status')) {
                        if (rsp['status'] == true) {
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                            Toast.show("${rsp['message']}", context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.CENTER);
                          });
                        } else if (rsp['status'] == false) {
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                            Toast.show("${rsp['message']}", context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.CENTER);
                          });
                        }
                      }
                    } else {
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pop(context);

                        Toast.show(
                            'Unable to complete your process this time, please try again',
                            context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.CENTER);
                        if (debug == 'yes') {
                          print('timeout');
                        }
                        return false;
                      });
                    }
                  }
                },
              )
            ],
          ),
          body: Container(
            color: Colors.grey.withOpacity(0.2),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 17.2,
                          width: MediaQuery.of(context).size.width / 2.5,
                          color: Colors.grey.withOpacity(0.5),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Old Password',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                30),
                                      ),
                                      Text(
                                        '*',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22,
                                            color: Colors.red),
                                      ),
                                      Text(
                                        ' : ',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                30),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              MediaQuery.of(context).size.width / 2.5,
                          height: MediaQuery.of(context).size.height / 17.2,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            borderRadius: new BorderRadius.circular(0),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Old Password',
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              70,
                                      fontWeight: FontWeight.w300)),
                              style: TextStyle(color: Colors.black),
                              controller: oldpassController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter current password';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 17.2,
                          width: MediaQuery.of(context).size.width / 2.5,
                          color: Colors.grey.withOpacity(0.5),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'New Password',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                30),
                                      ),
                                      Text(
                                        '*',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22,
                                            color: Colors.red),
                                      ),
                                      Text(
                                        ' : ',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                30),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              MediaQuery.of(context).size.width / 2.5,
                          height: MediaQuery.of(context).size.height / 17.2,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            borderRadius: new BorderRadius.circular(0),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 0),
                            child: TextFormField(
                              obscureText: true,
                              obscuringCharacter: '*',
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'New Password',
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              70,
                                      fontWeight: FontWeight.w300)),
                              style: TextStyle(color: Colors.black),
                              controller: newpassController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter new password';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 17.2,
                          width: MediaQuery.of(context).size.width / 2.5,
                          color: Colors.grey.withOpacity(0.5),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Confirm New Password',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                30),
                                      ),
                                      Text(
                                        '*',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22,
                                            color: Colors.red),
                                      ),
                                      Text(
                                        ' : ',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                30),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              MediaQuery.of(context).size.width / 2.5,
                          height: MediaQuery.of(context).size.height / 17.2,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            borderRadius: new BorderRadius.circular(0),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 0),
                            child: TextFormField(
                              obscureText: true,
                              obscuringCharacter: '*',
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Confirm New Password',
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              70,
                                      fontWeight: FontWeight.w300)),
                              style: TextStyle(color: Colors.black),
                              controller: confnewpassController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please confirm new password';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
