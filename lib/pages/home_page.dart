import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:nature_connect/custom_search_delegate.dart';
import 'package:nature_connect/custom_widgets/no_internet_widget.dart';
import 'package:nature_connect/internet_notifer.dart';
import 'package:nature_connect/pages/location.dart';
import 'package:nature_connect/pages/marketplace.dart';
import 'package:nature_connect/pages/newsfeed.dart';
import 'package:nature_connect/pages/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  bool _hasConnection = false; // Tracks the internet connection status
  StreamSubscription<InternetStatus>? _internetSubscription;
  @override
  void initState() {
    super.initState();
    // Initialize the InternetStatusNotifier and subscribe to status changes
    InternetStatusNotifier().initialize();

    // Listen for internet status changes and update accordingly
    _internetSubscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          if (mounted) {
            setState(() {
              _updateConnectionStatus(status);
            });
          }
          break;
        case InternetStatus.disconnected:
          if (mounted) {
            setState(() {
              _isLoading = false;
              _hasConnection = false;
            });
          }
          break;
      }
    });
  }

  Future<void> _updateConnectionStatus(InternetStatus status) async {
    bool hasInternet = await checkInternet();
    if (mounted) {
      setState(() {
        _isLoading = false;
        _hasConnection = status == InternetStatus.connected && hasInternet;
      });
    }
  }

  Future<bool> checkInternet() async {
    return await InternetConnection().hasInternetAccess;
  }

  @override
  void dispose() {
    debugPrint(_hasConnection.toString());
    _internetSubscription?.cancel();
    super.dispose();
  }

  // Called when a new tab is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : !_hasConnection
            ? const NoInternetWidget()
            : Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'NatureConnect',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        showSearch(
                            context: context, delegate: CustomSearchDelegate());
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.account_circle),
                      onPressed: () {
                        context.go('/profile'); // Navigate to profile page
                      },
                    ),
                  ],
                ),
                body: IndexedStack(
                  index: _selectedIndex,
                  children: const <Widget>[
                    NewsfeedPage(),
                    MarketplacePage(),
                    LocationPage(),
                    WeatherPage(),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.feed),
                      label: 'NewsFeed',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.store),
                      label: 'MarketPlace',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.location_on),
                      label: 'Location',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.wb_sunny),
                      label: 'Weather',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  unselectedItemColor: Theme.of(context).colorScheme.secondary,
                  selectedItemColor: Theme.of(context).primaryColor,
                  onTap: _onItemTapped,
                ),
              );
  }
}
