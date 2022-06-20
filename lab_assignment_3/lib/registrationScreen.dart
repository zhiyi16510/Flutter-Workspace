import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:lab_assignment_2/constants.dart';
import 'package:lab_assignment_2/loginScreen.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late double screenHeight, screenWidth, ctrwidth;
  String pathAsset = 'assets/images/camera.png';
  var _image;
  bool passwordVisible = true;
  bool passwordVisible2 = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordController2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth;
    }
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: ctrwidth,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 40, 32, 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          height: screenHeight / 4,
                          width: screenWidth,
                          child: Image.asset('assets/images/4.png')),
                      const SizedBox(height: 20),
                      const Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 149, 65, 164)),
                      ),
                      const SizedBox(height: 5),
                      Card(
                        child: GestureDetector(
                            onTap: () => {_takePictureDialog()},
                            child: SizedBox(
                                height: screenHeight / 3,
                                width: screenWidth,
                                child: _image == null
                                    ? Image.asset(pathAsset)
                                    : Image.file(
                                        _image,
                                        fit: BoxFit.cover,
                                      ))),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              labelText: "Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your name";
                            }
                            if (value.length < 6) {
                              return "Name should be longer than 6";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              labelText: "Email",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a valid email";
                            }
                            bool nameValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value);

                            if (!nameValid) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.phone),
                              labelText: "Phone number",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a valid phone number";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.home),
                              labelText: "Home address",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a valid home address";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: passwordVisible,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              labelText: "Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            if (value.length < 5) {
                              return "Password must be at least 5 characters";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextFormField(
                          controller: passwordController2,
                          obscureText: passwordVisible2,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              labelText: "Re-enter your Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisible2
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisible2 = !passwordVisible2;
                                  });
                                },
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            if (value != passwordController.text) {
                              return "Password does not match";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: screenWidth,
                          height: 50,
                          child: ElevatedButton(
                            child: const Text("Register"),
                            onPressed: () {
                              _addDialog();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Registered user? ",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 139, 65, 152)),
                          ),
                          GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) => LoginScreen()))
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  _takePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text("Select from",
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _galleryPicker(),
                        },
                    icon: const Icon(Icons.browse_gallery),
                    label: const Text("Gallery",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _cameraPicker(),
                        },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera",
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ));
      },
    );
  }

  _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Color.fromARGB(255, 137, 75, 166),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void _addDialog() {
    if (_formKey.currentState!.validate() && _image != null) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Register a new account",
            ),
            content: const Text("Are you sure?"),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _registerAccount();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _registerAccount() {
    String _name = nameController.text;
    String _email = emailController.text;
    String _phone = phoneController.text;
    String _address = addressController.text;
    String _password = passwordController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());
    FocusScope.of(context).requestFocus(FocusNode());

    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Registering... "), title: const Text("Register"));
    progressDialog.show();

    http.post(Uri.parse(CONSTANTS.server + "/my_tutor/php/register_user.php"),
        body: {
          "email": _email,
          "name": _name,
          "password": _password,
          "phone": _phone,
          "address": _address,
          "image": base64Image,
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Registered Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        Navigator.push(context,
            MaterialPageRoute(builder: (content) => const LoginScreen()));
      } else {
        Fluttertoast.showToast(
            msg: "Registration Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      }
    });
  }
}
