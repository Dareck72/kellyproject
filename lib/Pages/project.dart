import 'package:flutter/material.dart';
import 'package:kellyproject/Pages/Project.presentation.dart';

class Project extends StatefulWidget {
  final List Allproject;
  const Project({super.key, required this.Allproject});

  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  @override
  Widget build(BuildContext context) {
    // 1. Créez le contrôleur (dans votre State ou localement)
  final ScrollController _monControleur = ScrollController();
    return Container(
      height: 200,
      margin: EdgeInsets.only(top: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scrollbar(
            thumbVisibility:true,
            controller: _monControleur,
            child: ListView.separated(
              shrinkWrap: true,
              controller: _monControleur,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return projectPresentation(project: widget.Allproject , index: index,);
                        },
                      ),
                    );
                  },
                  child: Card(
                    color: const Color.fromARGB(255, 50, 50, 50),
                    child: Container(
                      height: 120,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          //l'image du projet
                          Expanded(
                            child: Image.network(
                              "${widget.Allproject[index]['image_globale']}",
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          const SizedBox(width: 5),
                          // le titre du projet
                          Container(
                            height: 40,
                            padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                            alignment: Alignment.center,
                            child: Row(
                              children:  [
                                Icon(
                                  Icons.folder,
                                  color: Color.fromARGB(255, 239, 236, 236),
                                  size: 16,
                                ),
                                SizedBox(width: 10),
                                // le titre du projet 
                                Expanded(
                                  child: Text(
                                    maxLines: 1,
                                    "${widget.Allproject[index]["titre"]}",
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      
                                      color: Color.fromARGB(255, 252, 250, 250),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(width: 10);
              },
              itemCount: widget.Allproject.length,
            ),
          );
        },
      ),
    );
  }
}
