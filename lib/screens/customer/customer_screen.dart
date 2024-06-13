import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/customer/Category/egg_page.dart';
import 'package:my_app/screens/customer/Category/feed_page.dart';
import 'package:my_app/screens/customer/Category/medicine_page.dart';
import 'package:my_app/screens/customer/category_screen.dart';
import 'package:my_app/screens/customer/profile_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    CustomerHomeScreen(), // Placeholder for Home Screen
    CategoryScreen(),
    Profile(),
  ];

  final List<String> notifications = [
    'You are welcome. Order the materials you need. Visit the category.'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void updateNotification(String message) {
    setState(() {
      notifications.clear();
      notifications.add(message);
    });
  }

  final List<String> imgList = [
    'assets/image8.jpg',
    'assets/image2.jpeg',
    'assets/image3.jpg',
    'assets/image4.jpg',
    'assets/image5.jpg',
    'assets/image7.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/b.png',
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Farm2Door',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 233, 205, 47),
      ),
      body: _currentIndex == 0
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                  Colors.black,
                  Colors.grey,
                  Colors.brown,
                  Colors.grey,
                  Colors.brown,
                  Colors.deepOrange,
                  Colors.black,
                ]),
              ),
              child: Column(
                children: [
                  SizedBox(height: 3),
                  // Carousel Slider Container
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 215.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {},
                    ),
                    items: imgList
                        .map((item) => Container(
                              child: Center(
                                child: Image.asset(
                                  item,
                                  fit: BoxFit.fitHeight,
                                  width: 1000,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      gradient:
                          LinearGradient(begin: Alignment.topCenter, colors: [
                        Colors.black,
                        Colors.black,
                      ]),
                    ),
                    height: 136,
                    width: double.infinity,
                    padding: EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              colors: [
                                Color.fromARGB(255, 236, 189, 189),
                                Color.fromARGB(255, 236, 189, 189),
                                Color.fromARGB(255, 236, 189, 189),
                              ]),
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              notifications.last,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 236, 10, 2),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Text(
                      'Category',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    height: 40,
                    width: double.infinity,
                    padding: EdgeInsets.all(2.0),
                    color: Color.fromARGB(255, 11, 197, 172),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CategoryCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EggsPage()),
                          );
                        },
                        imagePath: 'assets/white3.jpg',
                        label: 'Eggs',
                      ),
                      CategoryCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AnimalFeedsPage()),
                          );
                        },
                        imagePath: 'assets/feed.jpg',
                        label: 'Feeds',
                      ),
                      CategoryCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AnimalMedicinePage()),
                          );
                        },
                        imagePath: 'assets/medicine.jpg',
                        label: 'Medicine',
                      ),
                    ],
                  ),
                ],
              ),
            )
          : _screens[_currentIndex],
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                updateNotification('New notification!');
              },
              child: Icon(Icons.notification_add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 233, 205, 47),
        currentIndex: _currentIndex,
        selectedItemColor: const Color.fromARGB(255, 248, 6, 6),
        selectedFontSize: 16,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  CategoryCard({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 115,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
              border:
                  Border.all(color: const Color.fromARGB(255, 224, 218, 218)),
            ),
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
