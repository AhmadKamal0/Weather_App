import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _cityController = TextEditingController();
  String weather = '';
  String time = '';
  String errorMessage = '';

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> fetchWeather(String city) async {
    if (city.length < 2) {
      setState(() {
        errorMessage = 'Please enter at least two letters for a valid city search.';
      });
      return;
    }

    final apiKey = '';
    final url = 'https://api.weatherbit.io/v2.0/current?city=$city&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];

        if (data.isEmpty || data[0]['city_name'].toLowerCase() != city.toLowerCase()) {
          setState(() {
            errorMessage = 'City not found. Please check the spelling and try again.';
            weather = '';
            time = '';
          });
          return;
        }

        final cityData = data[0];
        final timezone = cityData['timezone'];
        final location = tz.getLocation(timezone);
        final cityTime = tz.TZDateTime.now(location);

        setState(() {
          weather = "${cityData['weather']['description']}, ${cityData['temp']}°C";
          time = DateFormat('HH:mm').format(cityTime);
          errorMessage = '';
        });

        showWeatherDialog(cityData['city_name'], weather, time);
      } else {
        setState(() {
          errorMessage = 'City not found. Please check the spelling and try again.';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching weather: $error';
      });
    }
  }

  void showWeatherDialog(String city, String weather, String time) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Weather in $city'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Weather: $weather'),
              Text('Current Time: $time'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, city);
              },
              child: Text('Continue'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    ).then((selectedCity) {
      if (selectedCity != null) {
        Navigator.pop(context, selectedCity);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter city name',
                errorText: errorMessage.isNotEmpty ? errorMessage : null,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => fetchWeather(_cityController.text.trim()),
              child: Text('Check Weather'),
            ),
          ],
        ),
      ),
    );
  }
}

