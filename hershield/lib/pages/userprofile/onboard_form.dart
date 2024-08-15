import 'dart:io';
import 'package:backend_shield/apis/auth/user_auth.dart';
import 'package:backend_shield/helper/loader.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:backend_shield/helper/HS_dob_validator.dart';

class OnboardingFormView extends StatefulWidget {
  const OnboardingFormView({super.key});

  @override
  State<OnboardingFormView> createState() => _OnboardingFormViewState();
}

class _OnboardingFormViewState extends State<OnboardingFormView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final HSDobValidator _hsDobValidator = HSDobValidator();
  final HSUserAuthSDK _hsUserAuthSDK = HSUserAuthSDK();
  String? _imageUrl;
  File? _imageFile;
  DateTime? dateOfBirth;

  Future<void> _openImagePicker(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });

      File? img;
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from gallery'),
                  onTap: () async {
                    img = await _pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.link),
                  title: const Text('Upload from link'),
                  onTap: () async {
                    Navigator.pop(context);
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  'Upload from link',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _urlController,
                                  decoration: const InputDecoration(
                                      hintText: 'Enter image URL'),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Upload'),
                                      onPressed: () {
                                        setState(() {
                                          _imageUrl = _urlController.text;
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      );

      // Check if an image was picked and upload it to Firebase
      if (img != null) {
        await _uploadImageToFirebase(img!);
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      // Reset isLoading to false once the process is complete
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _uploadImageToFirebase(File img) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images')
          .child('${Path.basename(img.path)}');

      final uploadTask = ref.putFile(img);
      await uploadTask;
      final downloadURL = await ref.getDownloadURL();

      setState(() {
        _imageUrl = downloadURL;
      });
    } catch (e) {
      print('Failed to upload image: $e');
    }
  }

  Future<File?> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: source);
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
        return _imageFile;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> selectedDOB() async {
    var dob =
        await _hsDobValidator.selectDOB(context, dateOfBirth ?? DateTime.now());
    if (dob != null && dob != DateTime.now()) {
      setState(() {
        dateOfBirth = dob;
        _dobController.text = DateFormat("MM/dd/yyy").format(dateOfBirth!);
      });
    }
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Onboarding Form",
          textAlign: TextAlign.center,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Photo Section
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: FadeInImage(
                                placeholder: NetworkImage('https://imgv3.fotor.com/images/blog-cover-image/10-profile-picture-ideas-to-make-you-stand-out.jpg'), // Path to your placeholder image
                                image: _imageUrl != null
                                    ? NetworkImage(_imageUrl!)
                                    : const NetworkImage('https://imgv3.fotor.com/images/blog-cover-image/10-profile-picture-ideas-to-make-you-stand-out.jpg'),
                                fit: BoxFit.cover,
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return const Image(
                                    image: NetworkImage('https://imgv3.fotor.com/images/blog-cover-image/10-profile-picture-ideas-to-make-you-stand-out.jpg'), // Path to an error image if the network image fails
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () async {
                              await _openImagePicker(context);
                            },
                            child: CircleAvatar(
                              key: ValueKey(isLoading),
                              backgroundColor: Colors.blue,
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Personal Details Section
                  const Text(
                    'Personal Details',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                      hintText: 'User Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'MM/DD/YY',
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onTap: () async {
                      if (_hsUserAuthSDK.getUser() != null) {
                        await selectedDOB();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  // Address Details Section
                  const Text(
                    'Address Details',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      hintText: 'City',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(
                      hintText: 'State',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _countryController,
                    decoration: const InputDecoration(
                      hintText: 'Country',
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {},
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
