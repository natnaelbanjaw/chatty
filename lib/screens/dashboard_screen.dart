import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:globalchat/providers/userProvider.dart';
import 'package:globalchat/screens/chatroom_screen.dart';
import 'package:globalchat/screens/profile_screen.dart';
import 'package:globalchat/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var user = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> chatroomsList = [];
  List<String> chatroomsIds = [];

  void getChatrooms() {
    db.collection("chatroom").get().then((dataSnapshot) {
      for (var singleChatroomData in dataSnapshot.docs) {
        chatroomsList.add(singleChatroomData.data());
        chatroomsIds.add(singleChatroomData.id.toString());
      }

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getChatrooms();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getUserDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    final String userInitial =
        userProvider.userName.isNotEmpty ? userProvider.userName[0] : "?";

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text("Chatty"),
          leading: InkWell(
            onTap: () {
              scaffoldKey.currentState!.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: CircleAvatar(radius: 20, child: Text(userInitial)),
            ),
          ),
        ),
        drawer: Drawer(
            child: Container(
                child: Column(children: [
          const SizedBox(height: 50),
          ListTile(
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ProfileScreen();
              }));
            },
            leading: CircleAvatar(child: Text(userInitial)),
            title: Text(userProvider.userName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(userProvider.userEmail),
          ),
          ListTile(
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ProfileScreen();
                }));
              },
              leading: const Icon(Icons.people),
              title: const Text("Profile")),
          ListTile(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return const SplashScreen();
                }), (route) {
                  return false;
                });
              },
              leading: const Icon(Icons.logout),
              title: const Text("Logout"))
        ]))),
        body: chatroomsList.isEmpty
            ? Center(
                child: Text(
                  "No chatrooms yet.",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
            : ListView.builder(
                itemCount: chatroomsList.length,
                itemBuilder: (BuildContext context, int index) {
                  String chatroomName = chatroomsList[index]["chatroom"] ?? "";
                  String chatroomInitial =
                      chatroomName.isNotEmpty ? chatroomName[0] : "?";

                  return ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ChatroomScreen(
                          chatroomName: chatroomName,
                          chatroomId: chatroomsIds[index],
                        );
                      }));
                    },
                    leading: CircleAvatar(
                        backgroundColor: Colors.blueGrey[900],
                        child: Text(
                          chatroomInitial,
                          style: const TextStyle(color: Colors.white),
                        )),
                    title: Text(chatroomName.isEmpty ? "Untitled" : chatroomName),
                    subtitle: Text(chatroomsList[index]["desc"] ?? ""),
                  );
                }));
  }
}
