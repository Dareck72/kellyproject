import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

class description extends StatefulWidget {
  const description({super.key});

  @override
  State<description> createState() => _descriptionState();
}

class _descriptionState extends State<description> {
  @override
  Widget build(BuildContext context) {
    Uri facebook_url = Uri.parse("https://www.facebook.com");
    Uri Linkedin_url = Uri.parse("https://www.linkedin.com/in/dossou-kelly?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app");
    Uri Instagram_url = Uri.parse("https://www.Instagram.com");
    Uri Substack_url = Uri.parse("https://www.Substack.com");

    Future<void> _launchUrl(Uri url) async {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.only(top: 15),
     
          height: MediaQuery.of(context).size.width < 600 ? 160: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            shape: BoxShape.rectangle,
          ),
         
         
          child: Row(
            children: [
              //les descriptions dans la première colonne

                      Container(
                        alignment: Alignment.topLeft,

                      child:
                                    Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //chaque description

                  //la partir de Architectural assistant
                  Container(
                    width: MediaQuery.of(context).size.width < 600 ? 90 : 130,
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: const Color.fromARGB(255, 249, 248, 248),
                          width: 3,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      "Architectural assistant",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width < 600 ? 9 : 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  //la partir de Architectural Draftsperson
                  Container(
                    width: MediaQuery.of(context).size.width < 600 ? 90 : 130,
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.white, width: 3),
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      "Architectural Draftsperson",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:MediaQuery.of(context).size.width < 600 ? 9 : 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // la partir de BIM specialist
                  Container(
                    width:MediaQuery.of(context).size.width < 600 ? 90 : 130,
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.white, width: 3),
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      "BIM specialist",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width < 600 ? 9 : 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  //  la partie de  CEO of BIM VOX
                  Container(
                    width:MediaQuery.of(context).size.width < 600 ? 90 : 130,
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.white, width: 3),
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      "CEO of BIM VOX ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width < 600 ? 9 : 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ],
                  ),


                      )
                      ,

                      SizedBox(width: MediaQuery.of(context).size.width < 600 ? 20 : 40,),

                                    //  la deuxieme colonne des descriptions
              
              Container(


                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // facebok
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.white, width: 3),
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _launchUrl(facebook_url);
                        },
                        child: Text(
                          "Facebook",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width < 600 ? 11 : 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                
                    // linkdln
                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.white, width: 3),
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _launchUrl(Linkedin_url);
                        },
                        child: Text(
                          "LinkedIn",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width < 600 ? 11 : 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                
                    //instagram
                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.white, width: 3),
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _launchUrl(Instagram_url);
                        },
                        child: Text(
                          "Instagram",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width < 600 ? 11 : 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                
                    //  Substack
                    const SizedBox(height: 20),
                    Container(
                      
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.white, width: 3),
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _launchUrl(Substack_url);
                        },
                        child: Text(
                          "Substack",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width < 600 ? 11 : 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}




