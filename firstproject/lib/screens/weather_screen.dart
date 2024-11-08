import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import 'city_photos_screen.dart';
import 'home_screen.dart';

class WeatherScreen extends StatefulWidget {
  final String city;
  WeatherScreen({required this.city});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityName = '';
  String weather = '';
  String time = '';
  bool isLoading = true;
  String errorMessage = '';
  String cityImageUrl = '';
  bool _isFavorite = false; // Step 1: Add this variable

  Future<void> fetchCityImage() async {
    final apiKey = '';
    final url = 'https://api.pexels.com/v1/search?query=${widget.city}&per_page=1';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': apiKey,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['photos'].isNotEmpty) {
          setState(() {
            cityImageUrl = data['photos'][0]['src']['original'];
          });
        } else {
          setState(() {
            cityImageUrl = '';
          });
        }
      } else {
        throw Exception('Failed to load city image');
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error loading city image: $error';
      });
    }
  }

  Future<void> fetchWeather() async {
    final apiKey = '';
    final url = 'https://api.weatherbit.io/v2.0/current?city=${widget.city}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'][0];
        final timezone = data['timezone'];
        final location = tz.getLocation(timezone);
        final cityTime = tz.TZDateTime.now(location);

        setState(() {
          cityName = data['city_name'];
          weather = "${data['weather']['description']}, ${data['temp']}°C";
          time = DateFormat('HH:mm').format(cityTime);
          isLoading = false;
        });

        fetchCityImage();
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error loading weather: $error';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : errorMessage.isNotEmpty
            ? Text(errorMessage)
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              cityName,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            cityImageUrl.isNotEmpty
                ? Image.network(cityImageUrl, height: 200, width: 200, fit: BoxFit.cover)
                : Icon(Icons.image, size: 100),
            SizedBox(height: 20),
            Text('Weather: $weather', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('Current Time: $time', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Tooltip(
              message: "Add to Favorites",
              child: IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  favoritesProvider.addFavoriteCity(cityName);
                },
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CityPhotosScreen(city: cityName),
                  ),
                );
              },
              child: Text('More Photos'),
            ),
            SizedBox(height: 80),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}