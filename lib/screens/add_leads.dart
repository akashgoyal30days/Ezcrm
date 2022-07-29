import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:zoho_crm_clone/api_models/add_leads_api.dart';
import 'package:zoho_crm_clone/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:zoho_crm_clone/screens/Leads.dart';
import 'dashboard.dart';

class AddLeads extends StatefulWidget {
  AddLeads({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddLeadsState createState() => _AddLeadsState();
}

class _AddLeadsState extends State<AddLeads> {
  double _sigmaX = 0.0; // from 0-10
  double _sigmaY = 0.0; // from 0-10
  double _opacity = 0.1;
  bool dark = true;
  DateTime _chosenDateTime;
  var currdt = DateTime.now();
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
  String _mycreditproduct;
  String _mycreditsource;
  DateTime selectedDate = DateTime.now();
  DateTime selectedDatenew = DateTime.now();
  var customFormat = DateFormat('yyyy-MM-dd');
  dynamic nameController = TextEditingController();
  dynamic phoneController = TextEditingController();
  dynamic emailController = TextEditingController();
  dynamic companyController = TextEditingController();
  dynamic addressController = TextEditingController();
  dynamic recievedController = TextEditingController();
  dynamic productsController = TextEditingController();
  dynamic remarksController = TextEditingController();
  String validateEmail(String value) {
    if (emailController.text != '') {
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

  String username = '';
  String userid = '';
  String usertype = '';
  String clientname = '';
  String comapnyname = '';
  String mydropdownstate = 'hide';
  List expnewdataproduct;
  List expnewdatastate;
  List expnewdatasource;
  String _mycreditcity;
  String _mycredit;
  String mydropdown;
  List expnewdata;
  String errorstate, errorcity, errorsource, errorproduct;
  //get products list
  Future fetchProducts() async {
    var urii = "$customurl/leads.php";
    final responseexp = await http.post(urii, body: {
      'uid': userid,
      'client': clientname,
      'type': 'fetch_product'
    }, headers: <String, String>{
      'Accept': 'application/json',
    });
    var convertedDatatoJson = json.decode(responseexp.body);
    if (debug == 'yes') {
      print(convertedDatatoJson);
      print(convertedDatatoJson['data'][0]['state']);
    }
    setState(() {
      expnewdataproduct = convertedDatatoJson['data'];
    });
  }

  //fetch state
  Future fetchState() async {
    var urii = "$customurl/leads.php";
    final responseexp = await http.post(urii, body: {
      'uid': userid,
      'client': clientname,
      'type': 'fetch_state'
    }, headers: <String, String>{
      'Accept': 'application/json',
    });
    var convertedDatatoJson = json.decode(responseexp.body);
    if (debug == 'yes') {
      print(convertedDatatoJson);
      print(convertedDatatoJson['data'][0]['state']);
    }
    setState(() {
      expnewdatastate = convertedDatatoJson['data'];
    });
    if (convertedDatatoJson['status'] == true) {
      setState(() {
        mydropdownstate = 'show';
      });
    }
  }

  //fetch source
  Future fetchSource() async {
    var urii = "$customurl/leads.php";
    final responseexp = await http.post(urii, body: {
      'uid': userid,
      'client': clientname,
      'type': 'fetch_source'
    }, headers: <String, String>{
      'Accept': 'application/json',
    });
    var convertedDatatoJson = json.decode(responseexp.body);
    if (debug == 'yes') {
      print(convertedDatatoJson);
      print(convertedDatatoJson['data'][0]['state']);
    }
    setState(() {
      expnewdatasource = convertedDatatoJson['data'];
    });
  }

  List expnewdatacity;
  Future fetchcity() async {
    var urii = "$customurl/leads.php";
    final responseexp = await http.post(urii, body: {
      'uid': userid,
      'client': clientname,
      'type': 'fetch_city',
      'state': _mycredit
    }, headers: <String, String>{
      'Accept': 'application/json',
    });
    var convertedDatatoJson = json.decode(responseexp.body);
    if (debug == 'yes') {
      print(convertedDatatoJson);
    }
    // print(convertedDatatoJson['data'][0]['district']);
    if (convertedDatatoJson['status'] == true) {
      setState(() {
        mydropdown = 'show';
      });
    }
    expnewdatacity = convertedDatatoJson['data'];
  }

  Future UpdateLeadLoader() {
    setState(() {
      // isopen = true;
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
  void initState() {
    Retrivedetails();
    super.initState();
  }

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
    fetchProducts();
    fetchState();
    fetchSource();
  }

  Future<Null> showPicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (picked != null && picked != selectedDate && picked != selectedDatenew)
      setState(() {
        selectedDate = picked;
        selectedDatenew = picked;
      });
  }

  Future backto(BuildContext context) {
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
                color: Colors.blue,
                height: MediaQuery.of(context).size.height / 5,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Which screen you want to go?',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 20),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.popUntil(
                                  context, (_) => !Navigator.canPop(context));
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return Dashboard();
                              }));
                            },
                            child: Row(
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Dashboard',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.popUntil(
                                  context, (_) => !Navigator.canPop(context));
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return Leads();
                              }));
                            },
                            child: Row(
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Assigned Leads',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
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
              'Add Leads',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 20,
                  fontWeight: FontWeight.w300),
            ),
            centerTitle: false,
            leading: IconButton(
                icon: Icon(Icons.west_sharp),
                onPressed: () {
                  /* Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                    return Dashboard();
                  }));*/
                  backto(context);
                }),
            actions: [
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () async {
                  if (debug == 'yes') {
                    print('rec- ${customFormat.format(selectedDate)}');
                    print(phoneController.text);
                  }
                  if (_formKey.currentState.validate()) {
                    if (_mycreditsource != null || _mycreditproduct != null) {
                      UpdateLeadLoader();
                      var res = await addleads(
                          _mycreditproduct,
                          nameController.text,
                          phoneController.text,
                          emailController.text,
                          companyController.text,
                          addressController.text,
                          _mycreditcity,
                          _mycredit,
                          _mycreditsource,
                          remarksController.text,
                          clientname,
                          userid,
                          customFormat.format(selectedDate));
                      if (debug == 'yes') {
                        print(res);
                      }
                      if (res.containsKey('status')) {
                        if (res['status'] == true) {
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                            Toast.show(res['message'], context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.CENTER);
                            setState(() {
                              nameController.clear();
                              phoneController.clear();
                              emailController.clear();
                              companyController.clear();
                              _mycredit = null;
                              remarksController.clear();
                              addressController.clear();
                              _mycreditsource = null;
                              selectedDate = DateTime.now();
                              _mycreditproduct = null;
                              _mycreditcity = null;
                            });
                          });
                        } else {
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                            Toast.show(res['message'], context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.CENTER);
                          });
                        }
                      } else {
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.pop(context);
                          Toast.show(
                              'Unable to complete your process this time, please try again',
                              context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.CENTER);
                        });
                      }
                    }
                  }
                },
              )
            ],
          ),
          body: Container(
            color: Colors.grey.withOpacity(0.2),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
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
                                        'Name',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22),
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
                                                22),
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
                                  hintText: 'Name',
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      fontWeight: FontWeight.w300)),
                              style: TextStyle(color: Colors.black),
                              controller: nameController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter name';
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
                                        'Email',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22),
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
                                                22),
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
                                    hintText: 'Email',
                                    hintStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                50,
                                        fontWeight: FontWeight.w300)),
                                style: TextStyle(color: Colors.black),
                                controller: emailController,
                                validator: validateEmail),
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
                                        'Phone',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22),
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
                                                22),
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
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10)
                              ],
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Phone',
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      fontWeight: FontWeight.w300)),
                              style: TextStyle(color: Colors.black),
                              controller: phoneController,
                              validator: (valuek) {
                                if (valuek.isEmpty) {
                                  return 'Please enter phone';
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
                                        'State',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22),
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
                                                22),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        mydropdownstate == 'hide'
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 9, 10, 0),
                                child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    8.5,
                                            child: Text(
                                              'Fetching State....',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            )),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  8.5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              17.2,
                                          child: LinearProgressIndicator(),
                                        ),
                                      ],
                                    )),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width -
                                    MediaQuery.of(context).size.width / 2.5,
                                height:
                                    MediaQuery.of(context).size.height / 17.2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                  borderRadius: new BorderRadius.circular(0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 0),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton<String>(
                                        dropdownColor: Colors.white,
                                        elevation: 0,
                                        value: _mycredit,
                                        iconSize: 30,
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black,
                                        ),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                        hint: Text(
                                          'Select State',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            _mycredit = newValue;
                                            if (debug == 'yes') {
                                              print(_mycredit);
                                            }
                                            _mycreditcity = null;
                                            _mycredit = newValue;
                                            mydropdown = 'hide';
                                            fetchcity();
                                          });
                                        },
                                        items: expnewdatastate?.map((item) {
                                              return new DropdownMenuItem(
                                                child: new Text(
                                                  item['state'],
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                value: item['state'].toString(),
                                              );
                                            })?.toList() ??
                                            [],
                                      ),
                                    ),
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
                                        'City',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22),
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
                                                22),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        mydropdown == 'hide'
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 9, 10, 0),
                                child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    8.5,
                                            child: Text(
                                              'Fetching City....',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            )),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  8.5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              17.2,
                                          child: LinearProgressIndicator(),
                                        ),
                                      ],
                                    )),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width -
                                    MediaQuery.of(context).size.width / 2.5,
                                height:
                                    MediaQuery.of(context).size.height / 17.2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                  borderRadius: new BorderRadius.circular(0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 0),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton<String>(
                                        dropdownColor: Colors.white,
                                        elevation: 0,
                                        value: _mycreditcity,
                                        iconSize: 30,
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black,
                                        ),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        hint: Text(
                                          'Select City',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onChanged: (String myvalue) {
                                          setState(() {
                                            if (debug == 'yes') {
                                              print('myvalue - $myvalue');
                                              print('mycity - $_mycreditcity');
                                            }
                                            _mycreditcity = myvalue;
                                            if (debug == 'yes') {
                                              print('mycity - $_mycreditcity');
                                            }
                                          });
                                        },
                                        items: expnewdatacity?.map((itemn) {
                                              return new DropdownMenuItem(
                                                child: new Text(
                                                  itemn['district'],
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                value: itemn['district']
                                                    .toString(),
                                              );
                                            })?.toList() ??
                                            [],
                                      ),
                                    ),
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
                          height: MediaQuery.of(context).size.height / 7.5,
                          width: MediaQuery.of(context).size.width / 2.5,
                          color: Colors.grey.withOpacity(0.5),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Address : ',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                22),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              MediaQuery.of(context).size.width / 2.5,
                          height: MediaQuery.of(context).size.height / 7.5,
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
                              maxLines: 5,
                              autocorrect: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Address',
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      fontWeight: FontWeight.w300)),
                              controller: addressController,
                              style: TextStyle(color: Colors.black),
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
                                        'Select Source',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22),
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
                                                22),
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
                          height: errorsource == 'show'
                              ? 20
                              : MediaQuery.of(context).size.height / 17.2,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: errorsource == 'show'
                                  ? Colors.red
                                  : Colors.grey.withOpacity(0.5),
                            ),
                            borderRadius: new BorderRadius.circular(0),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 0),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  elevation: 0,
                                  value: _mycreditsource,
                                  iconSize: errorsource == 'show' ? 0 : 30,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  hint: Text(
                                    'Source',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onChanged: (String newValuen) {
                                    setState(() {
                                      _mycreditsource = newValuen;
                                      errorsource = 'hide';
                                      if (debug == 'yes') {
                                        print(_mycreditsource);
                                      }
                                    });
                                  },
                                  items: expnewdatasource?.map((itemk) {
                                        return new DropdownMenuItem(
                                          child: new Text(
                                            itemk['source'],
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          value: itemk['source'].toString(),
                                        );
                                      })?.toList() ??
                                      [],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (errorsource == 'show')
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 5, 0, 0),
                          child: Text(
                            'Please select source',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
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
                                        'Received On',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22),
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
                                                22),
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
                          child: InkWell(
                            onTap: () {
                              showPicker(
                                  context); // Call Function that has showDatePicker()
                            },
                            child: IgnorePointer(
                              child: new TextFormField(
                                cursorColor: Colors.white,
                                decoration: new InputDecoration(
                                    errorStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                    border: const OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(0)),
                                    ),
                                    //icon: Icon(Icons.calendar_today_sharp, color: Colors.blueAccent,),
                                    labelText:
                                        ' Recieved on - ${customFormat.format(selectedDate)}',
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.black)),
                                onSaved: (String val) {
                                  customFormat.format(selectedDate);
                                },
                              ),
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
                                        'Select Products',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22),
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
                                                22),
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
                          height: errorproduct == 'show'
                              ? 20
                              : MediaQuery.of(context).size.height / 17.2,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: errorsource == 'show'
                                  ? Colors.red
                                  : Colors.grey.withOpacity(0.5),
                            ),
                            borderRadius: new BorderRadius.circular(0),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 0),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  elevation: 0,
                                  value: _mycreditproduct,
                                  iconSize: errorproduct == 'show' ? 0 : 30,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  hint: Text(
                                    'Select Products',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onChanged: (String value) {
                                    setState(() {
                                      _mycreditproduct = value;
                                      if (debug == 'yes') {
                                        print(_mycreditproduct);
                                      }
                                    });
                                  },
                                  items: expnewdataproduct?.map((itemn) {
                                        return new DropdownMenuItem(
                                          child: new Text(
                                            itemn['prod_name'],
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          value: itemn['prod_name'].toString(),
                                        );
                                      })?.toList() ??
                                      [],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (errorproduct == 'show')
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 5, 0, 0),
                          child: Text(
                            'Please select products',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
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
                                        'Company',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22),
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
                                                22),
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
                                  hintText: 'Company',
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      fontWeight: FontWeight.w300)),
                              style: TextStyle(color: Colors.black),
                              controller: companyController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter company name';
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
                          height: MediaQuery.of(context).size.height / 7.5,
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
                                        'Remarks',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22),
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
                                                22),
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
                          height: MediaQuery.of(context).size.height / 7.5,
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
                              maxLines: 5,
                              autocorrect: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Remarks',
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      fontWeight: FontWeight.w300)),
                              style: TextStyle(color: Colors.black),
                              controller: remarksController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter remarks';
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
