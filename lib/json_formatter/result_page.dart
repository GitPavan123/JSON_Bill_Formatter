import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import 'image_input.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, this.imageFile, required this.ip});
  final File? imageFile;
  final String ip;
  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool isLoading = true;
  String jsonObj = "";
  String fileName = "";
  bool isDownloaded = false;
  bool displayWarning = false;

  Future<void> getJsonReceipt() async {
    String apiEndpoint = "http://" + widget.ip + "/generateJSON";
    var request = http.MultipartRequest('POST', Uri.parse(apiEndpoint));
    request.files
        .add(await http.MultipartFile.fromPath('bill', widget.imageFile!.path));
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    var jsonResponse = json.decode(responseBody);
    setState(() {
      isLoading = false;
      jsonObj = jsonResponse['Response'];
      fileName = jsonResponse['Title'];
      if (jsonObj == "Sorry i can't find a bill receipt in the image!") {
        setState(() {
          displayWarning = true;
        });
      }
    });
  }

  Future<String> saveFile(String fileName, String content) async {
    const applicationDocumentDirectory = "/storage/emulated/0/Download/";
    final File file = File('$applicationDocumentDirectory/$fileName');

    // Write the file
    await file.writeAsString(content);

    // Check if the file was successfully saved
    if (await file.exists()) {
      return file.path;
    } else {
      return ''; // Return an empty string or handle error accordingly
    }
  }

  @override
  void initState() {
    getJsonReceipt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? SpinKitWave(
              color: Colors.teal,
            )
          : Stack(
              children: [
                Positioned(
                    top: 20,
                    left: 20,
                    child: IconButton(
                        onPressed: () {
                          Get.offAll(const ImageInput());
                        },
                        icon: const Icon(
                          color: Colors.black,
                          Icons.arrow_back,
                          size: 30,
                        ))),
                Center(
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
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                displayWarning
                                    ? const Column(
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            size: 130,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      )
                                    : const Text(""),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Text(
                                      jsonObj,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: displayWarning
                            ? const Text("")
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isDownloaded = true;
                                      });
                                      saveFile(fileName, jsonObj);

                                      showSnackBar(
                                          "File downloaded successfully at",
                                          "/storage/emulated/0/Download/$fileName");
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black),
                                    child: const Text(
                                      "Download",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (isDownloaded) {
                                        XFile file = XFile(
                                            "/storage/emulated/0/Download/$fileName");
                                        Share.shareXFiles([file],
                                            text: fileName);
                                      } else {
                                        showSnackBar("File not found",
                                            "Please make sure to download the file once!");
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black),
                                    child: const Text(
                                      "Share",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void showSnackBar(String? errorMessage1, String errorMessage2) {
    Get.snackbar(
      backgroundColor: Colors.black,
      colorText: Colors.white,
      errorMessage1!,
      errorMessage2,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10), //
    );
  }
}
