import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zoho_crm_clone/constants/constants.dart';

Future Get_Leads_Type(String useruid, String clientt) async {

  var uri = "${customurl}/leads.php";
  
  final response = await http.post(uri, body: {
    'uid': useruid,
    'client': clientt,
    'type': 'fetch_status'
  }, headers: <String, String>{
    'Accept': 'application/json',
  });
  var convertedDatatoJson = json.decode(response.body);
  return convertedDatatoJson;
  //BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyProfileClickedEvent);
}

Future Get_Leads(String useruid, String clientt, String stat_us, String start,
    String end) async {
  var uri = "${customurl}/leads.php";
  final response = await http.post(uri, body: {
    'uid': useruid,
    'client': clientt,
    'type': 'fetch_status_lead',
    'status': stat_us,
    'i_start': start,
    'i_end': end
  }, headers: <String, String>{
    'Accept': 'application/json',
  });
  var convertedDatatoJson = json.decode(response.body);
  return convertedDatatoJson;
  //BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyProfileClickedEvent);
}

Future Get_Leads_followup(
  String useruid,
  String clientt,
  String lid,
) async {
  var uri = "${customurl}/leads.php";
  final response = await http.post(uri, body: {
    'uid': useruid,
    'client': clientt,
    'type': 'leads_details',
    'lid': lid
  }, headers: <String, String>{
    'Accept': 'application/json',
  });
  var convertedDatatoJson = json.decode(response.body);
  return convertedDatatoJson;
  //BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyProfileClickedEvent);
}
