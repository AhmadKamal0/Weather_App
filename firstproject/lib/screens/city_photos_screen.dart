import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CityPhotosScreen extends StatefulWidget {
  final String city;
  CityPhotosScreen({required this.city});

  @override
  _CityPhotosScreenState createState() => _CityPhotosScreenState();
}

class _CityPhotosScreenState extends State<CityPhotosScreen> {
  List<String> cityImages = [];
  bool isLoading = true;

  Future<void> fetchCityImages() async {
    final apiKey = '';
    final url = 'https://api.pexels.com/v1/search?query=${widget.city}&per_page=10';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': apiKey,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          cityImages = [for (var photo in data['photos']) photo['src']['original']];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load city images');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCityImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.city} Photos')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: cityImages.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return Image.network(
            cityImages[index],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}

