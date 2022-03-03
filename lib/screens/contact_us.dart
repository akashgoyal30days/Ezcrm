import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoho_crm_clone/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:zoho_crm_clone/model/logout_model.dart';
import 'package:zoho_crm_clone/screens/Leads.dart';
import 'package:zoho_crm_clone/screens/add_contacts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoho_crm_clone/screens/search_query.dart';
import 'add_leads.dart';
import 'change pass.dart';
import 'dashboard.dart';
import 'feedback.dart';
import 'followup.dart';


class Contactus extends StatefulWidget {
  Contactus({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ContactusState createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  var currDt = DateTime.now();
  double _sigmaX = 0.0; // from 0-10
  double _sigmaY = 0.0; // from 0-10
  double _opacity = 0.1;
  bool dark = true;
  String version = '';
  String _valuenew = 'start';
  DateTime _chosenDateTime;
  var currdt = DateTime.now();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  package() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });

  }
  Future Logout(BuildContext context){
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
                height: MediaQuery.of(context).size.height/5,
                child: Column(
                  children: [
                    Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: Text('Are you sure you want to Log Out?',
                        style: TextStyle(color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width/20),),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width/10,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,0,8,0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Spacer(),
                          GestureDetector(
                            onTap: (){
                              logOut(context);
                            },
                            child: Row(
                              children: [

                                Container(
                                    width: MediaQuery.of(context).size.width/3,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white)
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Yes',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width/10,),
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width/3,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white)
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('No',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
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
    SharedPreferences preferenceusertype = await SharedPreferences.getInstance();
    SharedPreferences preferenceclient = await SharedPreferences.getInstance();
    SharedPreferences preferencecompany = await SharedPreferences.getInstance();
    setState(() {
      username = preferencename.getString('name');
      userid = preferenceuid.getString('user_id');
      usertype = preferenceusertype.getString('user_type');
      clientname = preferenceclient.getString('client_name');
      comapnyname = preferencecompany.getString('company');
    });
    if(debug=='yes') {
      print(usertype);
    }
     }
  @override
  void initState(){
    package();
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
  _launchURL(lurl) async {
    var url = lurl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  String username = '';
  String userid = '';
  String usertype = '';
  String clientname = '';
  String comapnyname = '';
  String mydropdownstate = 'hide';
  String mydropdown;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
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
                colors: [Colors.black,Colors.indigo,],
              ),
            ),
          ),
          title: Text('Contact Us',
            style: TextStyle(fontSize: MediaQuery.of(context).size.width/20,
                fontWeight: FontWeight.w300),),
          centerTitle: false,

        ),
        key: _scaffoldKey,
        endDrawerEnableOpenDragGesture: true,
        drawer: Drawer(
          elevation: 0,
          child: Column(
            children: [
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width*0.2,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage('https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                              fit: BoxFit.fill
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(comapnyname,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width/20
                            ),),
                          Text(username,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: MediaQuery.of(context).size.width/30
                            ),),
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
                    leading: Icon(Icons.home, color: Colors.black,size:MediaQuery.of(context).size.width/20,),
                    title: Text("Home",
                      style: TextStyle(color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width/25,
                          fontWeight: FontWeight.w300),),
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
                    leading: Icon(Icons.search, color: Colors.black,size:MediaQuery.of(context).size.width/20,),
                    title: Text("Search Query",
                      style: TextStyle(color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width/25,
                          fontWeight: FontWeight.w300),),
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
                    //initiallyExpanded: true,
                    maintainState: true,
                    leading: Icon(Icons.people, color: Colors.black,size:MediaQuery.of(context).size.width/20,),
                    title: Text("Leads",
                      style: TextStyle(color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width/25,
                          fontWeight: FontWeight.w300),),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: ListTile(
                          leading: Icon(Icons.people, color: Colors.black,size:MediaQuery.of(context).size.width/20,),
                          //selected: true,
                          selectedTileColor: Colors.blue.withOpacity(0.5),
                          title: Text("Assigned Leads",
                            style: TextStyle(color: Colors.black,
                                fontSize: MediaQuery.of(context).size.width/25,
                                fontWeight: FontWeight.w300),),
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
                          leading: Icon(Icons.people, color: Colors.black,size:MediaQuery.of(context).size.width/20,),
                          title: Text("Follow Ups",
                            style: TextStyle(color: Colors.black,
                                fontSize: MediaQuery.of(context).size.width/25,
                                fontWeight: FontWeight.w300),),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                                  return FollowUp();
                                }));
                          },
                        ),
                      ),],
                  ),
                  /*ListTile(
                    leading: Icon(Icons.person, color: Colors.black,size:MediaQuery.of(context).size.width/20,),
                    title: Text("Contacts",
                      style: TextStyle(color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width/25,
                          fontWeight: FontWeight.w300),),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),*/
                  ListTile(
                    leading: Icon(Icons.contact_support, color: Colors.black,size:MediaQuery.of(context).size.width/20,),
                    title: Text("Contact Us",
                      style: TextStyle(color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width/25,
                          fontWeight: FontWeight.w300),),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    selected: true,
                    selectedTileColor: Colors.blue.withOpacity(0.5),
                  ),
                  ListTile(
                    leading: Icon(Icons.admin_panel_settings_sharp, color: Colors.black,size:MediaQuery.of(context).size.width/20,),
                    title: Text("Change Password",
                      style: TextStyle(color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width/25,
                          fontWeight: FontWeight.w300),),
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
                    leading: Icon(Icons.messenger, color: Colors.black,size:MediaQuery.of(context).size.width/20,),
                    title: Text("Feedback",
                      style: TextStyle(color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width/25,
                          fontWeight: FontWeight.w300),),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                            return Feedbacks();
                          }));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.black,size:MediaQuery.of(context).size.width/20,),
                    title: Text("Log Out",
                      style: TextStyle(color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width/25,
                          fontWeight: FontWeight.w300),),
                    onTap: () {
                      Navigator.of(context).pop();
                      Logout(context);
                    },
                  ),

                ]),
              ),
              Align(
                alignment: Alignment.center,
                child: Text('Made with love',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.width/30,
                  ),),
              ),

              Align(
                alignment: Alignment.center,
                child: Text('In India',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.width/30,
                  ),),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
        body: GestureDetector(
          onVerticalDragEnd : (DragEndDetails details) {
            _scaffoldKey.currentState.openDrawer();
          },
          child: Container(
            child: Container(
              color: Colors.grey.withOpacity(0.2),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/ezcrm.png')),
                  SizedBox(height: 5,),
                  Align(
                      alignment: Alignment.center,
                      child: Text('Convert leads into deals', style: TextStyle(fontSize: MediaQuery.of(context).size.width/25,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),)),
                  SizedBox(height: MediaQuery.of(context).size.width/10,),
                  Align(
                      alignment: Alignment.center,
                      child: Text('© ${currDt.year.toString()} EZCRM', style: TextStyle(fontSize: MediaQuery.of(context).size.width/25,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),)),

                  SizedBox(height: MediaQuery.of(context).size.width/8,),

                  Align(
                      alignment: Alignment.center,
                      child: Text("Let's get connected", style: TextStyle(fontSize: MediaQuery.of(context).size.width/23,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),)),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (await canLaunch("https://www.youtube.com/channel/UCc44SkW1Su1FbzWOIDSQ_mw")) {
                            await launch("https://www.youtube.com/channel/UCc44SkW1Su1FbzWOIDSQ_mw");
                          }
                        },
                        child: Align(
                            alignment: Alignment.center,
                            child: Image.asset('assets/images/youtube.png',
                              width: MediaQuery.of(context).size.width/15,)),
                      ),
                      SizedBox(width: 5,),
                      GestureDetector(
                        onTap: () async {
                          if (await canLaunch("https://www.facebook.com/EZCRM-109513837510284")) {
                            await launch("https://www.facebook.com/EZCRM-109513837510284");
                          }
                        },
                        child: Align(
                            alignment: Alignment.center,
                            child: Image.asset('assets/images/facebook.png',
                              width: MediaQuery.of(context).size.width/15,)),
                      ),
                      /* SizedBox(width: 5,),
                 GestureDetector(
                   child: Align(
                       alignment: Alignment.center,
                       child: Image.asset('assets/insta.png',
                         width: MediaQuery.of(context).size.width/18,)),
                 ),*/
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () async {
                          if (await canLaunch("https://www.linkedin.com/company/53215816/admin/")) {
                            await launch("https://www.linkedin.com/company/53215816/admin/");
                          }
                        },
                        child: Align(
                            alignment: Alignment.center,
                            child: Image.asset('assets/images/linked.png',
                              width: MediaQuery.of(context).size.width/18,)),
                      ),
                      SizedBox(width: 15,),
                      GestureDetector(
                        onTap: () async {
                          if (await canLaunch("https://twitter.com/EZCRM1")) {
                            await launch("https://twitter.com/EZCRM1");
                          }
                        },
                        child: Align(
                            alignment: Alignment.center,
                            child: Image.asset('assets/images/twitter.png',
                              width: MediaQuery.of(context).size.width/15,)),
                      ),
                    ],
                  ),

                  SizedBox(height: MediaQuery.of(context).size.width/8,),

                  Align(
                      alignment: Alignment.center,
                      child: Text('Spread the word', style: TextStyle(fontSize: MediaQuery.of(context).size.width/23,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),)),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                        //  _launchURL('https://wa.me/?text=Hi%2C\n\n+I+am+using+EZCRM+for+managing+all+the+leads+of+my+company.+Would+like+to+recommend+taking+a+free+trial+for+your+company+too.+\n\nwww.ezcrm.in&rlz=1C1CHBF_enIN919IN919&oq=Hi%2C+I+am+using+EZCRM+for+managing+all+the+leads+of+my+company.+Would+like+to+recommend+taking+a+free+trial+for+your+company+too.+www.ezcrm.in');
                          launch(
                              "https://wa.me/?text=Hi%2C\n\n+I+am+using+EZCRM+for+managing+all+the+leads+of+my+company.+Would+like+to+recommend+taking+a+free+trial+for+your+company+too.+\n\nwww.ezcrm.in&rlz=1C1CHBF_enIN919IN919&oq=Hi%2C+I+am+using+EZCRM+for+managing+all+the+leads+of+my+company.+Would+like+to+recommend+taking+a+free+trial+for+your+company+too.+www.ezcrm.in");
                        },
                        child: Align(
                            alignment: Alignment.center,
                            child: Image.asset('assets/images/whatsapp.png',
                              width: MediaQuery.of(context).size.width/15,)),
                      ),
                    ],
                  ),
                  SizedBox(height: 50,),
                  Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/30days.png', width: MediaQuery.of(context).size.width/4,)),
                  SizedBox(height: 5,),
                  Align(
                      alignment: Alignment.center,
                      child: Text('A step to innovation.', style: TextStyle(fontSize: MediaQuery.of(context).size.width/25,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),)),
                  Spacer(),
                  Align(
                      alignment: Alignment.center,
                      child: Text('version ${version}', style: TextStyle(fontSize: MediaQuery.of(context).size.width/25,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),)),
                  SizedBox(height: 5,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}