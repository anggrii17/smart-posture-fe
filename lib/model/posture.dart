class Posture {


  final int id;
  final double pitch;
  final String status;
  final String timestamp;



  Posture({

    required this.id,
    required this.pitch,
    required this.status,
    required this.timestamp,

  });



  factory Posture.fromJson(
      Map<String,dynamic> json
  ){

    return Posture(

      id:
      int.tryParse(
        json["id"].toString()
      ) ?? 0,


      pitch:
      double.tryParse(
        json["pitch"].toString()
      ) ?? 0,


      status:
      json["status"]?.toString()
      ?? "-",



      timestamp:
      json["timestamp"]?.toString()
      ?? "",


    );


  }


}