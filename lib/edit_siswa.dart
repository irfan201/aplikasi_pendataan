import 'dart:io';

import 'package:aplikasi_pendataan/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditSiswa extends StatefulWidget {
  final String docId;

  const EditSiswa({Key? key, required this.docId}) : super(key: key);

  @override
  _EditSiswa createState() => _EditSiswa();
}

class _EditSiswa extends State<EditSiswa> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nisController = TextEditingController();
  final TextEditingController _namaSiswaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fotoController = TextEditingController();
  List<String> lembagaOptions = [
    'latiseducation',
    'tutorindonesia',
  ];

  String selectedLembaga = 'latiseducation';

  @override
  void initState() {
    super.initState();
    fetchData(widget.docId);
  }

  void fetchData(String docId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection(selectedLembaga)
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        _nisController.text = data['nis'];
        _namaSiswaController.text = data['nama_siswa'];
        _emailController.text = data['email'];
        _fotoController.text = data['foto_siswa'];
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Siswa', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFFfd7e14),
        ),
        body: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Lembaga',
                      style: TextStyle(
                        color: Color(0xFFfd7e14),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedLembaga,
                      onChanged: (String? value) {
                        setState(() {
                          selectedLembaga = value!;
                        });
                      },
                      items: lembagaOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please choose an option';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Color(0xFFE9E9E9), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Color(0xFFE9E9E9), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Color(0xFFE9E9E9), width: 1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Nis',
                      style: TextStyle(
                        color: Color(0xFFfd7e14),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _nisController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Nis',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Color(0xFFE9E9E9), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Color(0xFFE9E9E9), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Color(0xFFE9E9E9), width: 1),
                        ),
                        hintStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Nama Siswa',
                      style: TextStyle(
                        color: Color(0xFFfd7e14),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _namaSiswaController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Nama Siswa',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Color(0xFFE9E9E9), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Color(0xFFE9E9E9), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Color(0xFFE9E9E9), width: 1),
                        ),
                        hintStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'email',
                      style: TextStyle(
                        color: Color(0xFFfd7e14),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        } else if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'email',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Color(0xFFE9E9E9), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Color(0xFFE9E9E9), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Color(0xFFE9E9E9), width: 1),
                        ),
                        hintStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'foto siswa',
                      style: TextStyle(
                        color: Color(0xFFfd7e14),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _fotoController,
                      decoration: InputDecoration(
                        hintText: 'foto siswa',
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Color(0xFFE9E9E9), width: 1),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Color(0xFFE9E9E9), width: 1),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Color(0xFFE9E9E9), width: 1),
                        ),
                        hintStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () async {
                            final XFile? pickedFile =
                                await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                            );

                            if (pickedFile != null) {
                              setState(() {
                                _fotoController.text = pickedFile.path;
                              });
                            }
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an image';
                        }

                        List<String> fileNameParts = value.split('.');
                        String fileExtension =
                            fileNameParts.last.toLowerCase();

                        // if (fileExtension != 'jpg' &&
                        //     fileExtension != 'png') {
                        //   return 'Invalid file format. Please select a JPG or PNG file.';
                        // }

                        return null;
                      },
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          _simpan();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFfd7e14),
                          minimumSize:
                              MediaQuery.of(context).size.width >= 600
                                  ? const Size(600, 53)
                                  : const Size(360, 43),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 void _simpan() async {
  try {
    if (_formKey.currentState?.validate() ?? false) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      String fileName = 'siswa_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef =
          FirebaseStorage.instance.ref().child('$selectedLembaga/$fileName');

      String? imageUrl;

      if (_fotoController.text.isNotEmpty) {
        File imageFile = File(_fotoController.text);
        if (imageFile.existsSync()) {
          UploadTask uploadTask = storageRef.putFile(imageFile);

          TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);

          imageUrl = await storageSnapshot.ref.getDownloadURL();
        } else {
         
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File gambar tidak ditemukan.'),
            ),
          );
          return; 
        }
      }

      if (imageUrl != null) {
        await firestore.collection(selectedLembaga).doc(widget.docId).update({
          'nis': _nisController.text,
          'nama_siswa': _namaSiswaController.text,
          'email': _emailController.text,
          'foto_siswa': imageUrl,
        });
      } else {
        await firestore.collection(selectedLembaga).doc(widget.docId).update({
          'nis': _nisController.text,
          'nama_siswa': _namaSiswaController.text,
          'email': _emailController.text,
        });
      }

      print('Data siswa berhasil disimpan');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  } catch (e) {
    print('Terjadi kesalahan: $e');
  }
}


}