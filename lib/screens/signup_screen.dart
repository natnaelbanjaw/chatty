import 'package:flutter/material.dart';
import 'package:globalchat/controllers/signup_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var userForm = GlobalKey<FormState>();

  bool isLoading = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController country = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("")),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: userForm,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.asset("assets/images/logo.png")),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(label: Text("Email")),
                        ),
                        const SizedBox(height: 23),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: password,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            return null;
                          },
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(label: Text("Password")),
                        ),
                        const SizedBox(height: 23),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Name is required";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(label: Text("Name")),
                        ),
                        const SizedBox(height: 23),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: country,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Country is required";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(label: Text("Country")),
                        ),
                        const SizedBox(height: 23),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(0, 50),
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.deepPurpleAccent),
                                  onPressed: () async {
                                    if (userForm.currentState!.validate()) {
                                      isLoading = true;
                                      setState(() {});

                                      // create account
                                      await SignupController.createAccount(
                                          context: context,
                                          email: email.text,
                                          password: password.text,
                                          country: country.text,
                                          name: name.text);
                                    }

                                    isLoading = false;
                                    setState(() {});
                                  },
                                  child: isLoading
                                      ? const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text("Create Account")),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
