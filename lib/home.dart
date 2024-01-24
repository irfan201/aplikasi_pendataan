import 'dart:io';

import 'package:aplikasi_pendataan/add_siswa.dart';
import 'package:aplikasi_pendataan/auth/login.dart';
import 'package:aplikasi_pendataan/edit_siswa.dart';
import 'package:aplikasi_pendataan/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchController = TextEditingController();
  String selectedLembaga = 'latiseducation';
  List<String> lembagaOptions = ['latiseducation', 'tutorindonesia'];
  bool _isSearching = false;
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Cari...',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      _searchKeyword = value;
                    });
                  },
                )
              : const Text(
                  'Siswa',
                  style: TextStyle(color: Colors.white),
                ),
          backgroundColor: const Color(0xFFfd7e14),
          actions: [
            _isSearching
                ? IconButton(
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        _searchController.clear();
                      });
                    },
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
            IconButton(
              icon: const Icon(
                Icons.picture_as_pdf,
                color: Colors.white,
              ),
              onPressed: () {
                exportToPDF();
              },
            ),
          ],
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFfd7e14),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Siswa'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const HomePage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const LoginPage()));
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: selectedLembaga,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLembaga = newValue!;
                  });
                },
                items: lembagaOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            FutureBuilder(
              future: fetchData(selectedLembaga),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<DocumentSnapshot> documents = snapshot.data!.docs;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data =
                            documents[index].data() as Map<String, dynamic>;
                        // Build UI for each document
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(data[
                                            'foto_siswa'] ??
                                        'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['nama_siswa'],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      data['nis'],
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      data['email'],
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditSiswa(
                                                          docId:
                                                              documents[index]
                                                                  .id),
                                                ),
                                              );
                                            },
                                            child: const Text('Edit',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.orange)),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Konfirmasi'),
                                                      content: const Text(
                                                          'Apakah Anda yakin ingin menghapus data siswa ini?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    selectedLembaga)
                                                                .doc(documents[
                                                                        index]
                                                                    .id)
                                                                .delete();

                                                            Navigator.pop(
                                                                context); 
                                                          },
                                                          child: const Text(
                                                              'Batal'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    selectedLembaga)
                                                                .doc(documents[
                                                                        index]
                                                                    .id)
                                                                .delete();
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          },
                                                          child: const Text(
                                                              'Hapus'),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: const Text('Hapus',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red)),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddSiswa()));
          },
          backgroundColor: const Color(0xFFfd7e14),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> exportToPDF() async {
    // Get the data based on the search criteria
    QuerySnapshot querySnapshot = await fetchData(selectedLembaga);

    // Create a PDF document
    final pdf = pw.Document();

    // Add data to the PDF
    for (final doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            children: [
              pw.Text(data['nama_siswa'] ?? ''),
              pw.Text(data['nis'] ?? ''),
              pw.Text(data['email'] ?? ''),
              // Add other fields as needed
            ],
          ),
        ),
      );
    }

    // Get the document directory
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    // Save the PDF
    final File file = File('$path/siswa_data.pdf');
    await file.writeAsBytes(await pdf.save());

    // Share the PDF file
    Share.shareFiles(['${file.path}'], text: 'PDF exported successfully');
  }

  Future<QuerySnapshot> fetchData(String lembaga) async {
    // Dapatkan data dari Firestore
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(lembaga).get();

    // Terapkan filter berdasarkan kata kunci pencarian
    if (_searchKeyword.isNotEmpty) {
      querySnapshot = await FirebaseFirestore.instance
          .collection(lembaga)
          .where('nama_siswa', isGreaterThanOrEqualTo: _searchKeyword)
          .where('nama_siswa', isLessThan: _searchKeyword + 'z')
          .get();
    }

    return querySnapshot;
  }
}
