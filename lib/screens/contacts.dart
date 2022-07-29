import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoho_crm_clone/screens/Leads.dart';
import 'package:zoho_crm_clone/screens/add_contacts.dart';

import 'contact_us.dart';
import 'dashboard.dart';

class Contacts extends StatefulWidget {
  Contacts({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  double _sigmaX = 0.0; // from 0-10
  double _sigmaY = 0.0; // from 0-10
  double _opacity = 0.1;
  bool dark = true;
  String _valuenew = 'start';
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
            'Contacts',
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
                            'Sandeep Kumar',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 20),
                          ),
                          Text(
                            'sandeepkumarishan@gmail.com',
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
                  ),
                  ExpansionTile(
                    //initiallyExpanded: true,
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
                          //selected: true,
                          selectedTileColor: Colors.blue.withOpacity(0.5),
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
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.width / 20,
                    ),
                    title: Text(
                      "Contacts",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width / 25,
                          fontWeight: FontWeight.w300),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    selected: true,
                    selectedTileColor: Colors.blue.withOpacity(0.5),
                  ),
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
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.width / 20,
                    ),
                    title: Text(
                      "Settings",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width / 25,
                          fontWeight: FontWeight.w300),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
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
        body: Container(
          child: Container(
            color: Colors.grey.withOpacity(0.2),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.contact_phone_outlined,
                  size: MediaQuery.of(context).size.width / 3,
                  color: Colors.grey.withOpacity(0.4),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No any contacts available',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width / 25),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Refresh',
                        style: TextStyle(fontSize: 15),
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
                return AddContacts();
              }));
            },
          ),
        ),
      ),
    );
  }
}
