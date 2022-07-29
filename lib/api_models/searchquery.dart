import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zoho_crm_clone/constants/constants.dart';

Future sqry(String useruid, String clientt, String svalue) async {
  var uri = "$customurl/search.php";
  final response = await http.post(uri, body: {
    'type': 'search',
    'uid': useruid,
    'client': clientt,
    'search_prm': svalue
  }, headers: <String, String>{
    'Accept': 'application/json',
  });
  var convertedDatatoJson = json.decode(response.body);
  return convertedDatatoJson;
  //BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyProfileClickedEvent);
}
