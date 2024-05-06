import 'package:flutter/material.dart';
import 'package:namer_app/components/my_button.dart';
import 'package:namer_app/components/my_text_field.dart';
import 'package:namer_app/services/auth/auth_service.dart';
import 'package:provider/provider.dart';


class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repasswordController = TextEditingController();

  //Kayıt Ol
  void signUp()async{
    if(passwordController.text != repasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Şifre yanlış!")));
      return;
    }

    final authService = Provider.of<AuthService>(context,listen: false);

    try{
      await authService.signUpWithEmailAndPassword(emailController.text,passwordController.text,);
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),),);
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
                  "Hadi kayıt olalım!",
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


                const SizedBox(height: 10),
                //Parola Alanı
                MyTextField(controller: repasswordController,
                 hintText:"Şifrenizi tekrar giriniz", 
                 obscureText: true,
                 ),

                const SizedBox(height: 25),
                //Giriş Butonu
            
                MyButton(onTap: signUp, text: "Kayıt Ol"),

                const SizedBox(height: 50),
                //Kayıt ol Butonu
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Zaten üye misiniz ?"),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Giriş Yap",
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
      )
    );
  }
}