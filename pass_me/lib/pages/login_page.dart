import "package:flutter/material.dart";
import "package:pass_me/components/my_button.dart";
import "package:pass_me/components/my_textfield.dart";


class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  // login method
  void login() {}

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

              // sign in button
              MyButton(text: "Login", onTap: login),

              const SizedBox(height: 10,),
              // don't have an account? register here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      " Register Here",
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
