import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hellofarmer/Screens/errorScreen.dart';
import 'package:hellofarmer/Screens/loader.dart';
import 'package:hellofarmer/services/mlApi.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? _image;
  ImagePicker _picker = ImagePicker();
  Future getImage(ImageSource source) async {
    // ignore: invalid_use_of_visible_for_testing_member
    final pickedFile = await _picker.getImage(source: source);
    if (pickedFile != null) {
      File? cropped = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: 700,
        maxHeight: 700,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.purpleAccent,
            toolbarTitle: 'Crop the image',
            statusBarColor: Colors.transparent,
            backgroundColor: Colors.grey),
      );
      setState(() {
        _image = cropped;
      });
    } else {
      setState(() {
        _image = null;
      });
    }
  }

  bool _isProcessing = false;
  MLApi _mlApi = MLApi();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: double.maxFinite,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: _image == null
                      ? Image.asset(
                          'assets/Images/placeholder.gif',
                          fit: BoxFit.cover,
                        )
                      : GestureDetector(
                          onLongPress: () {
                            setState(() {
                              _image = null;
                            });
                            HapticFeedback.vibrate();
                          },
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  'Hold image to clear the image',
                                  style: TextStyle(
                                    fontSize: 20,
                                    backgroundColor:
                                        Color.fromRGBO(255, 255, 255, 0.6),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurpleAccent)),
                    onPressed: () async {
                      setState(() {
                        _isProcessing = true;
                      });
                      await getImage(ImageSource.camera);
                      setState(() {
                        _isProcessing = false;
                      });
                    },
                    icon: Icon(Icons.camera_alt_outlined),
                    label: Text('Click'),
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurpleAccent)),
                    onPressed: () async {
                      setState(() {
                        _isProcessing = true;
                      });
                      await getImage(ImageSource.gallery);
                      setState(() {
                        _isProcessing = false;
                      });
                    },
                    icon: Icon(Icons.upload_file),
                    label: Text('Select'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  //TODO:predictionApi
                  if (_image != null) {
                    try {
                      setState(() {
                        _isProcessing = true;
                      });
                      var _result = await _mlApi.makePrediction(_image!.path);

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.grey,
                              title: Text(
                                "Results are ready!",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              content: Text(
                                'result : ${_result["result"]}\n\nconfidence : ${_result["confidence"]}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    //TODO: Implement db sync
                                    Navigator.pop(context);
                                  },
                                  child: Text('Sync to DB'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                )
                              ],
                            );
                          });
                    } catch (e) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return Scaffold(
                            body: ErrorScreen(
                              errorMsg: e.toString(),
                            ),
                          );
                        }),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        elevation: 6,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 3),
                        content: Text('Select the image... Stupid!'),
                      ),
                    );
                  }
                  setState(() {
                    _isProcessing = false;
                  });
                },
                icon: Icon(Icons.search_outlined),
                label: Text('Show results'),
              )
            ],
          ),
          (_isProcessing ? LoadingScreen() : Center())
        ],
      ),
    );
  }
}
