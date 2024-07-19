import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String? photo;

  User({
    required this.id,
    required this.name,
    this.photo,
  });
}

final user = User(
  id: "abc123",
  name: "Audrey",
  photo: null,
);

class UserProfile extends StatelessWidget {
  final User user;

  UserProfile({required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (user.photo != null)
            Image.network(user.photo!)
          else
            Icon(Icons.person, size: 100),
          SizedBox(height: 20),
          Text(
            user.name,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 10),
          Text(
            'ID: ${user.id}',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
