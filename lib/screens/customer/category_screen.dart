import 'package:flutter/material.dart';
import 'package:my_app/screens/customer/Category/egg_page.dart';
import 'package:my_app/screens/customer/Category/feed_page.dart';
import 'package:my_app/screens/customer/Category/medicine_page.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class Category {
  final String name;
  final String imagePath;

  Category({required this.name, required this.imagePath});
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<Category> categories = [
    Category(name: 'Eggs', imagePath: 'assets/white3.jpg'),
    Category(name: 'Animal Feeds', imagePath: 'assets/feed.jpg'),
    Category(name: 'Animal Medicine', imagePath: 'assets/medicine.jpg'),
  ];

  void navigateToCategoryPage(BuildContext context, String categoryName) {
    switch (categoryName) {
      case 'Eggs':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EggsPage()),
        );
        break;
      case 'Animal Feeds':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AnimalFeedsPage()),
        );
        break;
      case 'Animal Medicine':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AnimalMedicinePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Category',
            style: TextStyle(color: Colors.black, fontSize: 16.0)),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [Colors.black, Colors.black])),
        padding: const EdgeInsets.all(
          20.0,
        ),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                navigateToCategoryPage(context, category.name);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 236, 189, 189),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.white, width: 2.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(2, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          category.imagePath,
                          width: 180.0,
                          height: 120.0, // make the image bigger
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 40.0),
                      Expanded(
                        child: Text(
                          category.name,
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 15, 10),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
