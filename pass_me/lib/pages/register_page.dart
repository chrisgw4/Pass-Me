import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:pass_me/components/my_button.dart";
import "package:pass_me/components/my_textfield.dart";
import "package:pass_me/helper/helped_functions.dart";


class RegisterPage extends StatefulWidget {
  final void Function()? onTap;


  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPwController = TextEditingController();

  // register method
  void register() async {
    //Show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator(),
        ), //center
    );
    //Make sure passwords match
    if (passwordController.text != confirmPwController.text){
      //Pop loading circle
      Navigator.pop(context);

      //show error messgae to user
      displayMessageToUser("Passwords Don't Match", context);
    }
    //try creating the user
   else{
      try{
        UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);

        //create user doc and then add to firestore
        createUserDocument(userCredential);

        //Pop loading circle
        if(context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e){
        //Pop loading circle
        Navigator.pop(context);

        displayMessageToUser(e.code, context);
      }
    }
  }

  //create and collect user doc to firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if(userCredential != null && userCredential.user != null){
      await FirebaseFirestore.instance.collection("User").doc(userCredential.user!.email).set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
        'greeting': "Hi, Nice to Meet You!",
        'upto': "I've been setting up my profile!",
        'uptoimage': "gs://passme-73d13.firebasestorage.app/Upto_PlaceHolder.png",
        'question': "Why did you join PassMe?",
        'pfpimage': "gs://passme-73d13.firebasestorage.app/Upto_PlaceHolder.png",
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Container(
                padding: EdgeInsetsGeometry.all(40),
                child: Image(image: AssetImage("assets/images/Pass_Me_Logo.png"),),
              ),

              // Icon(
              //   Icons.person,
              //   size: 80,
              //   color: Theme.of(context).colorScheme.inversePrimary,
              // ),

              const SizedBox(height: 50,),
              // app name
              // Text("PassMe", style: TextStyle(fontSize: 20),),
              // email text field
              MyTextField(
                  hintText: "Username",
                  obscureText: false,
                  controller: usernameController
              ),

              const SizedBox(height: 10,),
              // email text field
              MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController
              ),


              const SizedBox(height: 10,),
              // password text field

              MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController
              ),

              const SizedBox(height: 10,),
              MyTextField(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confirmPwController
              ),

              const SizedBox(height: 10,),
              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Forgot Password?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
              ),

              // register button
              MyButton(text: "Register", onTap: register),

              const SizedBox(height: 10,),
              // don't have an account? register here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      " Login Here",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
