import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:json_bill_formatter/json_formatter/result_page.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _image;
  final picker = ImagePicker();
  Future getImageFromGallery() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future getImageFromCamera() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _showDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Center(child: Text("Pick image by")),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          getImageFromGallery();
                        },
                        child: const Text(
                          "Gallery",
                          style: TextStyle(color: Colors.black),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          getImageFromCamera();
                        },
                        child: const Text(
                          "Camera",
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Text(
          "JSON Bill Receipt Formatter",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 350,
                height: 400,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(15)),
                child: _image == null
                    ? GestureDetector(
                        onTap: _showDialog,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_outlined, size: 150),
                              SizedBox(height: 20),
                              Text(
                                  "Please upload an image of the bill receipt!")
                            ],
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(_image!, fit: BoxFit.fill),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: _image == null
                    ? const Text("")
                    : TextFormField(
                        controller: controller,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelText: "IP Address",
                          labelStyle: TextStyle(color: Colors.black),
                          border: const OutlineInputBorder().copyWith(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                          ),
                          enabledBorder: const OutlineInputBorder().copyWith(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                          ),
                          focusedBorder: const OutlineInputBorder().copyWith(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                          ),
                          errorBorder: const OutlineInputBorder().copyWith(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                          ),
                          focusedErrorBorder:
                              const OutlineInputBorder().copyWith(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              _image == null
                  ? const Text("")
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _image = null;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal),
                            child: const Text(
                              "Reset",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (controller.text.trim() == "") {
                                showSnackBar(
                                    "Error", "Please enter the IP Address!");
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResultPage(
                                            ip: controller.text.trim(),
                                            imageFile: _image,
                                          )),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal),
                            child: const Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
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

  void showSnackBar(String? errorMessage1, String errorMessage2) {
    Get.snackbar(
      backgroundColor: Colors.black,
      colorText: Colors.white,
      errorMessage1!,
      '$errorMessage2',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10), //
    );
  }
}
