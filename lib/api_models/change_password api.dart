import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zoho_crm_clone/constants/constants.dart';

Future cpass(String uname, String uid, String opd, String npd ) async {
  var cpassuri = "${customurl}/login.php";
  final response = await http.post(
      cpassuri, body: {'uname': uname, 'uid': uid, 'old_pwd': opd, 'new_pwd': npd, 'type': 'change_password'
  },
      headers: <String, String>{
        'Accept': 'application/json',
      });
  var convertedDatas = json.decode(response.body);
  if(debug == 'yes'){print(convertedDatas);}
  return convertedDatas;
}
