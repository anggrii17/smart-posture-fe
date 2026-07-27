import 'dart:async';

import 'package:flutter/material.dart';

import '../model/posture.dart';
import '../services/api_service.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}



class _NotificationScreenState extends State<NotificationScreen> {

  late Future<List<Posture>> futureLogs;

  Timer? timer;



  @override
  void initState() {
    super.initState();


    futureLogs = ApiService.getLogs();


    timer = Timer.periodic(

      const Duration(seconds: 2),

      (_) {

        if (mounted) {

          setState(() {

            futureLogs = ApiService.getLogs();

          });

        }

      },

    );

  }



  @override
  void dispose() {

    timer?.cancel();

    super.dispose();

  }





  Future<void> refreshData() async {

    setState(() {

      futureLogs = ApiService.getLogs();

    });

  }





  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("Notifikasi"),

        centerTitle: true,

      ),



      body: FutureBuilder<List<Posture>>(

        future: futureLogs,


        builder: (context, snapshot) {



          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(

              child: CircularProgressIndicator(),

            );

          }





          if (snapshot.hasError) {

            return Center(

              child: Text(

                snapshot.error.toString(),

              ),

            );

          }





          var notifications = (snapshot.data ?? [])

              .where(

                (item) => item.status
                    .toLowerCase()
                    .contains("tidak"),

              )

              .toList();





          if (notifications.isEmpty) {

            return const Center(

              child: Text(

                "Belum ada notifikasi",

                style: TextStyle(

                  fontSize: 16,

                  color: Colors.grey,

                ),

              ),

            );

          }





          return RefreshIndicator(

            onRefresh: refreshData,


            child: ListView.builder(

              padding: const EdgeInsets.all(15),


              itemCount: notifications.length,


              itemBuilder: (context, index) {


                final item = notifications[index];





                return Dismissible(


                  key: Key(

                    item.id.toString(),

                  ),



                  direction:

                      DismissDirection.endToStart,




                  background: Container(


                    margin:

                        const EdgeInsets.only(

                      bottom: 12,

                    ),



                    alignment:

                        Alignment.centerRight,



                    padding:

                        const EdgeInsets.only(

                      right: 25,

                    ),



                    decoration: BoxDecoration(


                      color: Colors.red,


                      borderRadius:

                          BorderRadius.circular(12),


                    ),



                    child: const Icon(


                      Icons.delete,


                      color: Colors.white,


                      size: 30,


                    ),


                  ),





                  onDismissed: (direction) async {



                    bool success =

                        await ApiService.deleteLog(

                      item.id.toString(),

                    );





                    if (success) {


                      setState(() {


                        notifications.remove(item);


                      });




                      ScaffoldMessenger.of(context)

                          .showSnackBar(


                        const SnackBar(


                          content: Text(

                            "Notifikasi berhasil dihapus",

                          ),


                        ),


                      );



                    } else {



                      ScaffoldMessenger.of(context)

                          .showSnackBar(


                        const SnackBar(


                          content: Text(

                            "Gagal menghapus notifikasi",

                          ),


                        ),


                      );


                    }



                  },





                  child: Card(


                    elevation: 3,


                    margin:

                        const EdgeInsets.only(

                      bottom: 12,

                    ),



                    shape:

                        RoundedRectangleBorder(


                      borderRadius:

                          BorderRadius.circular(12),


                    ),




                    child: ListTile(


                      contentPadding:

                          const EdgeInsets.all(12),




                      leading: const CircleAvatar(


                        backgroundColor:

                            Colors.red,



                        child: Icon(


                          Icons.warning_amber_rounded,


                          color: Colors.white,


                        ),


                      ),





                      title: const Text(


                        "Postur Tidak Ergonomis",


                        style: TextStyle(


                          fontWeight:

                              FontWeight.bold,


                        ),


                      ),





                      subtitle: Column(


                        crossAxisAlignment:

                            CrossAxisAlignment.start,



                        children: [



                          const SizedBox(

                            height: 6,

                          ),




                          Text(


                            "Pitch : ${item.pitch.toStringAsFixed(1)}°",


                          ),




                          const SizedBox(

                            height: 4,

                          ),




                          Text(


                            item.timestamp,


                            style: const TextStyle(


                              color: Colors.grey,


                              fontSize: 12,


                            ),


                          ),



                        ],


                      ),



                    ),


                  ),


                );


              },


            ),


          );


        },


      ),


    );


  }


}