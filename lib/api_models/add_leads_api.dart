import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zoho_crm_clone/constants/constants.dart';

Future addleads(
    String product,
    String customername,
    String phone,
    String email,
    String custcomp,
    String address,
    String city,
    String state,
    String lsource,
    String rem,
    String cname,
    String uuid,
    String rdate) async {
  var leadsuri = "$customurl/leads.php";
  final response = await http.post(leadsuri, body: {
    'type': 'add',
    'prods': product,
    'cust_name': customername,
    'cust_phone': phone,
    if (email == '') 'cust_email': '' else 'cust_email': email,
    if (custcomp == '') 'cust_company': '' else 'cust_company': custcomp,
    if (address == '') 'cust_address': '' else 'cust_address': address,
    if (city == '' || city == null) 'cust_city': '' else 'cust_city': city,
    if (state == '' || state == null) 'cust_state': '' else 'cust_state': state,
    'source': lsource,
    'remarks': rem,
    'client': cname,
    'uid': uuid,
    'recived_on': rdate
  }, headers: <String, String>{
    'Accept': 'application/json',
  });
  var convertedDatas = json.decode(response.body);
  if (debug == 'yes') {
    print(convertedDatas);
  }
  return convertedDatas;
}
