import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/scr/provider/google_sign_in.dart';
import 'package:flutter_app/scr/widgets/hajo_rides.dart';
import 'package:flutter_app/scr/widgets/hajo_trips.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyStatefulWidget();
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    LoggedInWidget(),
    HajoRides(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome " + (user.displayName ?? 'user')),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogout();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.trip_origin),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bike_scooter),
            label: 'Rides',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 103, 136, 244),
        onTap: _onItemTapped,
      ),
    );
  }
}
