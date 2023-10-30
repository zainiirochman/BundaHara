// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testing_bolo/pages/auth_page.dart';

class MinTransaction extends StatefulWidget {
  const MinTransaction({super.key});

  @override
  State<MinTransaction> createState() => _MinTransactionState();
}

class _MinTransactionState extends State<MinTransaction> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  bool isLoading = false;

  final controllerJumlah = TextEditingController();
  final controllerKategori = TextEditingController();

  DateTime sdate = DateTime.now();
  List<String> months = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember"
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: sdate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != sdate) {
      setState(() {
        sdate = picked;
      });
    }
  }

  Future<void> _saveToFirestore() async {
    // Mengonversi DateTime menjadi Timestamp Firestore
    Timestamp timestamp = Timestamp.fromDate(sdate);

    // Menyimpan ke Firestore
    await FirebaseFirestore.instance.collection('pengeluaran').doc().set({
      'tanggal': timestamp,
      'jumlah': int.parse(controllerJumlah.text),
      'kategori': _selectedItem,
      'uid': userId,
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> _dropdownItems = [];
  var _selectedItem;

  @override
  void initState() {
    super.initState();
    _loadDataFromFirestore();
  }

  Future<void> _loadDataFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('kategoriKeluar')
          .where('uid', isEqualTo: userId)
          .get();
      List<String> items = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // Ganti 'field_name' dengan nama field yang ingin Anda gunakan sebagai nilai dropdown
        items.add(doc['keluar']);
      }
      setState(() {
        _dropdownItems = items;
      });
    } catch (e) {
      print('Error loading data from Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                height: 140,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  color: Color(0xFFF96D75),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back,
                              size: 32.0,
                              color: Color.fromARGB(255, 255, 255, 255)),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => AuthPage(),
                              ),
                            );
                          },
                        ),
                        Text(
                          'Tambah Pengeluaran  ',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                            // height: 0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        textAlign: TextAlign.right,
                        controller: controllerJumlah,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Rp",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(115, 255, 255, 255),
                              fontSize: 24,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            )),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Masukkan Jumlah Valid';
                          }
                          return null;
                        },
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      width: 350,
                      height: 120,
                      decoration: ShapeDecoration(
                        color: Color.fromARGB(255, 240, 240, 240),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(14),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Kategori',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                DropdownButton<String>(
                                  iconSize: 12,
                                  hint: Text("Silakan pilih kategori"),
                                  value: _selectedItem,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedItem = newValue;
                                    });
                                  },
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 12,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w300,
                                    height: 0,
                                  ),
                                  items: _dropdownItems.map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tanggal',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.zero)),
                                  child: Text(
                                    "${DateTime.now().day} ${months[DateTime.now().month - 1]} ${DateTime.now().year}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w300,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _saveToFirestore();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AuthPage(),
              ),
            );
          },
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Icon(
                  Icons.add,
                ),
        ),
      ),
    );
  }
}
