import 'package:flutter/material.dart';
import 'package:globalchat/providers/userProvider.dart';
import 'package:globalchat/screens/edit_profile_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData = {};

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          CircleAvatar(radius: 50, child: Text(userProvider.userName[0])),
          const SizedBox(height: 8),
          Text(userProvider.userName,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),   
          Text(userProvider.userEmail),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const EditProfileScreen();
                }));
              },
              child: const Text("Edit Profile"))
        ]),
      ),
    );
  }
}
