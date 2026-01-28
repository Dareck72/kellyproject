import 'package:flutter/material.dart';
import 'package:kellyproject/Pages/Projectdetaill.dart';
import 'package:kellyproject/Pages/contribution.dart';
import 'package:readmore/readmore.dart';

class projectPresentation extends StatefulWidget {
  final List project;
  final int index;
  const projectPresentation({super.key, required this.project,required this.index});

  @override
  State<projectPresentation> createState() => _projectPresentationState();
}

class _projectPresentationState extends State<projectPresentation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 14, 14),

      body: ListView(
        children: [
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width * 1,
            child: Image.asset(
              "assets/images/top.jpg",
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width * 1,
            ),
          ),
          const SizedBox(height: 20),

          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //  La parti de détaille du projet
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // le titre du projet
                        Container(
                          child: Text(
                         "${widget.project[widget.index]["titre"]}",
                            style: TextStyle(
                              color:Color.fromARGB(255, 241, 136, 50),
                              fontSize: MediaQuery.of(context).size.width < 710
                                  ? 15
                                  : 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // LE nom de l'architecte
                        Container(
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.architecture,
                                    size:
                                        MediaQuery.of(context).size.width < 600
                                        ? 20
                                        : 30,
                                    color: Color.fromARGB(255, 195, 192, 192),
                                  ),
                                  const SizedBox(width: 10,),
                                  
                                  Text(
                                    "Architect's name :",
                                    style: TextStyle(
                                      color:Color.fromARGB(255, 195, 192, 192),
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                              710
                                          ? 10
                                          : 30,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 30),

                              Text(
                                "${widget.project[widget.index]["architect"]}",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 91, 91, 91),
                                  fontSize:
                                      MediaQuery.of(context).size.width < 640
                                      ? 10
                                      : 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // le mail de l'architecte
                        Container(
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.alternate_email,
                                    size:
                                        MediaQuery.of(context).size.width < 600
                                        ? 20
                                        : 30,
                                    color: Color.fromARGB(255, 195, 192, 192),
                                  ),

                                  const SizedBox(width: 9,),

                                  Text(
                                    "Architect's Mail :",
                                    style: TextStyle(
                                      color:Color.fromARGB(255, 195, 192, 192),
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                              710
                                          ? 10
                                          : 30,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Text(
                                 "${widget.project[widget.index]["email_architect"]}",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 91, 91, 91),
                                  fontSize:
                                      MediaQuery.of(context).size.width < 710
                                      ? 10
                                      : 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        //la date
                        Container(
                          child: 
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    size:
                                        MediaQuery.of(context).size.width < 600
                                        ? 20
                                        : 30,
                                    color: Color.fromARGB(255, 195, 192, 192),
                                  ),
                              const SizedBox(width: 9,),

                                  Text(
                                    "Date :",
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 195, 192, 192),
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                              710
                                          ? 10
                                          : 30,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 20),
                              Text(
                                "${widget.project[widget.index]["date_realisation"]}",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 91, 91, 91),
                                  fontSize:
                                      MediaQuery.of(context).size.width < 710
                                      ? 10
                                      : 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // le fichier attaché
                        Container(
                          child: Row(
                            children: [
                              Row(
                                children: [

                                  Icon(
                                    Icons.image,
                                    size:
                                        MediaQuery.of(context).size.width < 600
                                        ? 20
                                        : 30,
                                    color: Color.fromARGB(255, 195, 192, 192),
                                  ),

                                 const SizedBox(width: 13), 

                                  Text(
                                    "Image :",
                                    style: TextStyle(
                                      color:Color.fromARGB(255, 195, 192, 192),
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                              710
                                          ? 10
                                          : 30,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 20),

                              Icon(
                                Icons.image,
                                color: const Color.fromARGB(255, 97, 97, 97),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 0.2),
                    ),
                  ),

                  const SizedBox(height: 35),

                  Container(
                    child: ReadMoreText(
                      "${widget.project[widget.index]["description"]}",
                      trimMode: TrimMode.Line,
                      trimLines: 10,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 35),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 0.2),
                    ),
                  ),

                  const SizedBox(height: 20),

             Container(
              alignment: Alignment.topLeft,
                        height: 50,
                        child: Text(
                          "Project Details",
                          style: TextStyle(
                            color:Color.fromARGB(255, 241, 136, 50),
                            fontSize: MediaQuery.of(context).size.width < 710
                                ? 15
                                : 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),       

                         
                      Card(
                        color:  const Color.fromARGB(105, 60, 59, 59),
                        elevation: 10,
                        child:  Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color.fromARGB(255, 130, 129, 129), width: 0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(10),
                            width: double.infinity,
                          child: detail(project:widget.project,index:widget.index)),
                      ),
                                      
                  const SizedBox(height: 20),

                  //  les contributions sur ce projet 


                  Container(
                    alignment: Alignment.topLeft,
                    height: 400,
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Container(
                        height: 50,
                        child: Text(
                          "Contributions on this project",
                          style: TextStyle(
                            color:Color.fromARGB(255, 241, 136, 50),
                            fontSize: MediaQuery.of(context).size.width < 710
                                ? 15
                                : 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

// Pour les contributions
                         
                          Card(

                           
                            color: const Color.fromARGB(105, 60, 59, 59),
                            child: Container(
                              decoration: BoxDecoration(
                            border: Border.all(color: const Color.fromARGB(255, 130, 129, 129), width: 0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                              height: 200,
                              padding: EdgeInsets.all(10),
                                width: double.infinity,
                              child:Contribution(project:widget.project,index:widget.index
                              ) )

                          )


                    ],

                  ),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
