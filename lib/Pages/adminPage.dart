import 'package:flutter/material.dart';
import 'package:kellyproject/Pages/Myapp.dart';
import 'package:kellyproject/Pages/addProjectForm.dart';
import 'package:http/http.dart' as http;

class Adminpage extends StatefulWidget {
  final Future<void> getproject;
  List project;
  String access;
  Adminpage({
    super.key,
    required this.access,
    required this.project,
    required this.getproject,
  });

  @override
  State<Adminpage> createState() => _AdminpageState();
}

class _AdminpageState extends State<Adminpage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final _descriptionKey = GlobalKey<FormState>();
  String profilDescrituion = '';
  String biograhie = "";
  String name = "";
  String email = "";

  @override
  Widget build(BuildContext context) {
    // fnction pour le delete des projets

    Future<void> deletProject(int id) async {
      String uri = "https://dkhportfolio.pythonanywhere.com/api";

      print("supprmé les projets de la base de donné");

      Uri url = Uri.parse("$uri/projects/delete/$id");

      print("Lancement de la requète");

      final res = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer ${widget.access}",
          "Content-Type": "application/json",
        },
      );

      final statucode = res.statusCode;

      if (statucode == 204) {
        setState(() {
          widget.project.removeWhere((project) => project["id"] == id);
        });
        print("requète accepté");
        print("Projet supprimé");

        final snack = "Projet deleted successfully";

        final snackbar = SnackBar(
          content: Text(snack),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      } else {
        print("le statut code est :$statucode");
        final snack = "Projet unDeleted";
        final snackbar = SnackBar(
          content: Text(snack),
          backgroundColor: const Color.fromARGB(255, 230, 41, 16),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);

        print("requète rejetée");
      }
    }

    void dispose() {
      textController.dispose();
      nameController.dispose();
      emailController.dispose();
      super.dispose();
    }

    void modal(int index) {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Dialog(
              child: Container(
                padding: EdgeInsets.all(20),

                width: 300,
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Are you sure you want to delete this project?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Boutton pour annulé la suppression du projet
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Bouttons pour confirmé la suppression du projet
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            deletProject(widget.project[index]["id"]);
                            Navigator.of( context).pop();
                          },
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child:
            // le dashbord
            Container(
              padding: EdgeInsets.only(left: 25, right: 25, top: 10),

              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 0.2),
              ),
              child: ListView(
                children: [
                  // le text d'accueil
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 202, 115, 52),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        // Pour letexte d'accueil
                         Container(
                          padding: EdgeInsets.only(left: 15,right: 10),
                            alignment: Alignment.center,
                            child: Text(
                              "Welcome to your admin page",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width > 700
                                    ? 25
                                    : 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          
                        ),
                     
                    //  le boutton de déconnexion
                        

                        Spacer(),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 241, 96, 64),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Myapp()), (route) => false);
                          },
                          label: Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          icon: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          iconAlignment: IconAlignment.start,
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  MediaQuery.of(context).size.width > 700
                      //lorsque je suis sur grand écran
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //  la première partie des deux container la partie gérer les projets
                            Expanded(
                              child: Container(
                                height: 310,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // le text gérer les projets
                                    Text(
                                      "Manage projects",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 5),
                                    //  la barre
                                    Container(
                                      height: 1,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 0.2,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    //le boutton pour ajouter les projets
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          202,
                                          115,
                                          52,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),

                                      onPressed: () async {
                                        print(
                                          "Boutton ajouté un projet appuyé",
                                        );
                                        // envoyé vers lapage d'ajout de projet
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ProjectFormPage(
                                                access: widget.access,
                                              );
                                            },
                                          ),
                                        );

                                        if (result == true) {
                                          //  actualisé la page admin aprés l'ajout d'un projet
                                          await widget.getproject;
                                          setState(() {});
                                        }
                                      },
                                      label: Text(
                                        'Add a project',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      iconAlignment: IconAlignment.start,
                                    ),

                                    const SizedBox(height: 10),

                                    //  la barre
                                    Container(
                                      height: 1,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 0.2,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    // Le text mes projets
                                    Container(
                                      child: Text(
                                        "My projects",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // pour les &
                                    Container(
                                      height: 150,
                                      color: const Color.fromARGB(
                                        255,
                                        224,
                                        222,
                                        222,
                                      ),
                                      child: ListView.separated(
                                        scrollDirection: Axis.vertical,
                                        itemCount: widget.project.length,
                                        itemBuilder: (contex, index) {
                                          // ce qui est retenue par tout
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white,
                                                  offset: Offset.zero,
                                                ),
                                              ],
                                            ),

                                            padding: EdgeInsets.all(10),

                                            // le contenu de chaque projet dans  la liste des projets
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${widget.project[index]["titre"]}",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      // pour le boutton éditer
                                                      Container(
                                                        constraints:
                                                            BoxConstraints(
                                                              maxWidth: 100,
                                                            ),
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                const Color.fromARGB(
                                                                  188,
                                                                  35,
                                                                  151,
                                                                  9,
                                                                ),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadiusGeometry.circular(
                                                                    10,
                                                                  ),
                                                            ),
                                                          ),
                                                          onPressed: () {},
                                                          child: Text(
                                                            "Editer",
                                                            style: TextStyle(
                                                              decorationStyle:
                                                                  TextDecorationStyle
                                                                      .solid,
                                                              color:
                                                                  const Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255,
                                                                  ),
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      const SizedBox(width: 10),

                                                      //  Pour le boutton supprimer
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              const Color.fromARGB(
                                                                255,
                                                                224,
                                                                8,
                                                                8,
                                                              ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadiusGeometry.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          modal(index);
                                                        },
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            color: Colors.white,
                                                            fontSize: 12,
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
                                        separatorBuilder: (context, index) {
                                          return SizedBox(height: 1);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            //  le pdeuxième contenaire
                            Expanded(
                              child: Container(
                                height: 310,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Edit profil",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    //  la barre
                                    Container(
                                      height: 1,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 0.2,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 5),
                                    // le row pour l'image et le nom puis prenom
                                    Row(
                                      children: [
                                        // l'image
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                "assets/images/person.jpg",
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 5),

                                        Container(
                                          width: 200,
                                          child: Form(
                                            key: _formkey,
                                            child: Column(
                                              children: [
                                                //le nom et prenom
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "the name is necessary";
                                                    }
                                                  },
                                                  onSaved: (newValue) {
                                                    setState(() {
                                                      name = newValue ?? "";
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                    constraints: BoxConstraints(
                                                      minHeight: 30,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 0.2,
                                                              ),
                                                        ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 0.2,
                                                              ),
                                                        ),
                                                  ),

                                                  controller: nameController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                ),

                                                const SizedBox(height: 5),
                                                //l'email
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "the email is necessary";
                                                    }
                                                    if (!value.contains("@")) {
                                                      return "email should contains @";
                                                    }
                                                  },

                                                  onSaved: (newValue) {
                                                    setState(() {
                                                      email = newValue ?? "";
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 0.2,
                                                              ),
                                                        ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 0.2,
                                                              ),
                                                        ),
                                                  ),

                                                  controller: emailController,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Text(
                                      "Biographie",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Form(
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            decoration: InputDecoration(
                                              constraints: BoxConstraints(),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 0.2,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 0.2,
                                                ),
                                              ),
                                            ),

                                            controller: textController,
                                            keyboardType: TextInputType.text,
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(double.infinity, 40),
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          202,
                                          115,
                                          52,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),

                                      onPressed: () {
                                        if (_formkey.currentState!.validate()) {
                                          _formkey.currentState!.save();
                                        }
                                      },
                                      label: Text(
                                        'Enregistrer',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.save_alt_rounded,
                                        color: Colors.white,
                                      ),
                                      iconAlignment: IconAlignment.start,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      //lorsque je suis sur téléphone
                      : Column(
                          children: [
                            //  la première partie des deux container la partie gérer les projets
                            Container(
                              height: 310,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Manage Projects",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),
                                  //  la barre
                                  Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 0.2,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  //le boutton pour ajouter les projets
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(
                                        255,
                                        202,
                                        115,
                                        52,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),

                                    onPressed: () async {
                                      print("Boutton ajouté un projet appuyé");
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ProjectFormPage(
                                              access: widget.access,
                                            );
                                          },
                                        ),
                                      );
                                      if (result == true) {
                                        //  actualisé la page admin aprés l'ajout d'un projet
                                        await widget.getproject;
                                        setState(() {});
                                      }
                                    },
                                    label: Text(
                                      'Add a project',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    icon: Icon(Icons.add, color: Colors.white),
                                    iconAlignment: IconAlignment.start,
                                  ),
                                  const SizedBox(height: 10),

                                  //  la barre
                                  Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 0.2,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  // Le text mes projets
                                  Container(
                                    child: Text(
                                      "My Projects",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    height: 150,
                                    color: const Color.fromARGB(
                                      255,
                                      224,
                                      222,
                                      222,
                                    ),
                                    child: ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      itemCount: widget.project.length,
                                      itemBuilder: (contex, index) {
                                        // ce qui est retenue par tout
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white,
                                                offset: Offset.zero,
                                              ),
                                            ],
                                          ),

                                          padding: EdgeInsets.all(10),

                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  "${widget.project[index]["titre"]}",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),

                                              Row(
                                                children: [
                                                  // pour le boutton éditer
                                                  Container(
                                                    constraints: BoxConstraints(
                                                      maxWidth: 100,
                                                    ),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            const Color.fromARGB(
                                                              188,
                                                              35,
                                                              151,
                                                              9,
                                                            ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadiusGeometry.circular(
                                                                10,
                                                              ),
                                                        ),
                                                      ),
                                                      onPressed: () {},
                                                      child: Text(
                                                        "Edit",
                                                        style: TextStyle(
                                                          decorationStyle:
                                                              TextDecorationStyle
                                                                  .solid,
                                                          color:
                                                              const Color.fromARGB(
                                                                255,
                                                                255,
                                                                255,
                                                                255,
                                                              ),
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(width: 5),

                                                  //  Pour le boutton supprimer
                                                  Container(
                                                    constraints: BoxConstraints(
                                                      maxWidth: 100,
                                                    ),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            const Color.fromARGB(
                                                              255,
                                                              224,
                                                              8,
                                                              8,
                                                            ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadiusGeometry.circular(
                                                                10,
                                                              ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        modal(index);
                                                      },
                                                      child: Container(
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(height: 1);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            //  le pdeuxième contenaire
                            Container(
                              height: 310,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Edit  profil",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  //  la barre
                                  Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 0.2,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 5),
                                  // le row pour l'image et le nom puis prenom
                                  Row(
                                    children: [
                                      // l'image
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: AssetImage(
                                              "assets/images/person.jpg",
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 5),
                                      // le formulaire de nom et email
                                      Container(
                                        width: 170,
                                        child: Form(
                                          key: _formkey,
                                          child: Column(
                                            children: [
                                              //le nom et prenom
                                              TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "the name is necessary";
                                                  }
                                                },
                                                onSaved: (newValue) {
                                                  setState(() {
                                                    name = newValue ?? "";
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  constraints: BoxConstraints(
                                                    minHeight: 30,
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 0.2,
                                                        ),
                                                      ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 0.2,
                                                        ),
                                                      ),
                                                ),

                                                controller: nameController,
                                                keyboardType:
                                                    TextInputType.text,
                                              ),

                                              const SizedBox(height: 5),
                                              //l'email
                                              TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "the email is necessary";
                                                  }
                                                  if (!value.contains("@")) {
                                                    return "email should contains @";
                                                  }
                                                },

                                                onSaved: (newValue) {
                                                  setState(() {
                                                    email = newValue ?? "";
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 0.2,
                                                        ),
                                                      ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 0.2,
                                                        ),
                                                      ),
                                                ),

                                                controller: emailController,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // la biographie
                                  Text(
                                    "Biography",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  Form(
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          decoration: InputDecoration(
                                            constraints: BoxConstraints(),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 0.2,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 0.2,
                                              ),
                                            ),
                                          ),

                                          controller: textController,
                                          keyboardType: TextInputType.text,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(double.infinity, 40),
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        202,
                                        115,
                                        52,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),

                                    onPressed: () {
                                      if (_formkey.currentState!.validate()) {
                                        _formkey.currentState!.save();
                                      }
                                    },
                                    label: Text(
                                      'Enregistrer',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.save_alt_rounded,
                                      color: Colors.white,
                                    ),
                                    iconAlignment: IconAlignment.start,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 15),

                  // le duexième dans la column
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Edit preface",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 15),
                        // la barre
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 0.2),
                          ),
                        ),

                        const SizedBox(height: 15),
                        // le texte
                        Form(
                          key: _descriptionKey,
                          child: Container(
                            child: TextFormField(
                              maxLines: 5,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Entrer a description";
                                }
                              },

                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.2,
                                  ),
                                ),

                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.2,
                                  ),
                                ),
                              ),

                              onSaved: (Value) {
                                profilDescrituion = Value ?? "";
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          alignment: Alignment.topRight,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(300, 40),
                              iconColor: Colors.white,
                              backgroundColor: Color.fromARGB(
                                255,
                                202,
                                115,
                                52,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(10),
                              ),
                            ),
                            onPressed: () {
                              if (_descriptionKey.currentState!.validate()) {
                                _descriptionKey.currentState!.save();
                              }
                            },
                            label: Text(
                              "Add preface description ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            icon: Icon(Icons.add),
                            iconAlignment: IconAlignment.start,
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
  }
}
