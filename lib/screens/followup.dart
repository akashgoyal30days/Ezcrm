import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoho_crm_clone/api_models/fetch_followups.dart';
import 'package:zoho_crm_clone/constants/constants.dart';
import 'package:zoho_crm_clone/model/logout_model.dart';
import 'package:zoho_crm_clone/screens/add_followup.dart';
import 'package:zoho_crm_clone/screens/change%20pass.dart';
import 'package:zoho_crm_clone/screens/contact_us.dart';
import 'package:zoho_crm_clone/screens/dashboard.dart';
import 'package:zoho_crm_clone/screens/feedback.dart';
import 'package:zoho_crm_clone/screens/search_query.dart';
import 'feedback.dart';
import 'Leads.dart';
import 'package:intl/intl.dart';

class FollowUp extends StatefulWidget {
  FollowUp({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FollowUpState createState() => _FollowUpState();
}

class _FollowUpState extends State<FollowUp> {
  double _sigmaX = 0.0; // from 0-10
  double _sigmaY = 0.0; // from 0-10
  double _opacity = 0.1;
  Future show() {
    setState(() {
      isopen = true;
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

  bool dark = true;
  var currdt = DateTime.now();
  final _currentDate = DateTime.now();
  final _dayFormatter = DateFormat('d');
  final _monthFormatter = DateFormat('MM');
  final _yearFormatter = DateFormat('yyyy');
  String username = '';
  String userid = '';
  String usertype = '';
  String clientname = '';
  String comapnyname = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
    print(usertype);
    hitfollowup(userid, clientname,
        '${currdt.year}-${_monthFormatter.format(currdt)}-${currdt.day}');
  }

  var followdata;
  var list_follow = [];
  var isopen = false;
  Future hitfollowup(String uid, String client, String date) async {
    followdata = await fetchfollow(uid, client, date);
    if (debug == 'yes') {
      print(followdata);
    }
    if (followdata.containsKey('status')) {
      if (followdata['status'] == true) {
        if (isopen == true) {
          Navigator.pop(context);
        }
        setState(() {
          list_follow = followdata['followps'];
        });
        if (debug == 'yes') {
          print(list_follow);
        }
      } else {
        if (isopen == true) {
          Navigator.pop(context);
        }
      }
    }
  }

  _makingPhoneCall(String number) async {
    // const number = '08592119XXXX'; //set the number here
    bool res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  void initState() {
    super.initState();
    Retrivedetails();
  }

  var outputFormat = DateFormat('dd/MM/yyyy hh:mm a');
  var outputFormatdiff = DateFormat('dd/MM/yyyy hh:mm a');
  var diffstart;
  var which_date = 'today';
  var sday = '';
  var smonth = '';
  var syear = '';
  @override
  Widget build(BuildContext context) {
    final dates = <Widget>[];

    for (int i = 1; i < 6; i++) {
      final date = _currentDate.add(Duration(days: i));
      dates.add(ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: [
          GestureDetector(
            onTap: () {
              print(_dayFormatter.format(date));
              print(_monthFormatter.format(date));
              print(_yearFormatter.format(date));
              setState(() {
                which_date = 'selected';
                sday = _dayFormatter.format(date).toString();
                smonth = _monthFormatter.format(date).toString();
                syear = _yearFormatter.format(date).toString();
              });
              show();
              hitfollowup(userid, clientname,
                  '${_yearFormatter.format(date)}-${_monthFormatter.format(date)}-${_dayFormatter.format(date)}');
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      '${_dayFormatter.format(date)}',
                      style: TextStyle(color: Colors.white),
                    )),
                  )),
            ),
          ),
        ],
      ));
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
                  Colors.blue,
                  Colors.indigo,
                ],
              ),
            ),
          ),
          title: Text('Follow Up'),
          centerTitle: false,
          actions: [
            // IconButton(icon: Icon(Icons.search), onPressed: (){})
          ],
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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return S_Query();
                      }));
                    },
                    // selected: true,
                    selectedTileColor: Colors.blue.withOpacity(0.5),
                    minVerticalPadding: 0,
                    enableFeedback: true,
                  ),
                  ExpansionTile(
                    initiallyExpanded: true,
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
                          selected: true,
                          selectedTileColor: Colors.blue.withOpacity(0.5),
                          title: Text(
                            "Follow Ups",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width / 25,
                                fontWeight: FontWeight.w300),
                          ),
                          onTap: () {},
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
            color: Colors.grey.withOpacity(0.2),
            child: Column(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.indigo,
                        Colors.black,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Spacer(),
                      if (which_date == 'today')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Follow ups for ${currdt.day} ',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                            if (currdt.month == 1)
                              Text(
                                'Jan',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (currdt.month == 2)
                              Text(
                                'Feb',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (currdt.month == 3)
                              Text(
                                'March',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (currdt.month == 4)
                              Text(
                                'April',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (currdt.month == 5)
                              Text(
                                'May',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (currdt.month == 6)
                              Text(
                                'June',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (currdt.month == 7)
                              Text(
                                'July',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (currdt.month == 8)
                              Text(
                                'Aug',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (currdt.month == 9)
                              Text(
                                'Sep',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (currdt.month == 10)
                              Text(
                                'Oct',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (currdt.month == 11)
                              Text(
                                'Nov',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (currdt.month == 12)
                              Text(
                                'Dec',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${currdt.year}',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      if (which_date == 'selected')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Follow ups for $sday ',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                            if (smonth == '01')
                              Text(
                                'Jan',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (smonth == '02')
                              Text(
                                'Feb',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (smonth == '03')
                              Text(
                                'March',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (smonth == '04')
                              Text(
                                'April',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (smonth == '05')
                              Text(
                                'May',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (smonth == '06')
                              Text(
                                'June',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (smonth == '07')
                              Text(
                                'July',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (smonth == '08')
                              Text(
                                'Aug',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (smonth == '09')
                              Text(
                                'Sep',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (smonth == '10')
                              Text(
                                'Oct',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (smonth == '11')
                              Text(
                                'Nov',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            if (smonth == '12')
                              Text(
                                'Dec',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '$syear',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: Column(
                          children: [
                            Container(
                                height: 15,
                                //width: MediaQuery.of(context).size.width/2.5,
                                child: Text(
                                  'Search for next 5 days',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 30,
                                // width: MediaQuery.of(context).size.width/2,
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  children:
                                      dates.map((widget) => widget).toList(),
                                )),
                          ],
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).size.height / 3,
                  color: Colors.transparent,
                  child: list_follow.isNotEmpty
                      ? ListView.builder(
                          itemCount:
                              list_follow.isEmpty ? 0 : list_follow.length,
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
                                        padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 5,
                                            bottom: 2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Name:',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              list_follow[index]['full_name'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 5,
                                            bottom: 2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Email:',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              list_follow[index]['email'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 5,
                                            bottom: 2),
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
                                              list_follow[index]
                                                  ['followup_remark'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
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
                                              'Followup Date:',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              '${outputFormat.format(DateTime.parse(list_follow[index]['followup_date']))}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                      : Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Spacer(),
                            Icon(
                              Icons.web,
                              size: MediaQuery.of(context).size.width / 3,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'You have no activities for this day',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 30),
                              ),
                            ),
                            /*Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              child: Text('Refresh', style: TextStyle(fontSize: MediaQuery.of(context).size.width/30),),
                              onPressed: (){
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                      return AddFollow();
                                    }));
                              },
                            ),
                          ),*/
                            Spacer(),
                          ],
                        )),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue,
                  Colors.indigo,
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return AddFollow();
              }));
            },
          ),
        ),
      ),
    );
  }
}
