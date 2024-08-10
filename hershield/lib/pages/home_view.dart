import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hershield/router.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.title,
    required this.navigationShell,
  });

  final String title;
  final StatefulNavigationShell navigationShell;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HerShield',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: widget.navigationShell, // Display the current page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (page) {
          setState(() {
            _selectedIndex = page;
            switch (page) {
              case 0:
                context.goNamed(routeNames.sos);
                break;
              case 1:
                context.goNamed(routeNames.communityfeed);
                break;
              case 2:
                context.goNamed(routeNames.areaprofiling);
                break;
              case 3:
                context.goNamed(routeNames.userprofile);
                break;
              default:
                break;
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed_outlined),
            activeIcon: Icon(Icons.feed_sharp),
            label: 'Community Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            activeIcon: Icon(Icons.map_outlined),
            label: 'Area Profile',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
