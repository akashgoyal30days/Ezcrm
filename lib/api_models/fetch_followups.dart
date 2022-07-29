import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zoho_crm_clone/constants/constants.dart';

Future fetchfollow(String useruid, String clientt, String fdate) async {
  var uri = "$customurl/leads.php";
  final response = await http.post(uri, body: {
    'type': 'lead_followup',
    'uid': useruid,
    'client': clientt,
    'date': fdate
  }, headers: <String, String>{
    'Accept': 'application/json',
  });
  var convertedDatatoJson = json.decode(response.body);
  return convertedDatatoJson;
  //BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyProfileClickedEvent);
}
