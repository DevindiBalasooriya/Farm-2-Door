import 'package:flutter/material.dart';
import 'package:my_app/model/user.dart';
import 'package:my_app/services/database_service.dart';

class OwnerListPage extends StatefulWidget {
  const OwnerListPage({super.key});

  @override
  _OwnerListPageState createState() => _OwnerListPageState();
}

class _OwnerListPageState extends State<OwnerListPage> {
  final DatabaseService _databaseService = DatabaseService();

  late Future<List<User>> _farmOwnerList;

  @override
  void initState() {
    super.initState();
    _farmOwnerList = _databaseService.getUsersByRole('Farm owner');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farm Owner List'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 187, 206, 101),
              Color.fromARGB(255, 187, 206, 101),
              Color.fromARGB(255, 238, 172, 49),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<User>>(
          future: _farmOwnerList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No farm owners found'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  User user = snapshot.data![index];
                  return ListTile(
                    title: Text(user.userName),
                    subtitle: Text(user.address),
                    // Add more details as needed
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
