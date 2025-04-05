import 'package:flutter/material.dart';
import 'package:frontend/api/massage.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {

    // Fetch data from API
    final api = MassageApiService(baseUrl: 'http://localhost:3000');
    api.getAllMassages().then((response) {
      print(response.data);
    }).catchError((error) {
      print(error);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('Hello'),
      ),
    );
  }
}