import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/favorites_provider.dart';
import 'settings_screen.dart';
import 'weather_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/title.png',
                height: 150,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final city = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(),
                      ),
                    );
                  },
                  child: Text('Find City'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => themeNotifier.toggleTheme(),
                  child: Text('Toggle Theme'),
                ),
                SizedBox(height: 20),
                Text(
                  'Favorite Cities:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold, // Make the text bold
                    color: Colors.white, // Set text color (the outline will be black)
                    shadows: [
                      Shadow(
                        offset: Offset(-1.5, -1.5),
                        color: Colors.black,
                      ),
                      Shadow(
                        offset: Offset(1.5, -1.5),
                        color: Colors.black,
                      ),
                      Shadow(
                        offset: Offset(1.5, 1.5),
                        color: Colors.black,
                      ),
                      Shadow(
                        offset: Offset(-1.5, 1.5),
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                for (var city in favoritesProvider.favoriteCities)
                  Text(
                    city,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold, // Make the text bold
                      color: Colors.white, // Set text color (the outline will be black)
                      shadows: [
                        Shadow(
                          offset: Offset(-1.5, -1.5),
                          color: Colors.black,
                        ),
                        Shadow(
                          offset: Offset(1.5, -1.5),
                          color: Colors.black,
                        ),
                        Shadow(
                          offset: Offset(1.5, 1.5),
                          color: Colors.black,
                        ),
                        Shadow(
                          offset: Offset(-1.5, 1.5),
                          color: Colors.black,
                        ),
                      ],
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
