import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kellyproject/Pages/adminPage.dart';
import 'package:http/http.dart' as http;

class connectionPage extends StatefulWidget {
  final Future<void> getproject;
  List project;
 connectionPage({super.key,required this.project, required this.getproject});

  @override
  State<connectionPage> createState() => _connectionPageState();
}

class _connectionPageState extends State<connectionPage> {
  String refresh = "";
  String access = "";
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {

    // fonction pour la connection

    Future<void> _login() async {
      _formKey.currentState!.save();
    String uri = "https://dkhportfolio.pythonanywhere.com/api";

      Uri url = Uri.parse("$uri/auth/login/");
      print("l'url est : $url");

      final res = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"username": email, "password": password}),
      );

      print("la requète a marché");

      final statucode = res.statusCode;
      if (statucode == 200 || statucode == 201) {
        final data = jsonDecode(res.body);
        print("la réponse du body est ================= > $data");

        setState(() {
          refresh = data["refresh"];
          access = data["access"];
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Adminpage(access: access,project :widget.project, getproject: widget.getproject);
            },
          ),
        );
      } else {
        print("la requète n'a pas marché");

        print("le status code est :$statucode");
      }
    }



    bool _obscuretext = true;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: ListView(
        children: [
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width * 1,
            child: Image.asset(
              "assets/images/top.jpg",
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width * 1,
            ),
          ),
          const SizedBox(height: 100),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,

              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,

                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 136, 50),
                          border: Border.all(color: Colors.white, width: 0.2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Connection",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width < 600
                                ? 25
                                : 30,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),
                      //  Pour l'email
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email:",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 99, 93, 95),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 99, 93, 95),
                            ),
                          ),

                          prefixIcon: Icon(Icons.email_outlined),
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the email ";
                          }

                          // vérifié que l'email contient le @
                          if (!value.contains("@")) {
                            return "the email should contaiine the @ ";
                          }
                        },
                        onSaved: (value) {
                          setState(() {
                            email = value ?? "";
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      // pour le password
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 99, 93, 95),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          // comportement de l'icone lorsqu'il est selectione
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 99, 93, 95),
                            ),
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscuretext = !_obscuretext;
                              });
                            },

                            icon: Icon(
                              _obscuretext
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility,
                            ),
                          ),
                        ),

                        obscureText: _obscuretext,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "the password is important";
                          }
                        },
                        onSaved: (value) {
                          setState(() {
                            password = value ?? "";
                          });
                        },
                      ),

                      // Pour le boutton Login
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          //hauteur du bouton
                          minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.61,
                            50,
                          ),
                          foregroundColor: const Color.fromARGB(
                            255,
                            243,
                            241,
                            241,
                          ),
                          backgroundColor: Color.fromARGB(255, 241, 136, 50),
                          // la bordure du bouton
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            isloading = true;
                          });

                          await _login();

                          setState(() {
                            isloading = false;
                          });
                        },
                        child: isloading
                            ? Center(
                                child: SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.deepOrange,
                                    strokeWidth: 3.5,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Text("Log in", style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
