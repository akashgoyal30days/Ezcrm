import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:zoho_crm_clone/constants/constants.dart';
import 'package:zoho_crm_clone/model/logout_model.dart';
import 'package:zoho_crm_clone/screens/Leads.dart';
import 'package:zoho_crm_clone/screens/search_query.dart';
import 'change pass.dart';
import 'contact_us.dart';
import 'dashboard.dart';
import 'followup.dart';


class Feedbacks extends StatefulWidget {
  Feedbacks({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FeedbacksState createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {
  // double _sigmaX = 0.0; // from 0-10
  // double _sigmaY = 0.0; // from 0-10
  // double _opacity = 0.1;
  bool dark = true;

  var currdt = DateTime.now();
  String username = '';
  String userid = '';
  String usertype = '';
  String clientname = '';
  String comapnyname = '';
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
  List files = [];
  var data;
  @override
  void initState(){
    Retrivedetails();
    super.initState();
  }
  List<Asset> images = List<Asset>();
  final _formKey = GlobalKey<FormState>();
  String _error = 'Select Images Failed';
  dynamic feedbackController = TextEditingController();
  getImageFileFromAsset(String path) async{
    final file = File(path);

    return file;
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        if(debug == 'yes') {
          print(asset.getByteData(quality: 100));
        }
        return Card(
          elevation: 0,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AssetThumb(
              asset: asset,
              width: 200,
              height: 200,
            ),
          ),
        );
      }),
    );
  }
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Attatchments",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }
  Future _upload() async{
    for (int i = 0; i<images.length; i++){
      var path2 = await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
      var file = await getImageFileFromAsset(path2);
      var base64Image = base64Encode(file.readAsBytesSync());
      files.add(base64Image);
    }
    var urii = "${customurl}/feedback.php";
    var bodydata = {
      'uid': userid,
      'type': 'feedback_query',
      'files': files,
      'query': feedbackController.text,
      'uname': username,
      'uemail': username,
      'ucomp': comapnyname,
      'query': feedbackController.text,
    };
    try {
      var response = await http.post(
          urii, body: json.encode(bodydata),
          headers: <String, String>{
            'Accept': 'application/json',
          });
      data = json.decode(response.body);
      if(debug == 'yes') {
        print(data);
      }
      if (data['status'] == true) {
        Navigator.pop(context);
        Toast.show("${'We successfully recorded your feedback'}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
      }
      else{
        Navigator.pop(context);
        Toast.show("${'failed to record your feedback'}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
      }
    }catch (error) {
      Navigator.pop(context);
      Toast.show("${'Oops!! we faced some error, please retry'}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
    }
  }
  Future UpdateLeadLoader(){
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
                      child: Image.asset('assets/images/updating.gif',width: MediaQuery.of(context).size.width/2,height: MediaQuery.of(context).size.height/5,),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: [
                            Text("Hold On!",style: TextStyle(fontSize: MediaQuery.of(context).size.width/10,color: Colors.black, letterSpacing: 1),),
                            SizedBox(height: 5,),
                            Text("Processing your request",style: TextStyle(fontSize: MediaQuery.of(context).size.width/18,color: Colors.black, letterSpacing: 1),),
                          ],
                        )),
                    Spacer(),
                  ],
                ),
              );
            }),
          );
        });}
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
        endDrawerEnableOpenDragGesture: true,
        key: _scaffoldKey,
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
          title: Text('Feedback',
            style: TextStyle(fontSize: MediaQuery.of(context).size.width/20,
                fontWeight: FontWeight.w300),),
          centerTitle: false,
          actions: [
            IconButton(icon: Icon(Icons.attach_file, size: MediaQuery.of(context).size.width/18,), onPressed: loadAssets),
            IconButton(icon: Icon(Icons.send_rounded, size: MediaQuery.of(context).size.width/18,), onPressed: (){
              if (_formKey.currentState.validate()) {
                if(images.length != 0)   Toast.show("${'Please wait while we record your feedback'}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                else if (images.length == 0)Toast.show("${'Please wait while we record your feedback'}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                      UpdateLeadLoader();
                _upload();
              }
            })
          ],
        ),
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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                            return Contactus();
                          }));
                    },
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
                    selected: true,
                    selectedTileColor: Colors.blue.withOpacity(0.5),
                    onTap: () {
                      Navigator.of(context).pop();
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
              child: Container(
                child:  Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/5,
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                                hintText: 'Enter Feedback',
                                hintStyle: TextStyle(
                                    color:Colors.black,
                                    fontSize: MediaQuery.of(context).size.height/50,
                                    fontWeight: FontWeight.w300
                                )
                            ),
                            style: TextStyle(color:Colors.black),
                            controller: feedbackController,
                            validator: (value) {
                              if(value.isEmpty){
                                return 'Please Fill This Field To Continue';
                              }
                              return null;
                            },
                          ),
                        ),),
                      if(images.length == 0)Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height/3.45,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border:Border.all(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          borderRadius: new BorderRadius.circular(0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Icon(Icons.file_copy_sharp, size: MediaQuery.of(context).size.width/3,
                              color: Colors.grey.withOpacity(0.4),),
                            Align(
                              alignment: Alignment.center,
                              child: Text('No files attatched',
                                style: TextStyle(color: Colors.grey,
                                    fontSize: MediaQuery.of(context).size.width/25),),
                            ),
                          ],
                        ))
                      else if(images.length != 0)Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height/3.45,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border:Border.all(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            borderRadius: new BorderRadius.circular(0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildGridView(),
                          ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}