import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testing_bolo/pages/add_kategori.dart';
import 'package:testing_bolo/pages/auth_page.dart';

class Kategori extends StatefulWidget {
  const Kategori({super.key});

  @override
  State<Kategori> createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  final user = FirebaseAuth.instance.currentUser;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection('kategoriMasuk');
  CollectionReference _otherCollection =
      FirebaseFirestore.instance.collection('kategoriKeluar');

  _showDeleteConfirmationDialog(String itemId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Penghapusan'),
          content: Text('Anda yakin ingin menghapus item ini?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () {
                _deleteItem(itemId);
                _deleteOtherItem(itemId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteItem(String itemId) {
    return _itemsCollection.doc(itemId).delete();
  }

  Future<void> _deleteOtherItem(String itemId) {
    return _otherCollection.doc(itemId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          // mainAxisSize: MainAxisSize.max,
          // children: <Widget>[
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back,
                          size: 32.0, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => AuthPage(),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        'Kategori Anda',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                        padding: EdgeInsets.all(32),
                        width: 327,
                        height: MediaQuery.of(context).size.height,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _itemsCollection
                              .where('uid', isEqualTo: userId)
                              .snapshots(),
                          builder: (context, itemSnapshot) {
                            if (!itemSnapshot.hasData) {
                              return CircularProgressIndicator();
                            }

                            List<QueryDocumentSnapshot> items =
                                itemSnapshot.data!.docs;

                            return StreamBuilder<QuerySnapshot>(
                              stream: _otherCollection
                                  .where('uid', isEqualTo: userId)
                                  .snapshots(),
                              builder: (context, otherSnapshot) {
                                if (!otherSnapshot.hasData) {
                                  return CircularProgressIndicator();
                                }

                                List<QueryDocumentSnapshot> otherItems =
                                    otherSnapshot.data!.docs;

                                return ListView.builder(
                                  itemCount: items.length + otherItems.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index < items.length) {
                                      String itemName = items[index]['masuk'];

                                      return ListTile(
                                        tileColor: Color(0xFF4296F0),
                                        title: Text(itemName),
                                        titleTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                        subtitle: Text('Type : Pemasukan'),
                                        subtitleTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w300,
                                          height: 0,
                                        ),
                                        onTap: () {
                                          _showDeleteConfirmationDialog(
                                              items[index].id);
                                        },
                                      );
                                    } else {
                                      int otherIndex = index - items.length;
                                      String otherItemName =
                                          otherItems[otherIndex]['keluar'];

                                      return ListTile(
                                        tileColor: Color(0xFFF96D75),
                                        title: Text(otherItemName),
                                        titleTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                        subtitle: Text('Type : Pengeluaran'),
                                        subtitleTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w300,
                                          height: 0,
                                        ),
                                        onTap: () {
                                          _showDeleteConfirmationDialog(
                                              otherItems[otherIndex].id);
                                        },
                                      );
                                    }
                                  },
                                );
                              },
                            );
                          },
                        )
                        // child: StreamBuilder<QuerySnapshot>(
                        //   stream: FirebaseFirestore.instance
                        //       .collection('kategoriMasuk')
                        //       .snapshots(),
                        //   builder: (context, snapshot1) {
                        //     if (snapshot1.connectionState == ConnectionState.waiting) {
                        //       return CircularProgressIndicator(); // Menampilkan loading jika data belum ada
                        //     }

                        //     if (snapshot1.hasError) {
                        //       return Text('Error: ${snapshot1.error}');
                        //     }

                        //     return StreamBuilder<QuerySnapshot>(
                        //       stream: FirebaseFirestore.instance
                        //           .collection('kategoriKeluar')
                        //           .snapshots(),
                        //       builder: (context, snapshot2) {
                        //         if (snapshot2.connectionState ==
                        //             ConnectionState.waiting) {
                        //           return CircularProgressIndicator(); // Menampilkan loading jika data belum ada
                        //         }

                        //         if (snapshot2.hasError) {
                        //           return Text('Error: ${snapshot2.error}');
                        //         }

                        //         // Kode di bawah ini akan menampilkan data dari kedua koleksi Firestore dalam widget ListView
                        //         final data1 = snapshot1.data!.docs;
                        //         final data2 = snapshot2.data!.docs;

                        //         return ListView(
                        //           children: [
                        //             Text('Kategori Pemasukan Anda:'),
                        //             for (var document in data1) ...[
                        //               ListTile(
                        //                 title: Text(
                        //                   document['masuk'],
                        //                 ),
                        //                 titleTextStyle: TextStyle(
                        //                   color: Colors.black,
                        //                   fontSize: 18,
                        //                   fontFamily: 'Nunito',
                        //                   fontWeight: FontWeight.w500,
                        //                   height: 0,
                        //                 ),
                        //                 onTap: () {
                        //                   _showDeleteConfirmationDialog1(
                        //                       document['masuk']);
                        //                 },
                        //               ),
                        //             ],
                        //             Text('Kategori Pengeluaran Anda:'),
                        //             for (var document in data2) ...[
                        //               ListTile(
                        //                 title: Text(
                        //                   document['keluar'],
                        //                 ),
                        //                 titleTextStyle: TextStyle(
                        //                   color: Colors.black,
                        //                   fontSize: 18,
                        //                   fontFamily: 'Nunito',
                        //                   fontWeight: FontWeight.w500,
                        //                   height: 0,
                        //                 ),
                        //               ),
                        //             ],
                        //           ],
                        //         );
                        //       },
                        //     );
                        //   },
                        // ),
                        ),
                  ],
                ),
              ],
            ),
          ),
          // ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, size: 32.0, color: Colors.white),
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(builder: (context) => AddKategori()),
            )
                .whenComplete(() {
              setState(() {});
            });
          },
        ),
      ),
    );
  }
}
