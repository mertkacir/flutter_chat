import 'package:flutter/material.dart';
import 'package:namer_app/components/my_button.dart';
import 'package:namer_app/components/my_text_field.dart';
import 'package:namer_app/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();




  //Giriş Yap
  void signIn() async{

    final authService = Provider.of<AuthService>(context,listen: false);

    try{
      await authService.signInWithEmailandPassword(
        emailController.text,
        passwordController.text,
        
       );
      
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),),),);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
       child: SingleChildScrollView( 
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                //logo
                  Icon(
                    Icons.message,
                    size:80,
                    color: Colors.grey[800],
                  ),


                 const SizedBox(height: 20),
                //Hoşgeldin Mesajı
                const Text(
                  "Chat uygulamamıza Hoşgeldiniz!",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                
                const SizedBox(height: 25),
                //E-Mail Alanı
                MyTextField(controller: emailController,
                 hintText:"E-mail", 
                 obscureText: false,
                 ),


                const SizedBox(height: 10),
                //Parola Alanı
                MyTextField(controller: passwordController,
                 hintText:"Şifre", 
                 obscureText: true,
                 ),


                const SizedBox(height: 25),
                //Giriş Butonu
            
                MyButton(onTap: signIn, text: "Giriş Yap"),

                const SizedBox(height: 50),
                //Kayıt ol Butonu
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Üye değil misiniz ?"),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Kayıt Ol",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                    ),
                  ],
                )

            
              ],
            
            
            ),
          ),
        ),
      ),
      ),
    );
  }
}