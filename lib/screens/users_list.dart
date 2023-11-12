import 'package:flutter/material.dart';
import 'package:mindlift_flutter/database_repository.dart';
import 'package:mindlift_flutter/model/user_model.dart';

class UserDataTableScreen extends StatefulWidget {
  const UserDataTableScreen({Key? key}) : super(key: key);

  @override
  State<UserDataTableScreen> createState() => _UserDataTableScreen();
}

class _UserDataTableScreen extends State<UserDataTableScreen> {
  List<UserModel> myTodos = [];
  @override
  void initState() {
    initDb();
    super.initState();
  }

  void initDb() async {
    await DatabaseRepository.instance.getAllTodos().then((value) {
      setState(() {
        myTodos = value;
      });
    }).catchError((e) => debugPrint(e.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data Table'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('First Name')),
            DataColumn(label: Text('Last Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Password')),
          ],
          rows: myTodos.map((user) {
            return DataRow(
              cells: [
                DataCell(Text(user.firstname)),
                DataCell(Text(user.lastname)),
                DataCell(Text(user.email)),
                DataCell(Text(user.password)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
