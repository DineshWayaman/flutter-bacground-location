import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:background_location/background_location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class LocationTracking extends StatefulWidget {
  const LocationTracking({super.key});

  @override
  State<LocationTracking> createState() => _LocationTrackingState();
}

class _LocationTrackingState extends State<LocationTracking> {

  String API_Response = '';
  String latitude = 'waiting..';
  String longitude = 'waiting..';
  String altitude = 'waiting..';
  String accuracy = 'waiting..';
  String bearing = 'waiting..';
  String speed = 'waiting..';
  String time = 'waiting..';
  bool? serviceRunning;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {


    PermissionStatus status = await Permission.locationAlways.request();
    if(status != PermissionStatus.granted){
      print('Permission denied for background location access.');
    }

    PermissionStatus serviceStatus = await Permission.notification.request();
    if (serviceStatus != PermissionStatus.granted) {
      // Handle permission denied
      print('Permission denied for background service.');
    }

  }
  
  Future<void> _uploadLocation() async {
    const String token = '18ed3d07-4b72-4e13-b65b-166562c3002c';
    final response = await http.post(
      Uri.parse('http://124.43.71.173:18089/api/v1/createLocations'),
      body: jsonEncode({'journey_id': 5556,'latitude': latitude, 'longitude': longitude}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Include Bearer token here
      },
    );
    API_Response = response.body;
    if(response.statusCode == 200){
      setState(() {
        API_Response = response.body;
      });
    }else{
      throw Exception('Failed to post data');
    }
  }

  Future<void> startService() async {

    await BackgroundLocation.setAndroidNotification(
      title: 'Background Location Service Running',
      message: 'Background location in progress',
      icon: '@drawable/launch_background',
    );

      await BackgroundLocation.startLocationService(
        distanceFilter: 0,
      );

      BackgroundLocation.getLocationUpdates((location){
        setState(() {


          if(latitude == location.latitude.toString() && longitude == location.longitude.toString()){

          }else{
            _uploadLocation();
          }

          latitude = location.latitude.toString();
          longitude = location.longitude.toString();
          accuracy = location.accuracy.toString();
          altitude = location.altitude.toString();
          bearing = location.bearing.toString();
          speed = location.speed.toString();
          time = DateTime.fromMillisecondsSinceEpoch(
              location.time!.toInt())
              .toString();

          
          
          
          
        });
        // print('''\n
        //                 Latitude:  $latitude
        //                 Longitude: $longitude
        //                 Altitude: $altitude
        //                 Accuracy: $accuracy
        //                 Bearing:  $bearing
        //                 Speed: $speed
        //                 Time: $time
        //                 IsServiceRunning: $serviceRunning
        //               ''');
      });
  }


  void checkServiceStatus() {
    BackgroundLocation.isServiceRunning().then((value){
        setState(() {
          serviceRunning = value;
        });

        print("Is running: $value");
    });
  }


  void getCurrentLocation() {
    BackgroundLocation().getCurrentLocation().then((location){
      print('This is current Location ' + location.toMap().toString());
    });
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   BackgroundLocation.stopLocationService();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              locationData('Latitude: ' + latitude),
              locationData('Longitude: ' + longitude),
              locationData('Altitude: ' + altitude),
              locationData('Accuracy: ' + accuracy),
              locationData('Bearing: ' + bearing),
              locationData('Speed: ' + speed),
              locationData('Time: ' + time),
              locationData('IsServiceRunning: ' + serviceRunning.toString()),
              ElevatedButton(onPressed: () { startService(); }, child: Text('Start Location Service'),),
              ElevatedButton(onPressed: () { BackgroundLocation.stopLocationService(); }, child: Text('Stop Location Service'),),
              ElevatedButton(onPressed: (){ checkServiceStatus(); }, child: Text('Check service'),),
              ElevatedButton(
                  onPressed: () {
                    getCurrentLocation();
                  },
                  child: Text('Get Current Location'),),
              SizedBox(height: 20.0),
              Text('Response: $API_Response'),
            ],
          ),
        ),
      ),
      ),
    );
  }


  Widget locationData(String data){
    return Text(
      data,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      textAlign: TextAlign.center,
    );
  }

}
