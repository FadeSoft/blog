import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:firebase_storage/firebase_storage.dart' as storage;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tinderclone/auth.dart';
import 'package:tinderclone/main-page.dart';
import 'package:tinderclone/main.dart';

AuthService _auth = AuthService();

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPage createState() => _MainPage();

  void onFileChanged(String fileUrl) {}
}

class _MainPage extends State<MainPage> {
  final ImagePicker _picker = ImagePicker();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    print("girildi");
    _auth.getData();
    _auth.downloadURLExample();
    _auth.getData().then((value) {
      print('Async done');
      userName = _auth.a.toString();

      print(userName);
    });

    setState(() {});
  }

  File? imagea;
  String? durl;
  String? userName = "";

  Future _selectPhoto() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.filter),
              title: Text('Pick a file'),
              onTap: () {
                Navigator.of(context).pop();
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
        onClosing: () {},
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile == null) {
      return;
    }

    var file = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
    if (file == null) {
      return;
    }

    file = await compressImagePath(file.path, 35);

    await _uploadFile(file.path);
  }

  Future<File> compressImagePath(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      newPath,
      quality: quality,
    );

    return result!;
  }

  Future _uploadFile(String path) async {
    final ref = storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${DateTime.now().toIso8601String() + p.basename(path)}');

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {});
    print("*******************************");

    widget.onFileChanged(fileUrl);
  }

  String a = "";
  String profileImageUrl = "";
  static String name = "", phone = "";
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "asdasd",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "asdasd",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "asdasd",
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 2) {
              showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  isScrollControlled: true,
                  builder: (context) => BottomSheet(
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(50),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: CircleAvatar(
                                      radius: 48,
                                      // Image radius
                                      backgroundImage: NetworkImage(
                                          _auth.imgUrl2.toString()),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 80,
                                    child: Text(
                                      "Welcome back " + _auth.a,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            62), // <-- Radius
                                      ),
                                    ),
                                    onPressed: () {
                                      _selectPhoto();
                                    },
                                    child: const Text(
                                      'Change Photo',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        onClosing: () {},
                      ));
            }
          });
        },
      ),
      appBar: AppBar(
        title: Text("asdasd"),
        backgroundColor: Colors.red,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.manage_accounts))
        ],
      ),
      drawer: Drawer(
        backgroundColor: Color.fromRGBO(113, 61, 209, 2),
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            Padding(padding: EdgeInsets.all(50)),
            Container(
              child: Text(
                _MainPage.phone + "",
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              child: CircleAvatar(
                radius: 48, // Image radius
                backgroundImage: NetworkImage(_auth.imgUrl.toString()),
              ),
            ),
            Container(
              width: 50,
              height: 50,
              child: Text(_auth.getData().toString()),
              color: Colors.red,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(62), // <-- Radius
                ),
              ),
              onPressed: () {
                _selectPhoto();
              },
              child: const Text(
                'SELECT FİLE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: const Text('Hesap Makinesi'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            Divider(
              color: Colors.black,
              height: 5,
            ),
            ListTile(
              title: const Text('Birim Çevirici'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.red,
            height: 200,
            child: Padding(
                padding: EdgeInsets.zero,
                child: Image(
                  width: 350,
                  height: 300,
                  image: NetworkImage(_auth.imgUrl2.toString()),
                )),
          ),
          CircularProgressIndicator(),
          Text(
            phone.toString() + " ",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          Container(
            width: 50,
            height: 50,
            child: Text(userName.toString()),
            color: Colors.red,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(62), // <-- Radius
              ),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: const Text(
              'LOG OUT',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(62), // <-- Radius
              ),
            ),
            onPressed: () {
              _selectPhoto();
            },
            child: const Text(
              'SELECT FİLE',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(62), // <-- Radius
              ),
            ),
            onPressed: () {
              setState(() {
                _auth.downloadURLExample();
              });
            },
            child: const Text(
              'getlink',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(62), // <-- Radius
              ),
            ),
            onPressed: () {
              setState(() {
                _auth.getData();
              });
            },
            child: const Text(
              'get  data',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(62), // <-- Radius
              ),
            ),
            onPressed: () {
              setState(() {
                _auth.downloadURLExample();
              });
            },
            child: const Text(
              'get  da',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
