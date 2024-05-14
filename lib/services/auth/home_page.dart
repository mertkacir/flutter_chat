import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:namer_app/components/my_drawer.dart";
import "package:namer_app/pages/chat_page.dart";
import "package:namer_app/services/auth/auth_service.dart";
import "package:provider/provider.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //auth

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut(){
    final authService = Provider.of<AuthService>(context,listen: false);
    authService.signOut();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Ekran'),
        actions: [
          IconButton(
            onPressed:signOut , 
            icon: const Icon(Icons.logout),
            )
          ],
        ),
        drawer: MyDrawer(),
        body: _buildUserList(),
    );
    
  }
  Widget _buildUserList(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context,snapshot) {
        if (snapshot.hasError){
          return const Text('ERROR');
        }

        if (snapshot.connectionState == ConnectionState.waiting){
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
        );
      }
      );
  }

  Widget _buildUserListItem(DocumentSnapshot document){
    Map<String,dynamic> data = document.data()! as Map <String,dynamic>;

    //Display all users except
    if(_auth.currentUser!.email != data['email']){
      return ListTile(
        leading: Icon(Icons.email),
        title: Text(data['email']),
        onTap: (){

          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
            receiverUserEmail: data['email'],
            receiverUserID: data['uid'],
          ),),);
        },
      );
    } else {
      return Container();
    }
  }
}