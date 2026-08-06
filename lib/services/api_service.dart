import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/posture.dart';
import 'api_config.dart';


class ApiService {


  //========================
  // CURRENT POSTURE
  //========================

  static Future<Map<String, dynamic>> getCurrentPosture() async {

    final response = await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}/get_current.php",
      ),
    );


    if (response.statusCode == 200) {

      return jsonDecode(response.body);

    }


    throw Exception(
      "Gagal mengambil data",
    );

  }




  //========================
  // LOG POSTURE
  //========================

  static Future<List<Posture>> getLogs() async {


    final response = await http.get(

      Uri.parse(
        "${ApiConfig.baseUrl}/get_logs.php",
      ),

    );



    if (response.statusCode == 200) {


      final List data =
          jsonDecode(response.body);



      return data
          .map(
            (e) => Posture.fromJson(e),
          )
          .toList();


    }



    throw Exception(
      "Gagal mengambil log",
    );


  }





  //========================
  // DELETE LOG POSTURE
  //========================

  static Future<bool> deleteLog(String id) async {


    final response = await http.post(

      Uri.parse(
        "${ApiConfig.baseUrl}/delete_log.php",
      ),


      body: {

        "id": id,

      },

    );




    if (response.statusCode == 200) {


      final data =
          jsonDecode(response.body);



      return data["success"] == true;


    }




    return false;


  }

//========================
// SAVE FCM TOKEN
//========================

static Future<bool> saveToken(String token) async {

  final response = await http.post(

    Uri.parse(
      "${ApiConfig.baseUrl}/save_token.php",
    ),

    body: {
      "token": token,
    },

  );

  if (response.statusCode == 200) {

    final data = jsonDecode(response.body);

    return data["success"] == true;

  }

  return false;
}

}
