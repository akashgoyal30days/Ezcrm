import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoho_crm_clone/constants/constants.dart';
import 'package:flutter/cupertino.dart';

import 'dashboard.dart';


class AddContacts extends StatefulWidget {
  AddContacts({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddContactsState createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
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
            title: Text('Add Contact',
              style: TextStyle(fontSize: MediaQuery.of(context).size.width/20,
                  fontWeight: FontWeight.w300),),
            centerTitle: false,
            leading: IconButton(icon: Icon(Icons.west_sharp), onPressed: (){
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                    return Dashboard();
                  }));
            }),
            actions: [
              IconButton(icon: Icon(Icons.check), onPressed: (){})
            ],
          ),

          body: Container(
            color: Colors.grey.withOpacity(0.2),
            child: ListView(
              children: [
                Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height/17.2,
                        width: MediaQuery.of(context).size.width/2.5,
                        color: Colors.grey.withOpacity(0.5),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text('Name',
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/22),),
                                    Text('*',
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/22,
                                      color: Colors.red),),
                                    Text(' : ',
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/22),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width- MediaQuery.of(context).size.width/2.5,
                        height: MediaQuery.of(context).size.height/17.2,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border:Border.all(
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
                                    color:Colors.black,
                                    fontSize: MediaQuery.of(context).size.height/50,
                                    fontWeight: FontWeight.w300
                                )
                            ),
                            style: TextStyle(color:Colors.black),),
                        ),),
                    ],
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height/17.2,
                        width: MediaQuery.of(context).size.width/2.5,
                        color: Colors.grey.withOpacity(0.5),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text('Email',
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/22),),
                                    Text('*',
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/22,
                                          color: Colors.red),),
                                    Text(' : ',
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/22),),
                                  ],
                                ),],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width- MediaQuery.of(context).size.width/2.5,
                        height: MediaQuery.of(context).size.height/17.2,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border:Border.all(
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
                                    color:Colors.black,
                                    fontSize: MediaQuery.of(context).size.height/50,
                                    fontWeight: FontWeight.w300
                                )
                            ),
                            style: TextStyle(color:Colors.black),),
                        ),),
                    ],
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height/17.2,
                        width: MediaQuery.of(context).size.width/2.5,
                        color: Colors.grey.withOpacity(0.5),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text('Phone',
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/22),),
                                    Text('*',
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/22,
                                          color: Colors.red),),
                                    Text(' : ',
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/22),),
                                  ],
                                ),],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width- MediaQuery.of(context).size.width/2.5,
                        height: MediaQuery.of(context).size.height/17.2,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border:Border.all(
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
                                hintText: 'Phone',
                                hintStyle: TextStyle(
                                    color:Colors.black,
                                    fontSize: MediaQuery.of(context).size.height/50,
                                    fontWeight: FontWeight.w300
                                )
                            ),
                            style: TextStyle(color:Colors.black),),
                        ),),
                    ],
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height/17.2,
                        width: MediaQuery.of(context).size.width/2.5,
                        color: Colors.grey.withOpacity(0.5),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text('Company',
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/22),),
                                    Text('*',
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/22,
                                          color: Colors.red),),
                                    Text(' : ',
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/22),),
                                  ],
                                ),],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width- MediaQuery.of(context).size.width/2.5,
                        height: MediaQuery.of(context).size.height/17.2,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border:Border.all(
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
                                    color:Colors.black,
                                    fontSize: MediaQuery.of(context).size.height/50,
                                    fontWeight: FontWeight.w300
                                )
                            ),
                            style: TextStyle(color:Colors.black),),
                        ),),
                    ],
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height/17.2,
                        width: MediaQuery.of(context).size.width/2.5,
                        color: Colors.grey.withOpacity(0.5),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text('Designation',
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/22),),
                                    Text('*',
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/22,
                                          color: Colors.red),),
                                    Text(' : ',
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/22),),
                                  ],
                                ),],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width- MediaQuery.of(context).size.width/2.5,
                        height: MediaQuery.of(context).size.height/17.2,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border:Border.all(
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
                                hintText: 'Designation',
                                hintStyle: TextStyle(
                                    color:Colors.black,
                                    fontSize: MediaQuery.of(context).size.height/50,
                                    fontWeight: FontWeight.w300
                                )
                            ),
                            style: TextStyle(color:Colors.black),),
                        ),),
                    ],
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height/17.2,
                        width: MediaQuery.of(context).size.width/2.5,
                        color: Colors.grey.withOpacity(0.5),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('Company URL: ',
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width/22),),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width- MediaQuery.of(context).size.width/2.5,
                        height: MediaQuery.of(context).size.height/17.2,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border:Border.all(
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
                                hintText: 'Company URL',
                                hintStyle: TextStyle(
                                    color:Colors.black,
                                    fontSize: MediaQuery.of(context).size.height/50,
                                    fontWeight: FontWeight.w300
                                )
                            ),
                            style: TextStyle(color:Colors.black),),
                        ),),
                    ],
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height/7.5,
                        width: MediaQuery.of(context).size.width/2.5,
                        color: Colors.grey.withOpacity(0.5),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('Address : ',
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width/22),),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width- MediaQuery.of(context).size.width/2.5,
                        height: MediaQuery.of(context).size.height/7.5,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border:Border.all(
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
                                    color:Colors.black,
                                    fontSize: MediaQuery.of(context).size.height/50,
                                    fontWeight: FontWeight.w300
                                )
                            ),
                            style: TextStyle(color:Colors.black),),
                        ),),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}