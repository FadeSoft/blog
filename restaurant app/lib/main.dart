import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todolist/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: MainPage(),
  ));
}

AuthService _auth = AuthService();

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  
  final tableInput = TextEditingController();
  final productInput = TextEditingController();
  final productCostInput =  TextEditingController();
  
  Color themeWhite=Color(0xfff9f4f4);
  Color themePink=Color(0xffc80e6e);
  Color themePurple=Color(0xff711953);



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: themeWhite,
        appBar: AppBar(
          backgroundColor: themeWhite,
          elevation: 10,
          title: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  color: themePurple,
                  iconSize: 30,
                  onPressed: () {
                    AddTable();
                  },
                  icon: Icon(
                    Icons.table_chart_sharp,
                  ),
                ),
                IconButton(
                  color: themePurple,
                  iconSize: 30,
                  onPressed: () {
                    AddProduct();
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
        body: MainCenter());
  }

  Widget MainCenter() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: StreamBuilder<QuerySnapshot>(
        stream: _auth.getStatus(),
        builder: (context, snaphot) {
          return !snaphot.hasData
              ? CircularProgressIndicator()
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 160,
                      crossAxisSpacing: 30.0,
                      mainAxisSpacing: 30.0,
                      childAspectRatio: 1),
                  itemCount: snaphot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot mypost = snaphot.data!.docs[index];

                    Future<void> _showChoiseDialog(BuildContext context) {
                      return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "MASA ${mypost['Desk Number']}",
                              textAlign: TextAlign.center,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            content: Container(
                              height: 260,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Ürünler: \n ${mypost.get("Products")}",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Fiyat: ${mypost.get("Cost")}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _auth.removeStatus(mypost.id);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Sil",
                                      style: TextStyle(
                                          color: Color(0xff711953),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      UpdateTable(mypost.id);
                                    },
                                    child: Text(
                                      "Güncelle",
                                      style: TextStyle(
                                          color: Color(0xff711953),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Vazgeç",
                                      style: TextStyle(
                                          color: Color(0xff711953),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return Container(
                      height: 210,
                      child: InkWell(
                        onTap: () {
                          _showChoiseDialog(context);
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                                colors: [
                                  themePurple,
                                  themePink,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),

                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              FaIcon(
                                Icons.restaurant,
                                color: Colors.white,
                                size: 45,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${mypost['Desk Number']}",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
  
  void AddProduct() {
    showModalBottomSheet<void>(
      backgroundColor: themePurple,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 100,
                width: 200,
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp(r'\s'),
                    ),
                  ],
                  controller: productInput,
                  style: TextStyle(color: Colors.white),
                  cursorColor: themePink,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hoverColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Ürün İsmi',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                height: 100,
                width: 200,
                child: TextField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                  controller: productCostInput,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hoverColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Ürün Fiyatı',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    _auth.addProduct(
                        productInput.text, int.parse(productCostInput.text));
                    productInput.text = "";
                    productCostInput.text = "";
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Kaydet',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void AddTable() {
    showModalBottomSheet<void>(
      backgroundColor: themePurple,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 100,
                width: 200,
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  controller: tableInput,
                  style: TextStyle(color: Colors.white),
                  cursorColor: themePink,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hoverColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Masa Numarası',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    _auth.createTable(tableInput.text);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Kaydet',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void UpdateTable(String postId) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Color(0xfff9f4f4),
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder<QuerySnapshot>(
          stream: _auth.getProducts(),
          builder: (context, snaphot) {
            return !snaphot.hasData
                ? CircularProgressIndicator()
                : GridView.builder(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 100,
                        crossAxisSpacing: 30.0,
                        mainAxisSpacing: 30.0,
                        childAspectRatio: 1),
                    shrinkWrap: true,
                    itemCount: snaphot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot mypost = snaphot.data!.docs[index];
                      return Container(
                        width: 20,
                        height: 60,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _auth.updateTable(
                                mypost.id, postId, mypost['ProductCost']);
                          },
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: themePurple,
                              borderRadius: BorderRadius.all(
                                Radius.circular(0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${mypost['ProductName']}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
          },
        );
      },
    );
  }
}
