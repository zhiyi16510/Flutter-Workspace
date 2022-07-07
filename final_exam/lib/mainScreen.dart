import 'package:flutter/material.dart';
import 'package:lab_assignment_2/subjectsList.dart';
import 'package:lab_assignment_2/tutorsList.dart';
import 'package:lab_assignment_2/cartScreen.dart';
import '../models/user.dart';

class mainScreen extends StatefulWidget {
  final User user;
  const mainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  late List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      subjectsList(
        user: widget.user,
      ),
      tutorsList(),
      cartScreen(
        user: widget.user,
      ),
      const Text(
        'Subscription',
        style: optionStyle,
      ),
      const Text(
        'User Profile',
        style: optionStyle,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.book_online_outlined),
              label: 'Subjects',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_people_outlined),
              label: 'Tutors',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
              backgroundColor: Color.fromARGB(255, 45, 49, 117),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.upcoming),
              label: 'Subscribe',
              backgroundColor: Colors.purple,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Color.fromARGB(255, 156, 167, 29),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 237, 235, 234),
          onTap: _onItemTapped,
        ));
  }
}
