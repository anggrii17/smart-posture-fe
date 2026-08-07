import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/posture.dart';
import 'api_config.dart';


class ApiService {


  //==================================================
  // GET CURRENT POSTURE (REALTIME)
  //==================================================

  static Future<Map<String, dynamic>> getCurrentPosture() async {


    final response = await http.get(

      Uri.parse(
        "${ApiConfig.baseUrl}/current",
      ),

    );



    if(response.statusCode == 200){


      final json = jsonDecode(
        response.body,
      );


      if(json["success"] == true){

        return json["data"];

      }


      throw Exception(
        "Data current tidak ditemukan",
      );


    }


    throw Exception(
      "Gagal mengambil current posture",
    );


  }





  //==================================================
  // GET POSTURE LOGS
  //==================================================

  static Future<List<Posture>> getLogs() async {


    final response = await http.get(

      Uri.parse(
        "${ApiConfig.baseUrl}/logs",
      ),

    );



    if(response.statusCode == 200){


      final json = jsonDecode(
        response.body,
      );



      if(json["success"] == true){


        final List data =
            json["data"];



        return data
            .map(
              (e) => Posture.fromJson(e),
            )
            .toList();


      }



      throw Exception(
        "Log tidak ditemukan",
      );


    }



    throw Exception(
      "Gagal mengambil log posture",
    );


  }





  //==================================================
  // SAVE FCM TOKEN
  //==================================================

  static Future<bool> saveToken(
      String token
  ) async {


    try{


      final response = await http.post(


        Uri.parse(
          "${ApiConfig.baseUrl}/save_token",
        ),



        headers: {


          "Content-Type":
              "application/json",


        },



        body: jsonEncode({


          "token": token,


        }),


      );




      if(response.statusCode == 200){


        final data =
            jsonDecode(response.body);



        return data["success"] == true;


      }



      return false;



    }catch(e){


      print(
        "SAVE TOKEN ERROR : $e",
      );



      return false;


    }


  }

//==================================================
// DELETE LOG
//==================================================

static Future<bool> deleteLog(String id) async {

  try {

    final response = await http.post(

      Uri.parse(
        "${ApiConfig.baseUrl}/delete_log",
      ),

      headers: {

        "Content-Type":
            "application/json",

      },

      body: jsonEncode({

        "id": id,

      }),

    );



    if(response.statusCode == 200){


      final data =
          jsonDecode(response.body);



      return data["success"] == true;


    }


    return false;



  }catch(e){


    print(
      "DELETE LOG ERROR : $e",
    );


    return false;


  }

}
//==================================================
// GET STATUS ESP32
//==================================================

static Future<bool> getESPStatus() async {

  try {

    final response = await http.get(

      Uri.parse(
        "${ApiConfig.baseUrl}/esp_status",
      ),

    );

    if (response.statusCode == 200) {

      final json = jsonDecode(response.body);

      if (json["success"] == true) {

        return json["online"];

      }

    }

    return false;

  } catch (e) {

    print("ESP STATUS ERROR : $e");

    return false;

  }

}

}