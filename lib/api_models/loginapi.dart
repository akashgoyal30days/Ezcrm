import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zoho_crm_clone/constants/constants.dart';

Future loginUser(String email, String password) async {
  print(email);
  var uri = "${customurl}/login.php";
  final response = await http.post(
      uri, body: {
        'type': 'login',
        'username': email,
        'password' : password,
  },
      headers: <String, String>{
        'Accept': 'application/json',
      });
    var convertedDatatoJson = json.decode(response.body);
  return convertedDatatoJson;
  //BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyProfileClickedEvent);
}
