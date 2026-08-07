import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/posture.dart';
import '../services/api_service.dart';


class LogScreen extends StatefulWidget {

  const LogScreen({
    super.key,
  });


  @override
  State<LogScreen> createState() =>
      _LogScreenState();

}



class _LogScreenState extends State<LogScreen> {


  late Future<List<Posture>> futureLogs;



  @override
  void initState() {

    super.initState();

    futureLogs =
        ApiService.getLogs();

  }



  Future refreshData() async {

    setState(() {

      futureLogs =
          ApiService.getLogs();

    });

  }



  //====================================
  // FORMAT TIMESTAMP DARI FLASK
  //====================================

  String formatTanggal(String timestamp){

    try {

      DateTime date;


      if(timestamp.contains("GMT")){


        final clean =
            timestamp
            .replaceAll("GMT", "")
            .trim();


        final parts =
            clean.split(" ");


        final day =
            parts[1];

        final month =
            parts[2];

        final year =
            parts[3];

        final time =
            parts[4];


        final months = {

          "Jan":"01",
          "Feb":"02",
          "Mar":"03",
          "Apr":"04",
          "May":"05",
          "Jun":"06",
          "Jul":"07",
          "Aug":"08",
          "Sep":"09",
          "Oct":"10",
          "Nov":"11",
          "Dec":"12",

        };


        date = DateTime.parse(

          "$year-${months[month]}-$day $time"

        );


      }else{


        date =
            DateTime.parse(timestamp);


      }



      return DateFormat(

        "dd MMM yyyy • HH:mm",

        "id_ID",

      ).format(date);



    }catch(e){


      return "-";


    }

  }
    @override
  Widget build(BuildContext context) {


    return Scaffold(


      body: Stack(


        children: [



          Container(

            height: 200,


            decoration:
            const BoxDecoration(

              gradient:
              LinearGradient(

                colors: [

                  Color(0xff2F46D8),

                  Color(0xff5146E5),

                ],


                begin:
                Alignment.topLeft,


                end:
                Alignment.bottomRight,


              ),

            ),

          ),






          SafeArea(

            child: Column(


              children: [



                const Padding(


                  padding:
                  EdgeInsets.only(

                    left:25,

                    top:20,

                    bottom:20,

                  ),



                  child: Align(

                    alignment:
                    Alignment.centerLeft,


                    child: Text(


                      "Riwayat Postur",


                      style:
                      TextStyle(

                        color:
                        Colors.white,


                        fontSize:30,


                        fontWeight:
                        FontWeight.bold,


                      ),


                    ),

                  ),


                ),






                Expanded(


                  child: Container(


                    width:
                    double.infinity,



                    decoration:
                    const BoxDecoration(


                      color:
                      Color(0xffF4F7FC),



                      borderRadius:
                      BorderRadius.only(


                        topLeft:
                        Radius.circular(35),


                        topRight:
                        Radius.circular(35),


                      ),


                    ),






                    child:
                    FutureBuilder<List<Posture>>(


                      future:
                      futureLogs,



                      builder:
                      (context,snapshot){



                        if(snapshot.connectionState ==
                            ConnectionState.waiting){



                          return const Center(


                            child:
                            CircularProgressIndicator(),


                          );

                        }






                        if(snapshot.hasError){


                          return Center(


                            child:
                            Text(

                              snapshot.error.toString(),

                            ),

                          );

                        }







                        final logs =
                            snapshot.data ?? [];






                        if(logs.isEmpty){


                          return const Center(


                            child:
                            Text(

                              "Belum ada data",

                            ),

                          );


                        }






                        return RefreshIndicator(


                          onRefresh:
                          refreshData,



                          child:
                          ListView(



                            padding:
                            const EdgeInsets.all(20),



                            children: [





                              Row(


                                children: const [



                                  Icon(

                                    Icons.history,

                                    color:
                                    Color(0xff304FFE),

                                  ),




                                  SizedBox(

                                    width:10,

                                  ),





                                  Text(


                                    "Semua Riwayat",



                                    style:
                                    TextStyle(


                                      fontSize:20,


                                      fontWeight:
                                      FontWeight.bold,


                                    ),


                                  ),



                                ],


                              ),





                              const SizedBox(

                                height:20,

                              ),






                              ...logs.map((log){



                                final bool good =
                                    log.status ==
                                    "Ergonomis";




                                final formattedDate =
                                    formatTanggal(
                                      log.timestamp,
                                    );




                                return Container(


                                  margin:
                                  const EdgeInsets.only(

                                    bottom:15,

                                  ),




                                  padding:
                                  const EdgeInsets.all(18),



                                  decoration:
                                  BoxDecoration(


                                    color:
                                    Colors.white,



                                    borderRadius:
                                    BorderRadius.circular(22),



                                    boxShadow: [


                                      BoxShadow(

                                        color:
                                        Colors.black.withOpacity(.05),


                                        blurRadius:12,


                                        offset:
                                        const Offset(0,8),

                                      ),


                                    ],


                                  ),
                                                                    child:
                                  Row(


                                    children: [



                                      CircleAvatar(


                                        radius:24,



                                        backgroundColor:


                                        good

                                        ? Colors.green.shade100

                                        : Colors.red.shade100,



                                        child:
                                        Icon(


                                          good

                                          ? Icons.check_circle

                                          : Icons.warning_amber_rounded,



                                          color:


                                          good

                                          ? Colors.green

                                          : Colors.red,


                                        ),


                                      ),






                                      const SizedBox(

                                        width:15,

                                      ),






                                      Expanded(


                                        child:
                                        Column(


                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,



                                          children: [





                                            Row(


                                              children: [





                                                Expanded(


                                                  child:
                                                  Text(


                                                    "${log.pitch.toStringAsFixed(1)}°",



                                                    style:
                                                    const TextStyle(


                                                      fontSize:24,


                                                      fontWeight:
                                                      FontWeight.bold,


                                                    ),



                                                  ),


                                                ),






                                                Container(


                                                  padding:
                                                  const EdgeInsets.symmetric(

                                                    horizontal:12,

                                                    vertical:6,

                                                  ),



                                                  decoration:
                                                  BoxDecoration(



                                                    color:

                                                    good

                                                    ? Colors.green.shade50

                                                    : Colors.red.shade50,



                                                    borderRadius:
                                                    BorderRadius.circular(20),



                                                  ),






                                                  child:
                                                  Text(



                                                    log.status,



                                                    style:
                                                    TextStyle(



                                                      color:

                                                      good

                                                      ? Colors.green

                                                      : Colors.red,



                                                      fontWeight:
                                                      FontWeight.bold,


                                                    ),


                                                  ),



                                                ),




                                              ],


                                            ),






                                            const SizedBox(

                                              height:8,

                                            ),






                                            Text(


                                              formattedDate,



                                              style:
                                              const TextStyle(



                                                color:
                                                Colors.grey,



                                                fontSize:13,



                                              ),



                                            ),




                                          ],


                                        ),


                                      ),



                                    ],


                                  ),



                                );



                              }).toList(),





                              const SizedBox(

                                height:100,

                              ),



                            ],



                          ),


                        );



                      },


                    ),


                  ),


                ),



              ],


            ),


          ),



        ],


      ),



    );


  }


}