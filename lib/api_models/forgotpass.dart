import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zoho_crm_clone/constants/constants.dart';

Future fpassemail(String email) async {
  print(email);
  var uri = "${customurl}/forget_password.php";
  final response = await http.post(
      uri, body: {
    'type': 's1',
    'email': email,
  },
      headers: <String, String>{
        'Accept': 'application/json',
      });
  var convertedDatatoJson = json.decode(response.body);
  return convertedDatatoJson;
  //BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyProfileClickedEvent);
}


Future fpassotp(String onetp, String uid, String cid, String clientname) async {
  var uri = "${customurl}/forget_password.php";
  final response = await http.post(
      uri, body: {
    'type': 's2',
    'otp': onetp,
    'id': uid,
    'client_id': cid,
    'client_name': clientname
  },
      headers: <String, String>{
        'Accept': 'application/json',
      });
  var convertedDatatoJson = json.decode(response.body);
  return convertedDatatoJson;
  //BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyProfileClickedEvent);
}