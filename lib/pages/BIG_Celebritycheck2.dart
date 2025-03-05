import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import 'package:multipart_request/multipart_request.dart'; // You need to add this package to handle multipart requests

class BIG_FaceVerificationScreen extends StatefulWidget {
  const BIG_FaceVerificationScreen({super.key});

  @override
  _BIG_FaceVerificationScreenState createState() => _BIG_FaceVerificationScreenState();
}

class _BIG_FaceVerificationScreenState extends State<BIG_FaceVerificationScreen> {
  String _response = '';
  late Uint8List imageInMemory;
  late String imagePath;
  late File capturedFile;

  @override
  void initState() {
    super.initState();
    _verifyFaces();
  }


  Future<void> _verifyFaces() async {
    final url = Uri.parse('https://face-verification2.p.rapidapi.com/faceverification');

    // Create the multipart request
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll({
        'x-rapidapi-key': '5e70f4fc9emshd334e170e36833fp13f46bjsn7c053bd4b708',
        'x-rapidapi-host': 'face-verification2.p.rapidapi.com',
      });

    // Add form fields
    request.fields['linkFile1'] = 'https://i.ds.at/PKrIXQ/rs:fill:750:0/plain/2022/11/08/Jordan-StraussInvisionAP.jpg';
    request.fields['linkFile2'] = 'https://i.ds.at/PKrIXQ/rs:fill:750:0/plain/2022/11/08/Jordan-StraussInvisionAP.jpg';

    // Send the request and receive the response
    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      setState(() {
        _response = responseBody;
      });
    } catch (e) {
      setState(() {
        _response = 'a';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Verification'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _response.isNotEmpty ? _response*100 : 'Fetching response...',
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
