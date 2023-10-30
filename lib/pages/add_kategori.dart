import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testing_bolo/pages/kategori.dart';

class AddKategori extends StatefulWidget {
  const AddKategori({super.key});

  @override
  State<AddKategori> createState() => _AddKategoriState();
}

class _AddKategoriState extends State<AddKategori> {
  var selectedValue;
  final controllerKategori = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon:
                        Icon(Icons.arrow_back, size: 32.0, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => Kategori(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Type',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w300,
                      height: 0,
                    ),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  DropdownButton<String>(
                    hint: Text(
                      "Silakan Pilih Type Kategori",
                      style: TextStyle(
                        color: Color.fromARGB(115, 129, 129, 129),
                        fontSize: 12,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w300,
                        height: 0,
                      ),
                    ),
                    value: selectedValue,
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue = newValue;
                      });
                    },
                    items: <String>['Pemasukan', 'Pengeluaran']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: Text(
                      'Kategori',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w300,
                        height: 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    width: 200,
                    child: TextField(
                      cursorWidth: 80,
                      textAlign: TextAlign.left,
                      controller: controllerKategori,
                      keyboardType: TextInputType.text,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.singleLineFormatter,
                      ],
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Masukkan nama kategori",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(115, 129, 129, 129),
                            fontSize: 12,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w300,
                            height: 0,
                          )),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, size: 32.0, color: Colors.white),
          onPressed: () async {
            if (selectedValue == "Pemasukan") {
              await FirebaseFirestore.instance
                  .collection('kategoriMasuk')
                  .doc()
                  .set({
                'masuk': controllerKategori.text,
                'uid': userId,
              });
            }
            if (selectedValue == "Pengeluaran") {
              await FirebaseFirestore.instance
                  .collection('kategoriKeluar')
                  .doc()
                  .set({
                'keluar': controllerKategori.text,
                'uid': userId,
              });
            }
            if (selectedValue == null || controllerKategori.text == "") {
              return null;
            }

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Kategori(),
              ),
            );
          },
        ),
      ),
    );
  }
}
