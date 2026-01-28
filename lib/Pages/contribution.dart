import 'package:flutter/material.dart';

class Contribution extends StatefulWidget {
  int index;
  List project;
  Contribution({super.key, required this.project, required this.index});

  @override
  State<Contribution> createState() => _ContributionState();
}

class _ContributionState extends State<Contribution> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(Icons.donut_small, color: Colors.white),
            title: Text(
              "${widget.project[widget.index]['contributions'][index]}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      },
      itemCount: widget.project[widget.index]['contributions'].length,
    );
  }
}
