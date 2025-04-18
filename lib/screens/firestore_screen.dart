import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import 'package:flutter_svg/flutter_svg.dart';


class FirestoreScreen extends StatefulWidget {
  @override
  _FirestoreScreenState createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(76, 175, 80, 1),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
          color: Colors.white,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: SvgPicture.asset(
                "assets/images/Logo.svg",
                height: 24,
                width: 24,
              ),
            ),

            SizedBox(width: 8),
            Text("SpendBuddy", style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.question_mark),
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              firestoreService.addUser(nameController.text, int.parse(ageController.text));
            },
            child: Text('Add User'),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: firestoreService.getUsers(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final users = snapshot.data!;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text(user['name']),
                      subtitle: Text('Age: ${user['age']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              nameController.text = user['name'];
                              ageController.text = user['age'].toString();
                              firestoreService.updateUser(user['id'], nameController.text, int.parse(ageController.text));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => firestoreService.deleteUser(user['id']),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
