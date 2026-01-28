import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kellyproject/Pages/connection.dart';
import 'package:kellyproject/Pages/person.description.dart';
import 'package:kellyproject/Pages/project.dart';
import 'package:readmore/readmore.dart';
import 'package:http/http.dart' as http;

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> with SingleTickerProviderStateMixin {
  String preface = "";
  String image = "";
  bool filterOnclic = false;
  String Filterby = "All";
  List project = [];
  bool istap = false;
  List year = [];
  List time = [];
  double _maDynamicOpacity = 0.0;

  // pour get tiout les donné par rapport au projet

  Future<void> GetProject() async {
     String uri = "https://dkhportfolio.pythonanywhere.com/api";

    Uri url = Uri.parse("$uri/projects");
    print("l'url est : $url");

    final res = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    print("la requète a marché");

    final statucode = res.statusCode;
    if (statucode == 200 || statucode == 201) {
      final data = jsonDecode(res.body);
      year.clear();
      final time = DateTime.now();
      setState(() {
        project = data;
        for (int i = 0; i < project.length; i++) {
          if (project[i]["date_realisation"] == null) {
            project[i]["date_realisation"] = "$time";
          }
        }

        project.sort(
          (a, b) => DateTime.parse(a["date_realisation"]).millisecondsSinceEpoch
              .compareTo(
                DateTime.parse(b["date_realisation"]).millisecondsSinceEpoch,
              ),
        );

        year = project
            .where((p) {
              return p["date_realisation"] != null;
            })
            .map((p) {
              return DateTime.parse(p["date_realisation"]).year.toString();
            })
            .toSet()
            .toList();
      });

      print("la réponse du body est ================= > $project");
    } else {
      print("la requète n'a pas marché");

      print("le status code est :$statucode");
    }
  }

  // Pour faire le filtre des projets

  @override
  void initState() {
    super.initState();
    print("La page est en train de s'ouvrir !");
    //
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _maDynamicOpacity = 1.0; // Cela va déclencher le mouvement
        });
      }
    });
    Future.microtask(() => GetProject());
  }

  Widget build(BuildContext context) {
    List<String> carouselImage = [
      "images/top.jpg",
      "images/2.jpg",
      "images/3.jpg",
      "images/4.jpg",
      "images/5.jpg",
      "images/6.jpg",
      "images/7.jpg",
      "images/4.jpg",
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // La première image ou le widget en haut de la page
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width * 1,
              child: Center(
                child: Stack(
                  children: [
                    CarouselSlider(
                      items: carouselImage
                          .map(
                            (item) => Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                item,
                                fit: BoxFit.fitWidth,
                                width: double.infinity,
                              ),
                            ),
                          )
                          .toList(),
                      options: CarouselOptions(
                        height: 300,

                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        enlargeCenterPage: true,
                        viewportFraction: 0.99,
                        aspectRatio: 16 / 9,
                        initialPage: 0,
                      ),
                    ),

                    Positioned(
                      right: 20,
                      child: IconButton(
                        onPressed: () {
                          // aller a la page de connection
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return connectionPage(project: project, getproject:GetProject());
                              },
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.settings,
                          color: const Color.fromARGB(255, 148, 146, 146),
                          size: MediaQuery.of(context).size.width < 600
                              ? 20
                              : 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Section "My work as an Architectural Assistant"
            Container(
              padding: EdgeInsets.only(
                left: 30,
                right: 30,
                top: 10,
                bottom: 10,
              ),
              child: Column(
                children: [
                  // Titre de la section
                  Container(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DefaultTextStyle(
                          // "My work as an Architectural Assistant",
                          style: TextStyle(
                            color: Color.fromARGB(255, 241, 136, 50),
                            fontSize: MediaQuery.of(context).size.width < 600
                                ? 16
                                : 25,
                            fontWeight: FontWeight.bold,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                "My work as an Architectural Assistant",
                                speed: Duration(milliseconds: 100),
                              ),
                            ],
                            totalRepeatCount: 1,
                          ),
                        ),

                        // les deux icones a droite du titre
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.menu,
                            size: MediaQuery.of(context).size.width < 600
                                ? 16
                                : 30,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  //  ajouter une photo representant le travail architectural et les descriptions
                  Card(
                    color: const Color.fromARGB(255, 58, 58, 58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(top: 20),

                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color.fromARGB(255, 230, 226, 226),
                          width: 0.4,
                        ),
                      ),
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // l'image a gauche
                              Container(
                                alignment: Alignment.topLeft,

                                decoration: BoxDecoration(),

                                child: AnimatedScale(
                                  scale: _maDynamicOpacity,
                                  duration: const Duration(
                                    milliseconds: 800,
                                  ), // Durée de l'animation
                                  curve: Curves.easeIn,
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),

                                    child: CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width <
                                              600
                                          ? 50
                                          : 90,
                                      backgroundImage: AssetImage(
                                        "assets/images/person.jpg",
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.04,
                              ),
                              // les différentes descriptions a droite de l'image
                              description(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  //  Pour la preface et le texte
                  Container(
                    child: Column(
                      children: [
                        Card(
                          color: const Color.fromARGB(255, 48, 47, 47),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),

                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              border: Border.all(
                                color: const Color.fromARGB(255, 230, 226, 226),
                                width: 0.4,
                              ),
                            ),
                            width: double.infinity,
                            padding: EdgeInsets.all(5),
                            // le texte preface
                            child: DefaultTextStyle(
                              // "Preface",
                              style: TextStyle(
                                color: Color.fromARGB(255, 241, 136, 50),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    "Preface",
                                    speed: Duration(milliseconds: 200),
                                  ),
                                ],
                                totalRepeatCount: 1,
                              ),
                            ),
                          ),
                        ),

                        Card(
                          color: const Color.fromARGB(255, 48, 47, 47),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),

                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              border: Border.all(
                                color: const Color.fromARGB(255, 230, 226, 226),
                                width: 0.4,
                              ),
                            ),
                            child: ReadMoreText(
                              "In 2026, I decided to keep a record of everything I do. It may not fit with the privacy policies of those I work with, but I feel the need to show what I’m capable of—especially at a point in my life when I no longer know exactly what the future holds.I have always aimed for more than just a master’s degree in architecture—I wanted to study at a prestigious school, not merely to fill a line on my CV, but to gain the education, guidance, and confidence that come with excellence. Without the means to enroll immediately, I threw myself into every opportunity to learn: working with multiple architects, sometimes as a volunteer, sometimes for pay, all while holding a full-time position at an architecture firm. Every experience was a chance to see different ways of working, to sharpen my architectural knowledge, and to expand my skills in research and design. This journey was not just about learning—it was about preparing myself to contribute meaningfully to the future of architecture .I know how difficult it is, but one day, while walking in the street and working on an architecture competition, I came across a quote that I will never forget: “Never give up on a dream because of the time it will take to accomplish it. The time will pass anyway.” — Earl Nightingale. Since then, I have resolved to work until I have the skills and abilities to pursue a master’s degree at a prestigious architecture school. I want to show my community that even if you come from a poor family, it is not fatal to dream big. In fact, it is often the best condition to dream, to work, and to achieve those dreams.",
                              trimCollapsedText: "Show more",
                              trimExpandedText: " Show less",
                              lessStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                              moreStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                              trimLines: 10,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),

                              trimMode: TrimMode.Line,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //  Pour les projets
                  SizedBox(height: 20),

                  Container(
                    child: Column(
                      children: [
                        // Titre de la section
                        Row(
                          children: [
                            Text(
                              "Projects",
                              style: TextStyle(
                                color: Color.fromARGB(255, 241, 136, 50),
                                fontSize: 20,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0.4,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      child: Dialog(
                                            child: Container(

                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                border: Border.all(
                                                  color:Color.fromARGB(255, 241, 136, 50),
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                              ),
                                              width: 20,
                                              height: 200,
                                      
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Filter by Year",style: TextStyle(color: const Color.fromARGB(255, 241, 136, 50),  fontSize: 25,fontWeight: FontWeight.bold  ),),
                                                  const SizedBox(height: 10),
                                                  ListView.separated(
                                                    shrinkWrap: true,
                                                    itemBuilder: (context, index) {
                                                      return TextButton(
                                                        child: Text(
                                                          " ${year[index]}",style: TextStyle(color: const Color.fromARGB(255, 145, 143, 143)  ,fontSize: 20,fontWeight: FontWeight.bold  )
                                                        ),
                                                        onPressed: () async {
                                                          
                                                           await GetProject();
                                                          setState(() {
                                                              filterOnclic = true;
                                                              Filterby = year[index];
                                                              
                                                            project = project
                                                                .where((p) {
                                                              return DateTime.parse(
                                                                          p[
                                                                              "date_realisation"])
                                                                      .year
                                                                      .toString() ==
                                                                  year[index];
                                                            }).toList();
                                                          });
                                                          Navigator.of(context).pop();
                                                        },
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (context, index) => Divider(),
                                                    itemCount: year.length,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  TextButton(onPressed: (){
                                                    GetProject();
                                                    setState(() {
                                                      filterOnclic = false;
                                                    });
                                                    Navigator.of(context).pop();

                                                  }, child: Text("All Projects",
                                                  style: TextStyle(color: const Color.fromARGB(255, 145, 143, 143), 
                                                   fontSize: 25,fontWeight: FontWeight.bold  ),),)
                                                ],
                                              ),
                                            ),
                                          
                                                                         
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.filter_list,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width < 600
                                    ? 15
                                    : 30,
                              ),
                            ),
                          ],
                        ),

                        // Ajouter ici les widgets représentant les projets (images, descriptions, etc.)

                        // Les projets dans une grille
                        Card(
                          color: const Color.fromARGB(255, 46, 45, 45),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white,
                                width: 0.4,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // l'année de réalisation des projects
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 4,
                                    bottom: 4,
                                  ),
                                  child: filterOnclic? Text(
                                    "$Filterby",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                              600
                                          ? 15
                                          : 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ):Text(
                                    "All Projects",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                              600
                                          ? 15
                                          : 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                ),

                                // le row des projets
                                project.isEmpty
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.orange,
                                        ),
                                      )
                                    : Project(Allproject: project),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        // le filtre a droite des projets
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
