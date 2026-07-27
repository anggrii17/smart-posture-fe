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

  factory Posture.fromJson(Map<String, dynamic> json) {

    return Posture(

      id: int.parse(json["id"].toString()),

      pitch: double.parse(json["pitch"].toString()),

      status: json["status"],

      timestamp: json["timestamp"],

    );
  }

}