import 'package:flutter/material.dart';
import 'package:kellyproject/Pages/Project.presentation.dart';

class detail extends StatefulWidget {
  final List project;
  final int index;
  const detail({super.key,required this.index ,required this.project});

  @override
  State<detail> createState() => _ProjectState();
}

class _ProjectState extends State<detail> {
  
  @override
  Widget build(BuildContext context) {
    List mediasList =widget.project[widget.index]["medias"] ;
    return Container(
      height: 200,
      margin: EdgeInsets.only(top: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Image.network('${widget.project[widget.index]["medias"][index]["img_path"]}');
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
                        Expanded(
                          child: Image.network(
                           '${widget.project[widget.index]["medias"][index]["img_path"]}',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        const SizedBox(width: 5),

                        Container(
                          height: 40,
                          padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              Icon(
                                Icons.folder,
                                color: Color.fromARGB(255, 239, 236, 236),
                                size: 16,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  '${widget.project[widget.index]["medias"][index]["img_title"]}',
                                  style: TextStyle(
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
            itemCount:mediasList.length,
          );
        },
      ),
    );
  }
}
