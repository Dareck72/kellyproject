import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kellyproject/Pages/connection.dart';

class ProjectFormPage extends StatefulWidget {
  String access;
  ProjectFormPage({super.key, required this.access});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker imagePicker = ImagePicker();
  final TextEditingController titreCtrl = TextEditingController();
  final TextEditingController dateCtrl = TextEditingController();
  bool isloading = false;
  Color primaryColor = const Color.fromARGB(255, 230, 119, 8);
  final TextEditingController architectCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController logicielCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  final TextEditingController imageGlobaleCtrl = TextEditingController();

  String date = "";
  XFile? Oneimage;
  List<TextEditingController> contributions = [TextEditingController()];
  List<Map<String, TextEditingController>> medias = [
    {'url': TextEditingController(), 'title': TextEditingController()},
  ];

  // {"detail":"Given token not valid for any token
  // type","code":"token_not_valid","messages":[{"token_class":"AccessToken","token_typ
  // e":"access","message":"Token is expired"}]}

  // fonction pour affiche le calendrié

  Future<void> _selectDate(BuildContext context) async {
    final picker = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (picker != null) {
      setState(() {
        date = "${picker.toIso8601String()}";
      });
    }
  }

  //foncions pour ajouté un projet

  Future<void> sendProjectData() async {
    String uri = "https://dkhportfolio.pythonanywhere.com/api";

    var url = Uri.parse('$uri/project/');
    var request = http.MultipartRequest('POST', url);
    List<String> mediaTitle = [];

    print("requete formé");
    // Champs texte
    request.headers['Authorization'] = 'Bearer ${widget.access}';
    request.fields['titre'] = titreCtrl.text;
    request.fields['architect'] = architectCtrl.text;
    request.fields['email_architect'] = emailCtrl.text;
    request.fields['logiciel'] = logicielCtrl.text;
    request.fields['description'] = descriptionCtrl.text;
    request.fields['date_realisation'] = date;

    List<String> contributionsList = [];

    for (var controller in contributions) {
      if (controller.text.isNotEmpty) {
        contributionsList.add(controller.text);
      }
    }

 
  request.fields['contributions'] = jsonEncode(contributionsList); // Note : selon l'API, il faudra peut-être utiliser un index comme 'contributions[]'


    // Pour les titres de médias
    // for (var media in medias) {
    //   String title = media['title']!.text;
    //   if (title.isNotEmpty) {
    //     request.fields['media_titles'] = title;
    //   }
    // }

    print("Ajout des donnés dans la requète");
    print("${request.fields["contributions"]}");
    print("la date de realisation est : ${request.fields["date_realisation"]}");

    if (Oneimage != null) {
      final bytes = await Oneimage!.readAsBytes();

      var multipartFile = http.MultipartFile.fromBytes(
        'image_globale',
        bytes,
        filename: Oneimage!.name,
      );

      request.files.add(multipartFile);
    }

    print("Ajout du Oneimagepicker  dans la requète");

    for (int i = 0; i < medias.length; i++) {
      String path = medias[i]['url']!.text;
      if (path.isNotEmpty) {
        final response = await http.get(Uri.parse(path));
        final bytes = response.bodyBytes;

        var multipartFile = http.MultipartFile.fromBytes(
          'files',
          bytes,
          filename: 'image_$i.jpg',
        );
        request.files.add(multipartFile);
        mediaTitle.add(medias[i]['title']!.text);
      }
    }

    request.fields['media_titles'] = jsonEncode(mediaTitle);

    try {
      var response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Succès !");
        print(responseBody);
        final String snack = "Project Add succesfully";
        final snackBar = SnackBar(
          content: Text(snack, style: const TextStyle(fontSize: 16)),
          backgroundColor: Colors.green,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.pop(context, true);
      } else {
        print("Erreur serveur : ${response.statusCode}");
        print(responseBody);
        if (response.statusCode == 401) {
          final String snack = "Session expired, please log in again.";
          AlertDialog(
            title: Text('Session Expired'),
            backgroundColor: Colors.red,
            content: Text(
              snack,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => connectionPage(
                        project: [],
                        getproject: Future.value(),
                      ),
                    ),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        }
      }
    } catch (e) {
      print("Erreur : $e");
    }
  }

  @override
  void dispose() {
    titreCtrl.dispose();
    architectCtrl.dispose();
    emailCtrl.dispose();
    logicielCtrl.dispose();
    descriptionCtrl.dispose();
    imageGlobaleCtrl.dispose();
    for (var c in contributions) {
      c.dispose();
    }
    for (var m in medias) {
      m['url']!.dispose();
      m['title']!.dispose();
    }
    super.dispose();
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      final data = {
        "titre": titreCtrl.text,
        "architect": architectCtrl.text,
        "email_architect": emailCtrl.text,
        "logiciel": logicielCtrl.text,
        "description": descriptionCtrl.text,
        "image_globale": Oneimage,
        "contributions": contributions.map((c) => c.text).toList(),
        "medias": medias
            .map(
              (m) => {
                "img_path": m['url']!.text,
                "img_title": m['title']!.text,
              },
            )
            .toList(),
      };

      debugPrint(data.toString());
    }
  }

  //  pour choisir plusieur images
  Future<void> imagepicker(int index) async {
    //ouvrire la gallery
    print("Clic détecté sur l'index : $index");
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        // On met le chemin de l'image dans le contrôleur 'url' du média correspondant
        medias[index]['url']!.text = image.path;
      });
    }
  }

  Future<void> Oneimagepicker() async {
    //ouvrire la gallery
    print("Clic détecté sur l'index : ");
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        Oneimage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(244, 59, 59, 59),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              child: Container(
                color: const Color.fromARGB(255, 29, 28, 28),
                padding: EdgeInsets.all(16.0),
                width: 600,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Create a new project",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 208, 108, 46),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "Informations du projet",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          // pour les imformation générales
                          Column(
                            children: [
                              _field(titreCtrl, 'Titre du projet'),
                              _field(architectCtrl, 'Architecte'),
                              _field(emailCtrl, 'Email', isEmail: true),
                              _field(logicielCtrl, 'Logiciel'),
                            ],
                          ),

                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "Description du projet",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          //  pour la description
                          _field(descriptionCtrl, 'Description', maxLines: 4),

                          const SizedBox(height: 20),
                          // Pour l'image globale
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // pour l'ajout de l'image
                              GestureDetector(
                                onTap: () => Oneimagepicker(),
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      208,
                                      108,
                                      46,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),

                              Container(
                                child: Text(
                                  "Realisation date",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Form(
                                  child: TextFormField(
                                    controller: dateCtrl,
                                    readOnly: true,
                                    onTap: () => _selectDate(context),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.calendar_month),
                                      iconColor: const Color.fromARGB(
                                        255,
                                        8,
                                        29,
                                        192,
                                      ),
                                      hintText: date.isEmpty
                                          ? 'Sélectionner une date'
                                          : date,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "Contributrions",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // la partie des contribution ...
                          Column(
                            children: [
                              ...contributions.asMap().entries.map((e) {
                                int index = e.key;
                                return Row(
                                  children: [
                                    Expanded(
                                      child: _field(
                                        e.value,
                                        'Contribution ${e.key + 1}',
                                      ),
                                    ),

                                    IconButton(
                                      onPressed: () => setState(
                                        () => contributions.removeAt(index),
                                      ),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              const SizedBox(height: 8),

                              OutlinedButton.icon(
                                onPressed: () => setState(
                                  () => contributions.add(
                                    TextEditingController(),
                                  ),
                                ),
                                icon: const Icon(Icons.add),
                                label: const Text('Ajouter une contribution'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          //our la partie : des détaille par rapport
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              " Project Details",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Column(
                            children: [
                              ...medias.asMap().entries.map((e) {
                                int index = e.key;
                                String imagePath =
                                    e.value['url']!.text; // Le chemin stocké

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // LE CONTENEUR D'IMAGE AVEC APERÇU
                                      GestureDetector(
                                        onTap: () => imagepicker(index),
                                        child: Container(
                                          width: 45,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                              255,
                                              208,
                                              108,
                                              46,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            // APERÇU : Si le chemin n'est pas vide, on affiche l'image
                                            image: imagePath.isNotEmpty
                                                ? DecorationImage(
                                                    // Utilise Image.network pour le WEB au lieu de FileImage
                                                    image: NetworkImage(
                                                      imagePath,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  )
                                                : null,
                                          ),
                                          child: imagePath.isEmpty
                                              ? const Icon(
                                                  Icons.add_a_photo,
                                                  color: Colors.white,
                                                  size: 20,
                                                )
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      // LE CHAMP TITRE
                                      Expanded(
                                        child: _field(
                                          e.value['title']!,
                                          'Titre de l\'image',
                                        ),
                                      ),
                                      // BOUTON SUPPRIMER (Optionnel)
                                      IconButton(
                                        onPressed: () => setState(
                                          () => medias.removeAt(index),
                                        ),
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(height: 10),
                              OutlinedButton.icon(
                                onPressed: () => setState(
                                  () => medias.add({
                                    'url': TextEditingController(),
                                    'title': TextEditingController(),
                                  }),
                                ),
                                icon: const Icon(Icons.add_photo_alternate),
                                label: const Text('Ajouter un média'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),

                              backgroundColor: const Color.fromARGB(
                                255,
                                208,
                                108,
                                46,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isloading = true;
                                });
                                await sendProjectData();

                                setState(() {
                                  isloading = false;
                                });
                              }
                            },
                            icon: const Icon(Icons.save, color: Colors.white),
                            label: isloading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 4,
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        225,
                                        88,
                                        3,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Enregistrer le projet',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
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
          ),
        ),
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    bool isEmail = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        onTap: () {},
        controller: controller,
        maxLines: maxLines,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        validator: (v) {
          if (v == null || v.isEmpty) {
            return 'field Empty';
          }
          return null;
        },
        decoration: InputDecoration(
          fillColor: Colors.white,
          labelText: label,
          labelStyle: TextStyle(
            color: const Color.fromARGB(255, 121, 119, 117),
          ),
          focusColor: const Color.fromARGB(255, 230, 119, 8),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 121, 119, 117),
              width: 0.2,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 230, 119, 8),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
