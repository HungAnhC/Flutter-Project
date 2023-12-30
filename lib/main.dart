import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController originsController = TextEditingController();
  final TextEditingController destinationsController = TextEditingController();
  String distance = ''; // Khoảng cách được lưu ở đây
  final googleMapsLink =Uri.parse('https://www.google.com/maps');
  // Hàm gọi để mở gg map
  Future<void> _openGoogleMapsLink() async {
    if (await canLaunchUrl(googleMapsLink)) {
      await launchUrl(googleMapsLink);
    } else {
      print('Không thể mở đường dẫn.');
    }
  }
  // Hàm yêu cầu API Goong Distance Matrix để láy khoảng cách giữa các điểm 
  Future<void> getDistanceMatrix() async {
    final origins = originsController.text;
    final destinations = destinationsController.text;
    final apiKey = '15I9VL2bD0ZaFvYAnBjwldruSBPVKZCt1l1GnDNV';

    final url = Uri.parse('https://rsapi.goong.io/DistanceMatrix?origins=$origins&destinations=$destinations&vehicle=car&api_key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final distanceText = jsonData['rows'][0]['elements'][0]['distance']['text'];
      setState(() {
        distance = 'Khoảng cách: $distanceText';
      });
    } else {
      setState(() {
        distance = 'Lỗi: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Goong Distance Matrix API'),
        ),
        body:Container( 
          decoration: BoxDecoration(
            color: Color.fromARGB(219, 250, 250, 3),
            border: Border.all(width: 5, color: Colors.black26),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: _openGoogleMapsLink,
                child: Text('Chọn tọa độ trên gg map'),
              ),
              TextField(
                controller: originsController,
                decoration: InputDecoration(labelText: 'Nhập tọa độ điểm xuất phát'),
              ),
              TextField(
                controller: destinationsController,
                decoration: InputDecoration(labelText: 'Nhập tọa độ điểm đến'),
              ),
              ElevatedButton(
                onPressed: getDistanceMatrix,
                child: Text('Tính toán Khoảng cách'),
              ),
              Text(distance), // Hiển thị khoảng cách trên giao diện
            ],
          ),
        ),
      ),
    ));
  }
}
