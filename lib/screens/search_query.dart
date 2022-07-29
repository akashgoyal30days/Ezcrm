import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoho_crm_clone/api_models/assigned_leads.dart';
import 'package:zoho_crm_clone/api_models/searchquery.dart';
import 'package:zoho_crm_clone/constants/constants.dart';
import 'package:zoho_crm_clone/model/logout_model.dart';
import 'package:zoho_crm_clone/screens/Leads.dart';
import 'package:http/http.dart' as http;
import 'package:zoho_crm_clone/screens/followup.dart';
import 'change pass.dart';
import 'contact_us.dart';
import 'dashboard.dart';
import 'feedback.dart';

class S_Query extends StatefulWidget {
  S_Query({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _S_QueryState createState() => _S_QueryState();
}

class _S_QueryState extends State<S_Query> {
  double _sigmaX = 0.0; // from 0-10
  double _sigmaY = 0.0; // from 0-10
  double _opacity = 0.1;
  bool dark = true;
  dynamic searchcontroller = TextEditingController();
  String _mycreditmodal;
  List expnewdata;
  String _valuenew;
  DateTime _chosenDateTime;
  var lead_type_data;
  var lead_data;
  var datalist;
  var currdt = DateTime.now();
  String username = '';
  String userid = '';
  String usertype = '';
  String clientname = '';
  String comapnyname = '';
  String mydropdownstate = 'hide';
  String mydropdown;
  @override
  void initState() {
    Retrivedetails();
    super.initState();
  }

  var myleaddatalist = [];
  Future Logout(BuildContext context) {
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
                color: Colors.red,
                height: MediaQuery.of(context).size.height / 5,
                child: Column(
                  children: [
                    Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Are you sure you want to Log Out?',
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
                              logOut(context);
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
                                          'Yes',
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
                              Navigator.pop(context);
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
                                          'No',
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
                    Spacer(),
                  ],
                ),
              );
            }),
          );
        });
  }

  //email validator
// ignore: missing_return
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
    go_for_lead_type(userid, clientname);

    fetchProducts();
    fetchState();
    fetchSource();
  }

  Future go_for_lead_type(String usrid, String client) async {
    lead_type_data = await Get_Leads_Type(usrid, client);
    if (lead_type_data.containsKey('status')) {
      if (lead_type_data['status'] == true) {
        setState(() {
          expnewdata = lead_type_data['data'];
        });
      }
    }

    if (debug == 'yes') {
      print(lead_type_data);
    }
  }

  Future go_for_lead_search(
      String usrid, String client, String entvalue) async {
    lead_data = await sqry(usrid, client, entvalue);
    if (lead_data.containsKey('status')) {
      if (lead_data['status'] == true) {
        setState(() {
          mydata = lead_data['data'];
          myleaddatalist = mydata['leads'].toList();
        });
        if (debug == 'yes') {
          print('lead- $myleaddatalist');
        }
      }
    }
  }

  Future showMsg() {
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
                        'assets/images/send_msg.gif',
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
                              "Sending text message",
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

  var myleadfollowdetails = [];
  var follow_det;

  Future go_for_lead_follow(String lid, String usrid, String client) async {
    follow_det = await Get_Leads_followup(usrid, client, lid);
    if (follow_det.containsKey('status')) {
      if (follow_det['status'] == true) {
        setState(() {
          myleadfollowdetails = follow_det['followps'];
        });
        Showfollowdet();
        if (debug == 'yes') {
          print('follow- $myleadfollowdetails');
        }
      }
    }
  }

  //lead information dialog
  // ignore: non_constant_identifier_names
  void ShowInfo(
      String lid,
      String Name,
      String Companyname,
      String Phone,
      String Email,
      String Source,
      String Product,
      String City,
      String State,
      String Remarks,
      String Smssent,
      String lastsmssent,
      String Emailsent,
      String lastemailsent,
      String whatsappsent,
      String lastwhatsapp,
      String Enqtime,
      String lastupdatedate) {
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
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20, top: 20),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                child: Text(
                                  'Show Followup Details',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () {
                                  go_for_lead_follow(lid, userid, clientname);
                                },
                              )),
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
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 30,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          'Lead Information',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width / 15,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 30,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Name:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        Name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Company Name:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        Companyname,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Phone:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        Phone,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Email:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        Email,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'State:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        State,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'City:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        City,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Source:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        Source,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Product:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        Product,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Sms Sent:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        Smssent,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Last Sms Sent:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                      if (lastsmssent == null)
                                        Text(
                                          'No data available',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25,
                                              color: Colors.black),
                                        ),
                                      if (lastsmssent != null)
                                        Text(
                                          lastsmssent,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25,
                                              color: Colors.black),
                                        ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Email Sent:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        Emailsent,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Last Email Sent:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                      if (lastemailsent == null)
                                        Text(
                                          'No data available',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25,
                                              color: Colors.black),
                                        ),
                                      if (lastemailsent != null)
                                        Text(
                                          lastemailsent,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25,
                                              color: Colors.black),
                                        ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Whatsapp Sent:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        whatsappsent,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Last Whatsapp Sent:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                      if (lastwhatsapp == null)
                                        Text(
                                          'No data available',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25,
                                              color: Colors.black),
                                        ),
                                      if (lastwhatsapp != null)
                                        Text(
                                          lastwhatsapp,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25,
                                              color: Colors.black),
                                        ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Enquiry Time:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                      if (Enqtime == null)
                                        Text(
                                          'No data available',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25,
                                              color: Colors.black),
                                        ),
                                      if (Enqtime != null)
                                        Text(
                                          Enqtime,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25,
                                              color: Colors.black),
                                        ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Last Update Date:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black),
                                      ),
                                      if (lastupdatedate == null)
                                        Text(
                                          'No data available',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25,
                                              color: Colors.black),
                                        ),
                                      if (lastupdatedate != null)
                                        Text(
                                          lastupdatedate,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25,
                                              color: Colors.black),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                    Spacer()
                  ],
                ),
              );
            }),
          );
        });
  }

  var outputFormat = DateFormat('dd/MM/yyyy hh:mm a');

  void Showfollowdet() {
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
                      height: MediaQuery.of(context).size.width / 30,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          'Followup Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width / 15,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 30,
                    ),
                    if (myleadfollowdetails.isEmpty)
                      Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            'No follow up details',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize:
                                    MediaQuery.of(context).size.width / 15,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    if (myleadfollowdetails.isEmpty)
                      Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            'available',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize:
                                    MediaQuery.of(context).size.width / 15,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    if (myleadfollowdetails.isNotEmpty)
                      Container(
                        height: MediaQuery.of(context).size.height - 200,
                        child: ListView.builder(
                            itemCount: myleadfollowdetails.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                //height: 100,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 5,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Reminder Date:',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                '${outputFormat.format(DateTime.parse(myleadfollowdetails[index]['reminder_time']))}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Reminder Marked Date:',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                '${outputFormat.format(DateTime.parse(myleadfollowdetails[index]['followup_time']))}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Remarks:',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                myleadfollowdetails[index]
                                                    ['remark'],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    Spacer()
                  ],
                ),
              );
            }),
          );
        });
  }

  var intrim_credit_val = '';

  Future showMail() {
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
                        'assets/images/send_mail.gif',
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
                              "Sending mail",
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

  String pickeddate = DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now());

  //add reminder api
  Future addreminder(String lid, String dateipick) async {
    try {
      var urii = "$customurl/leads.php";
      final responseexp = await http.post(urii, body: {
        'uid': userid,
        'client': clientname,
        'type': 'add_followup',
        'lead_id': lid,
        'date': dateipick.toString(),
        'remarks': reminderremarksController.text
      }, headers: <String, String>{
        'Accept': 'application/json',
      });
      var convertedDatatoJson = json.decode(responseexp.body);
      if (debug == 'yes') {
        print(convertedDatatoJson);
      }
      if (convertedDatatoJson['status'] == true) {
        Future.delayed(const Duration(seconds: 2), () {
          if (_valuenew == null || _valuenew == '') {
            //go_for_lead(userid, clientname, 'Open', '0', '100');
          } else {
            // go_for_lead(userid, clientname, _valuenew, '0', '100');
          }
          Toast.show(convertedDatatoJson['message'], context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          Navigator.pop(context);
          Navigator.pop(context);
          setState(() {
            reminderremarksController.clear();
          });
        });
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          Toast.show(convertedDatatoJson['message'], context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          setState(() {
            reminderremarksController.clear();
          });
        });
      }
    } catch (error) {
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

  //leads add followup
  Future<void> leadsfollowup(BuildContext context, String id) async {
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
                  key: _formnewkey2,
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
                                _mycreditmodal = null;
                                reminderremarksController.clear();
                              });
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            'Add Followup',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 15,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: DateTime(2050, 6, 7, 05, 09),
                                onChanged: (date) {
                              if (debug == 'yes') {
                                print('change $date in time zone ' +
                                    date.timeZoneOffset.inHours.toString());
                              }
                            }, onConfirm: (date) {
                              // print('confirm $date');
                              setState(() {
                                pickeddate = DateFormat('yyyy-MM-dd kk:mm:ss')
                                    .format(date);
                              });
                              if (debug == 'yes') {
                                print(pickeddate);
                              }
                            }, locale: LocaleType.en);
                            // Call Function that has showDatePicker()
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.3,
                            height: MediaQuery.of(context).size.height / 20,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: Colors.blue,
                              ),
                              borderRadius: new BorderRadius.circular(5),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: IgnorePointer(
                                child: new TextFormField(
                                  cursorColor: Colors.blueAccent,
                                  decoration: new InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(0)),
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                      ),
                                      border: const OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(00)),
                                      ),
                                      //icon: Icon(Icons.calendar_today_sharp, color: Colors.blueAccent,),
                                      prefixIcon: Icon(Icons.calendar_today),
                                      hintText: '$pickeddate'),
                                  onSaved: (String val) {
                                    pickeddate;
                                    if (debug == 'yes') {
                                      print('my picked date- $pickeddate');
                                    }
                                  },
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Enter remarks',
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
                        height: MediaQuery.of(context).size.height / 6,
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
                            maxLines: 5,
                            autocorrect: true,
                            maxLength: 400,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Remarks',
                                hintStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize:
                                        MediaQuery.of(context).size.height / 50,
                                    fontWeight: FontWeight.w300)),
                            style: TextStyle(color: Colors.blue),
                            controller: reminderremarksController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please fill this field';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () async {
                            if (_formnewkey2.currentState.validate()) {
                              UpdateLeadLoader();
                              addreminder(id, pickeddate);
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
                ),
              );
            }),
          );
        });
  }

  var datalistupdt;

//send msg api
  Future msg(String lid) async {
    try {
      var urii = "$customurl/notify.php";
      final responseexp = await http.post(urii, body: {
        'uid': userid,
        'client': clientname,
        'type': 'sms',
        'lid': lid,
        'message': sendmsgcontroller.text
      }, headers: <String, String>{
        'Accept': 'application/json',
      });
      var convertedDatatoJson = json.decode(responseexp.body);
      if (debug == 'yes') {
        print(convertedDatatoJson);
      }
      if (convertedDatatoJson['status'] == true) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.pop(context);
          Toast.show(convertedDatatoJson['message'], context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          sendmsgcontroller.clear();
        });
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          Toast.show(convertedDatatoJson['message'], context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          setState(() {});
        });
      }
    } catch (error) {
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

  //send mail api
  Future SendMail(String userlid) async {
    try {
      var urii = "$customurl/notify.php";
      final responseexp = await http.post(urii, body: {
        'lid': userlid,
        'uid': userid,
        'client': clientname,
        'type': 'mail'
      }, headers: <String, String>{
        'Accept': 'application/json',
      });
      var convertedDatatoJson = json.decode(responseexp.body);
      if (debug == 'yes') {
        print(convertedDatatoJson);
      }
      if (convertedDatatoJson['status'] == true) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          Toast.show('Mail Sent Successfully', context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        });
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          Toast.show('Mail Sending Failed Please Retry Again', context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        });
      }
      //print(convertedDatatoJson['data'][0]['state']);
    } catch (error) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
        Toast.show(
            'Unable to complete your process this time, please try again',
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
        if (debug == 'yes') {
          print('error');
        }
      });
    }
  }

//lead status update api
  Future updtstatus(String lid) async {
    try {
      var urii = "$customurl/leads.php";
      final responseexp = await http.post(urii, body: {
        'uid': userid,
        'client': clientname,
        'type': 'lead_status_update',
        'lid': lid,
        'status': _mycreditmodal,
        'remarks': remarkscontroller.text
      }, headers: <String, String>{
        'Accept': 'application/json',
      });
      var convertedDatatoJson = json.decode(responseexp.body);
      if (debug == 'yes') {
        print(convertedDatatoJson);
      }
      if (convertedDatatoJson['status'] == true) {
        Future.delayed(const Duration(seconds: 2), () {
          Toast.show(convertedDatatoJson['message'], context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          Navigator.pop(context);
          Navigator.pop(context);
          setState(() {
            remarkscontroller.clear();
            _mycreditmodal = null;
          });
          if (_valuenew == null || _valuenew == '') {
            // go_for_lead(userid, clientname, 'Open', '0', '100');
          } else {
            // go_for_lead(userid, clientname, _valuenew, '0', '100');
          }
        });
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          Toast.show(convertedDatatoJson['message'], context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          setState(() {
            Navigator.pop(context);
            remarkscontroller.clear();
            _mycreditmodal = null;
          });
        });
      }
    } catch (error) {
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

  Future<void> leadsstatusupdate(BuildContext context, String id) async {
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
                  key: _formnewkey,
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
                                _mycreditmodal = null;
                                remarkscontroller.clear();
                              });
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            'Update Status',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 15,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        height: MediaQuery.of(context).size.height / 20,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.blue,
                          ),
                          borderRadius: new BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 15, right: 15, top: 0),
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                dropdownColor: Colors.white,
                                elevation: 0,
                                value: _mycreditmodal,
                                iconSize: 30,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                                hint: Text(
                                  'Select Leads Type',
                                  style: TextStyle(color: Colors.black),
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    _mycreditmodal = newValue;
                                    intrim_credit_val = _mycreditmodal;
                                    if (debug == 'yes') {
                                      print(_mycreditmodal);
                                    }
                                  });
                                },
                                items: expnewdata?.map((item) {
                                      return new DropdownMenuItem(
                                        child: new Text(
                                          item['status_label'],
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        value: item['status'].toString(),
                                      );
                                    })?.toList() ??
                                    [],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Enter remarks',
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
                        height: MediaQuery.of(context).size.height / 6,
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
                            maxLines: 5,
                            autocorrect: true,
                            maxLength: 400,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Remarks',
                                hintStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize:
                                        MediaQuery.of(context).size.height / 50,
                                    fontWeight: FontWeight.w300)),
                            style: TextStyle(color: Colors.blue),
                            controller: remarkscontroller,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please fill this field';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () async {
                            if (_formnewkey.currentState.validate()) {
                              if (_mycreditmodal == null ||
                                  _mycreditmodal == '') {
                                Toast.show("Please Select Leads Type", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.TOP);
                              } else if (_mycreditmodal != null ||
                                  _mycreditmodal != '') {
                                UpdateLeadLoader();
                                updtstatus(id);
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
                            child: Center(
                              child: Row(
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
                ),
              );
            }),
          );
        });
  }

  var mydata;
//lead details update api
// ignore: non_constant_identifier_names
  Future UpdateLeads(String mylid) async {
    try {
      String url = ('$customurl/leads.php');
      http.Response response = await http.post(url, body: {
        'type': 'lead_details_update',
        'uid': userid,
        'client': clientname,
        'name': nameController.text,
        'phone': phoneController.text,
        if (emailController.text == '' || emailController.text == null)
          'email': ''
        else
          'email': emailController.text,
        if (companyController.text == '' || companyController.text == null)
          'company': ''
        else
          'company': companyController.text,
        if (_mycreditproduct == '' || _mycreditproduct == null)
          'product': ''
        else
          'product': _mycreditproduct,
        if (addressController.text == '' || addressController.text == null)
          'address': ''
        else
          'address': addressController.text,
        if (cityController.text == '' || cityController.text == null)
          'city': ''
        else
          'city': cityController.text,
        if (_mycredit == '' || _mycredit == null)
          'state': ''
        else
          'state': _mycredit,
        if (_mycreditsource == '' || _mycreditsource == null)
          'source': ''
        else
          'source': _mycreditsource,
        'lid': mylid
      });
      var convertedDatas = jsonDecode(response.body);
      datalistupdt = convertedDatas['data'];
      if (debug == 'yes') {
        print(convertedDatas);
        print('mydatalist - $datalist');
      }
      if (convertedDatas['status'] == true) {
        Future.delayed(const Duration(seconds: 2), () {
          if (_valuenew == null || _valuenew == '') {
            //go_for_lead(userid, clientname, 'Open', '0', '100');
          } else {
            //go_for_lead(userid, clientname, _valuenew, '0', '100');
          }
          Navigator.pop(context);
          Navigator.pop(context);
          Toast.show(convertedDatas['message'], context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          setState(() {});
        });
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          Toast.show(convertedDatas['message'], context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        });
      }
    } catch (error) {
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

  Future<void> updateleadDialog(BuildContext context, String id) async {
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
                  key: _formnewkey3,
                  child: ListView(
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
                                _mycreditmodal = null;
                              });
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            'Update Details',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 15,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Name',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize:
                                    MediaQuery.of(context).size.width / 30,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Container(
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
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Name',
                                  hintStyle: TextStyle(
                                      color: Colors.blue,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      fontWeight: FontWeight.w300)),
                              style: TextStyle(color: Colors.blue),
                              controller: nameController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Name cannot be empty';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Phone',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize:
                                    MediaQuery.of(context).size.width / 30,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Container(
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
                                      color: Colors.blue,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      fontWeight: FontWeight.w300)),
                              style: TextStyle(color: Colors.blue),
                              controller: phoneController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Phone cannot be empty';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize:
                                    MediaQuery.of(context).size.width / 30,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Container(
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
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 0),
                            child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
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
                                controller: emailController,
                                validator: validateEmail),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Company',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize:
                                    MediaQuery.of(context).size.width / 30,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Container(
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
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 0),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Company',
                                  hintStyle: TextStyle(
                                      color: Colors.blue,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      fontWeight: FontWeight.w300)),
                              style: TextStyle(color: Colors.blue),
                              controller: companyController,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Product',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize:
                                    MediaQuery.of(context).size.width / 30,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Container(
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
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 0),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  elevation: 0,
                                  value: _mycreditproduct,
                                  iconSize: 30,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                  hint: Text(
                                    'Product',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onChanged: (String value) {
                                    setState(() {
                                      _mycreditproduct = null;
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
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'State',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize:
                                    MediaQuery.of(context).size.width / 30,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Container(
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
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 0),
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
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                  hint: Text(
                                    'State',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _mycredit = newValue;
                                      if (debug == 'yes') {
                                        print(_mycredit);
                                      }
                                      _mycredit = newValue;
                                      mydropdown = 'hide';
                                    });
                                  },
                                  items: expnewdatastate?.map((item) {
                                        return new DropdownMenuItem(
                                          child: new Text(
                                            item['state'],
                                            style:
                                                TextStyle(color: Colors.black),
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
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Source',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize:
                                    MediaQuery.of(context).size.width / 30,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Container(
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
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 0),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  elevation: 0,
                                  value: _mycreditsource,
                                  iconSize: 30,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                  hint: Text(
                                    'Source',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onChanged: (String newValuen) {
                                    setState(() {
                                      _mycreditsource = null;
                                      _mycreditsource = null;
                                      _mycreditsource = newValuen;
                                      _mycreditsource = newValuen;
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
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'City',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize:
                                    MediaQuery.of(context).size.width / 30,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Container(
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
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'City',
                                  hintStyle: TextStyle(
                                      color: Colors.blue,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      fontWeight: FontWeight.w300)),
                              style: TextStyle(color: Colors.blue),
                              controller: cityController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter city';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Address',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize:
                                    MediaQuery.of(context).size.width / 30,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Container(
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
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Address',
                                  hintStyle: TextStyle(
                                      color: Colors.blue,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      fontWeight: FontWeight.w300)),
                              style: TextStyle(color: Colors.blue),
                              controller: addressController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter address';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 50,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () async {
                            if (_formnewkey3.currentState.validate()) {
                              UpdateLeadLoader();
                              UpdateLeads(id);
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
                ),
              );
            }),
          );
        });
  }

  dynamic nameController = TextEditingController();
  dynamic phoneController = TextEditingController();
  dynamic emailController = TextEditingController();
  dynamic companyController = TextEditingController();
  String _mycreditproduct;
  List expnewdatalist;
  List expnewdataproduct;
  List expnewdatastate;
  List expnewdatastatelist;
  List expnewdatasourcelist;
  List expnewdatasource;
  String _mycreditsource;
  String _mycredit;
  dynamic cityController = TextEditingController();
  dynamic addressController = TextEditingController();

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

  //setting fetched value
  // ignore: non_constant_identifier_names
  void ControllersVal(
      String leadname,
      String leadphone,
      String leademail,
      String leadcomp,
      String leadproduct,
      String leadstate,
      String leadcity,
      String leadadd,
      String leadsource) {
    setState(() {
      _mycreditproduct = null;
      nameController.text = leadname;
      phoneController.text = leadphone;
      emailController.text = leademail;
      companyController.text = leadcomp;
      _mycreditproduct = null;

      if (debug == 'yes') {
        print(expnewdatalist);
        print(expnewdataproduct);
      }
      if (leadstate != '') {
        if (debug == 'yes') {
          print('clicked');
        }
        try {
          var estatestateSelected = expnewdatastate
              .firstWhere((dropdown) => dropdown['state'] == '$leadstate');
          if (debug == 'yes') {
            print(estatestateSelected);
          }
          expnewdatastatelist = [
            for (var i = 0; i < estatestateSelected.length; i++)
              {estatestateSelected['state']}
          ];
        } catch (error) {
          Toast.show(
              'Unable to complete your process this time, please try again',
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.CENTER);
          if (debug == 'yes') {
            print('dont get state');
          }
        }
      }

      if (leadproduct != '') {
        if (debug == 'yes') {
          print('clicked');
        }
        try {
          var estateSelected = expnewdataproduct.firstWhere(
              (dropdown) => dropdown['prod_name'] == '$leadproduct');
          if (debug == 'yes') {
            print(estateSelected);
          }
          expnewdatalist = [
            for (var i = 0; i < estateSelected.length; i++)
              {estateSelected['prod_name']}
          ];
        } catch (error) {
          Toast.show(
              'Unable to complete your process this time, please try again',
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.CENTER);
          if (debug == 'yes') {
            print('never reached');
          }
        }
      }

      if (leadsource != '') {
        if (debug == 'yes') {
          print('clicked');
        }
        try {
          var estateSelectedsource = expnewdatasource
              .firstWhere((dropdown) => dropdown['source'] == '$leadsource');
          if (debug == 'yes') {
            print(estateSelectedsource);
          }
          expnewdatasourcelist = [
            for (var i = 0; i < estateSelectedsource.length; i++)
              {estateSelectedsource['source']}
          ];
        } catch (error) {
          Toast.show(
              'Unable to complete your process this time, please try again',
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.CENTER);
          if (debug == 'yes') {
            print('never sourced');
          }
        }
      }
      if (expnewdatalist.toString() != '[{$leadproduct}]') {
        _mycreditproduct = null;
        if (debug == 'yes') {
          print('munull');
        }
      } else {
        _mycreditproduct = leadproduct;
      }
      if (expnewdatasourcelist.toString() != '[{$leadsource}]') {
        _mycreditsource = null;
        if (debug == 'yes') {
          print(expnewdatasourcelist);
          print('munullk');
        }
      } else {
        _mycreditsource = leadsource;
      }
      _mycredit = null;
      if (expnewdatastatelist.toString() != '[{$leadstate}]' ||
          leadstate == null ||
          leadstate == '') {
        _mycredit = null;
        if (debug == 'yes') {
          print(expnewdatastatelist);
          print('munullk');
        }
      } else {
        _mycredit = leadstate;
      }
      /* if(leadstate == null || leadstate == ''){
      _mycredit = null;
    }else{
     _mycredit = leadstate;}*/
      addressController.text = leadadd;
      cityController.text = leadcity;
    });
  }

  //phone call url
  _makingPhoneCall(String number) async {
    // const number = '08592119XXXX'; //set the number here
    bool res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  //send whatsapp
  Future Sendwhatsapp(String userphn) async {
    print(userphn);
    try {
      var urii = "$customurl/notify.php";
      final responseexp = await http.post(urii, body: {
        'phone': userphn,
        'uid': userid,
        'client': clientname,
        'type': 'wapp_msg'
      }, headers: <String, String>{
        'Accept': 'application/json',
      });
      var convertedDatatoJson = json.decode(responseexp.body);
      if (debug == 'yes') {
        print(convertedDatatoJson);
      }
      if (convertedDatatoJson['status'] == true) {
        await launch(
            "https://wa.me/+91$userphn?text=${convertedDatatoJson['message']['message']}");
        if (debug == 'yes') {
          print(convertedDatatoJson['message']['message']);
        }
      } else {
        Toast.show('Please Try Again', context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Colors.black);
      }
      setState(() {});
    } catch (error) {
      Toast.show('Unable to complete your process this time, please try again',
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.black);
      if (debug == 'yes') {
        print('timeout');
      }
      return false;
    }
  }

  final _formnewkey1 = GlobalKey<FormState>();
  final _formnewkey = GlobalKey<FormState>();
  final _formnewkey2 = GlobalKey<FormState>();
  final _formnewkey3 = GlobalKey<FormState>();
  dynamic sendmsgcontroller = TextEditingController();
  dynamic remarkscontroller = TextEditingController();
  dynamic reminderremarksController = TextEditingController();
  var fpassemailapistatus = 'got it';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future sendmsg(BuildContext context, String id, String number) {
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
                                sendmsgcontroller.clear();
                                fpassemailapistatus = 'got it';
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 30,
                      ),
                      Image.asset(
                        'assets/images/SMS.png',
                        height: 200,
                        width: 200,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            'Send Message',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 15,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            '($number)',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 25,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Enter the message you want to send',
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
                        height: MediaQuery.of(context).size.height / 6,
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
                            maxLines: 5,
                            autocorrect: true,
                            maxLength: 400,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Message',
                                hintStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize:
                                        MediaQuery.of(context).size.height / 50,
                                    fontWeight: FontWeight.w300)),
                            style: TextStyle(color: Colors.blue),
                            controller: sendmsgcontroller,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please fill this field';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () async {
                            if (_formnewkey1.currentState.validate()) {
                              showMsg();
                              msg(id);
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
                                    'Send',
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

  final _formkeysearch = GlobalKey<FormState>();
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
            'Search Query',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 20,
                fontWeight: FontWeight.w300),
          ),
          centerTitle: false,
        ),
        drawer: Drawer(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                              fit: BoxFit.fill),
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            comapnyname,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 20),
                          ),
                          Text(
                            username,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize:
                                    MediaQuery.of(context).size.width / 30),
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Divider(
                  color: Colors.blue,
                  thickness: 1,
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView(children: [
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.width / 20,
                    ),
                    title: Text(
                      "Home",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width / 25,
                          fontWeight: FontWeight.w300),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return Dashboard();
                      }));
                    },
                    // selected: true,
                    selectedTileColor: Colors.blue.withOpacity(0.5),
                    minVerticalPadding: 0,
                    enableFeedback: true,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.width / 20,
                    ),
                    title: Text(
                      "Search Query",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width / 25,
                          fontWeight: FontWeight.w300),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    // selected: true,
                    selectedTileColor: Colors.blue.withOpacity(0.5),
                    minVerticalPadding: 0,
                    enableFeedback: true,
                    selected: true,
                  ),
                  ExpansionTile(
                    initiallyExpanded: false,
                    maintainState: true,
                    leading: Icon(
                      Icons.people,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.width / 20,
                    ),
                    title: Text(
                      "Leads",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width / 25,
                          fontWeight: FontWeight.w300),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: ListTile(
                          leading: Icon(
                            Icons.people,
                            color: Colors.black,
                            size: MediaQuery.of(context).size.width / 20,
                          ),
                          title: Text(
                            "Assigned Leads",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width / 25,
                                fontWeight: FontWeight.w300),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return Leads();
                            }));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: ListTile(
                          leading: Icon(
                            Icons.people,
                            color: Colors.black,
                            size: MediaQuery.of(context).size.width / 20,
                          ),
                          title: Text(
                            "Follow Ups",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width / 25,
                                fontWeight: FontWeight.w300),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return FollowUp();
                            }));
                          },
                        ),
                      ),
                    ],
                  ),
                  /* ListTile(
                    leading: Icon(Icons.person, color: Colors.black,size:MediaQuery.of(context).size.width/20,),
                    title: Text("Contacts",
                      style: TextStyle(color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width/25,
                          fontWeight: FontWeight.w300),),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                            return Contacts();
                          }));
                    },
                  ),*/
                  ListTile(
                    leading: Icon(
                      Icons.contact_support,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.width / 20,
                    ),
                    title: Text(
                      "Contact Us",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width / 25,
                          fontWeight: FontWeight.w300),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return Contactus();
                      }));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.admin_panel_settings_sharp,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.width / 20,
                    ),
                    title: Text(
                      "Change Password",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width / 25,
                          fontWeight: FontWeight.w300),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return ChangePass();
                      }));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  /* ListTile(
                    leading: Icon(Icons.settings, color: Colors.black,size:MediaQuery.of(context).size.width/20,),
                    title: Text("Settings",
                      style: TextStyle(color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width/25,
                          fontWeight: FontWeight.w300),),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),*/
                  ListTile(
                    leading: Icon(
                      Icons.messenger,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.width / 20,
                    ),
                    title: Text(
                      "Feedback",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width / 25,
                          fontWeight: FontWeight.w300),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return Feedbacks();
                      }));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.width / 20,
                    ),
                    title: Text(
                      "Log Out",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width / 25,
                          fontWeight: FontWeight.w300),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Logout(context);
                    },
                  ),
                ]),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Made with love',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.width / 30,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'In India',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.width / 30,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        endDrawerEnableOpenDragGesture: true,
        key: _scaffoldKey,
        body: GestureDetector(
          onVerticalDragEnd: (DragEndDetails details) {
            _scaffoldKey.currentState.openDrawer();
          },
          child: Container(
            child: Form(
              key: _formkeysearch,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 20,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: new BorderRadius.circular(0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          height: MediaQuery.of(context).size.height / 20,
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search Lead',
                                  hintStyle: TextStyle(
                                      color: Colors.blue,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      fontWeight: FontWeight.w300)),
                              style: TextStyle(color: Colors.blue),
                              controller: searchcontroller,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter the detail';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_formkeysearch.currentState.validate()) {
                              go_for_lead_search(
                                  userid, clientname, searchcontroller.text);
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height / 25,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: new BorderRadius.circular(5),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 0),
                                child: Text(
                                  'Search',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey.withOpacity(0.2),
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height / 7.23,
                    child: myleaddatalist.isNotEmpty
                        ? ListView.builder(
                            itemCount: myleaddatalist.isEmpty
                                ? 0
                                : myleaddatalist.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  //height: 100,
                                  //color: Colors.transparent,
                                  // margin: const EdgeInsets.all(15.0),
                                  // padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueAccent)),
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      color: Colors.transparent,
                                      elevation: 0,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Sno. : ${index + 1}',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .blueAccent)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            'Status : ${myleaddatalist[index]['status']}',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 5, 8, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Name:',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  myleaddatalist[index]
                                                      ['full_name'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 5, 8, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Email:',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  myleaddatalist[index]
                                                      ['email'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 5, 8, 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Phone:',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  myleaddatalist[index]
                                                      ['phone'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                50, 0, 50, 0),
                                            child: Divider(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      new FloatingActionButton(
                                                    heroTag: null,
                                                    child: Icon(
                                                      Icons.phone,
                                                      size: 20,
                                                    ),
                                                    onPressed: () {
                                                      _makingPhoneCall(
                                                          myleaddatalist[index]
                                                              ['phone']);
                                                    },
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.blue,
                                                  ),
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      new FloatingActionButton(
                                                    heroTag: null,
                                                    child: Image.asset(
                                                      'assets/images/whats.png',
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () async {
                                                      //  LoaderFull(context);
                                                      Sendwhatsapp(
                                                          myleaddatalist[index]
                                                              ['phone']);
                                                    },
                                                    /* => await launch(
                                                                 "https://wa.me/${datalist[index]['phone']}?text=Hello"),*/
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      new FloatingActionButton(
                                                    heroTag: null,
                                                    child: Icon(
                                                      Icons.message,
                                                      size: 20,
                                                    ),
                                                    onPressed: () {
                                                      sendmsg(
                                                          context,
                                                          myleaddatalist[index]
                                                              ['lid'],
                                                          myleaddatalist[index]
                                                              ['phone']);
                                                    },
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.amber,
                                                  ),
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      new FloatingActionButton(
                                                    heroTag: null,
                                                    child: Icon(
                                                      Icons.email,
                                                      size: 20,
                                                    ),
                                                    onPressed: () {
                                                      showMail();
                                                      SendMail(
                                                          myleaddatalist[index]
                                                              ['lid']);
                                                    },
                                                    elevation: 0,
                                                    backgroundColor: Colors.red,
                                                  ),
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      new FloatingActionButton(
                                                    heroTag: null,
                                                    child: Icon(
                                                      Icons.update,
                                                      size: 20,
                                                    ),
                                                    onPressed: () async {
                                                      await leadsstatusupdate(
                                                          context,
                                                          myleaddatalist[index]
                                                              ['lid']);
                                                      /*Navigator.of(context).pushReplacement(
                                                               MaterialPageRoute(
                                                                 builder: (_) => Stupdt(
                                                                     lid: datalist[index]['lid'],
                                                                     Name: datalist[index]['full_name']
                                                                 ),
                                                               ),
                                                             );*/
                                                    },
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      new FloatingActionButton(
                                                    heroTag: null,
                                                    child: Icon(
                                                      Icons.info,
                                                      size: 20,
                                                    ),
                                                    onPressed: () {
                                                      ShowInfo(
                                                          myleaddatalist[index]
                                                              ['lid'],
                                                          myleaddatalist[index]
                                                              ['full_name'],
                                                          myleaddatalist[index]
                                                              ['company'],
                                                          myleaddatalist[index]
                                                              ['phone'],
                                                          myleaddatalist[index]
                                                              ['email'],
                                                          myleaddatalist[index]
                                                              ['source'],
                                                          myleaddatalist[index]
                                                              ['product'],
                                                          myleaddatalist[index]
                                                              ['city'],
                                                          myleaddatalist[index]
                                                              ['state'],
                                                          myleaddatalist[index]
                                                              ['remarks'],
                                                          myleaddatalist[index]
                                                              ['sms_sent'],
                                                          myleaddatalist[index][
                                                              'last_sent_time'],
                                                          myleaddatalist[index]
                                                              ['email_sent'],
                                                          myleaddatalist[index][
                                                              'last_email_sent'],
                                                          myleaddatalist[index]
                                                              ['whatsapp_sent'],
                                                          myleaddatalist[index][
                                                              'last_whatsapp_sent'],
                                                          myleaddatalist[index]
                                                              ['recieved_on'],
                                                          myleaddatalist[index]
                                                              ['lct']);
                                                    },
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.indigo,
                                                  ),
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      new FloatingActionButton(
                                                    heroTag: null,
                                                    child: Icon(
                                                      Icons
                                                          .calendar_today_sharp,
                                                      size: 18,
                                                    ),
                                                    onPressed: () async {
                                                      await leadsfollowup(
                                                          context,
                                                          myleaddatalist[index]
                                                              ['lid']);
                                                    },
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.blueAccent,
                                                  ),
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      new FloatingActionButton(
                                                    heroTag: null,
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                    ),
                                                    onPressed: () async {
                                                      ControllersVal(
                                                        myleaddatalist[index]
                                                            ['full_name'],
                                                        myleaddatalist[index]
                                                            ['phone'],
                                                        myleaddatalist[index]
                                                            ['email'],
                                                        myleaddatalist[index]
                                                            ['company'],
                                                        myleaddatalist[index]
                                                            ['product'],
                                                        myleaddatalist[index]
                                                            ['state'],
                                                        myleaddatalist[index]
                                                            ['city'],
                                                        myleaddatalist[index]
                                                            ['address'],
                                                        myleaddatalist[index]
                                                            ['source'],
                                                      );
                                                      await updateleadDialog(
                                                          context,
                                                          myleaddatalist[index]
                                                              ['lid']);
                                                    },
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.indigoAccent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Icon(
                                Icons.featured_play_list_outlined,
                                size: MediaQuery.of(context).size.width / 3,
                                color: Colors.grey.withOpacity(0.4),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'No any leads available',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25),
                                ),
                              ),
                            ],
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
