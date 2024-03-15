import 'package:flutter/material.dart';

import '../models/sr.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<List<SR>> srs = fetchSR();

  Future<List<SR>> fetchSR() async {
    const String token = '36447c0e-822b-402c-bdba-551f02b0b927';
    final response = await http.get(
        Uri.parse('http://124.43.71.173:18089/api/v1/getServiceRequestsForUser'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<SR> srs = data.map((json) => SR.fromJson(json)).toList();
      return srs;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
      Container(
          color: Colors.white,
          child: FutureBuilder<List<SR>>(
            future: srs,
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(snapshot.data![index].customerName),
                    );
                  },
                );
              }
            },
          ),
      ),),
    );
  }
}
