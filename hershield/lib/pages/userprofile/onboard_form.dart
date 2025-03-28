import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hershield/apis/auth/user_auth.dart';
import 'package:hershield/helper/HS_dob_validator.dart';
import 'package:hershield/helper/log.dart';
import 'package:hershield/models/user_model.dart';
import 'package:hershield/pages/home_controller.dart';
import 'package:hershield/pages/userprofile/emergency_contact.dart';
import 'package:hershield/pages/userprofile/user_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class OnboardingFormView extends StatefulWidget {
  const OnboardingFormView({super.key});

  @override
  State<OnboardingFormView> createState() => _OnboardingFormViewState();
}

class _OnboardingFormViewState extends State<OnboardingFormView>
    with TickerProviderStateMixin {
  // Separate keys for each form
  final _personalDetailsFormKey = GlobalKey<FormState>();

  late TabController tabController =
      TabController(length: 2, vsync: this, initialIndex: 0);
  final HSDobValidator _hsDobValidator = HSDobValidator();

  File? _imageFile;
  bool isLoading = false;
  bool isVerfied = false;

  @override
  void initState() {
    super.initState();
    if (HSProfileController.getProfile()?.id != null) {
      TextControl.populateControllers(HSProfileController.getProfile()!);
    }
    tabController = TabController(length: 2, vsync: this); // 2 tabs
  }

  var defaultImage =
      "https://imgv3.fotor.com/images/blog-cover-image/10-profile-picture-ideas-to-make-you-stand-out.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Onboarding Form",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2,
      ),
      body: TabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Tab(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _personalDetailsFormKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Photo Section
                          Center(
                            child: Stack(
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        TextControl.imageUrl ?? defaultImage,
                                    placeholder: (context, url) => const Center(
                                      child: SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 120,
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
                                          ? const Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
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

                          // First Name
                          TextFormField(
                            controller: TextControl.nameController,
                            decoration: InputDecoration(
                              hintText: 'name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          // Last Name
                          // TextFormField(
                          //   controller: TextControl.lastNameController,
                          //   decoration: InputDecoration(
                          //     hintText: 'Last Name',
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //   ),
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Please enter your last name';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          const SizedBox(height: 10),

                          // Phone Number
                          const PhoneVerificationView(),
                          const SizedBox(height: 10),

                          // Aadhaar Number
                          TextFormField(
                            controller: TextControl.aadharController,
                            decoration: InputDecoration(
                              hintText: 'Aadhar Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Aadhaar number';
                              } else if (TextControl
                                      .aadharController.text.length !=
                                  12) {
                                hsLog(TextControl.aadharController.text.length);
                                return 'Enter Valid Aadhaar';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          // Date of Birth
                          TextFormField(
                            controller: TextControl.dobController,
                            decoration: InputDecoration(
                              hintText: 'Date of Birth',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: IconButton(
                                onPressed: selectedDOB,
                                icon: const Icon(Icons.calendar_today),
                              ),
                            ),
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your date of birth';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          // Gender Selection
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: const Text("Male"),
                                  leading: Radio<String>(
                                    value: "Male",
                                    groupValue: TextControl.selectedGender,
                                    onChanged: (String? value) {
                                      setState(() {
                                        TextControl.selectedGender = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: const Text("Female"),
                                  leading: Radio<String>(
                                    value: "Female",
                                    groupValue: TextControl.selectedGender,
                                    onChanged: (String? value) {
                                      setState(() {
                                        TextControl.selectedGender = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          TabNavigationButtons(
                            tabController: tabController,
                            personalDetailsFormKey: _personalDetailsFormKey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tab(
          //   child: SingleChildScrollView(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         // Logo and Tagline Section at the Top
          //         Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //           child: Column(
          //             children: [
          //               // Tagline Text
          //               Text(
          //                 'HerShield',
          //                 style: TextStyle(
          //                   fontSize: 24,
          //                   fontWeight: FontWeight.bold,
          //                   color: primaryTextColor,
          //                 ),
          //                 textAlign: TextAlign.center,
          //               ),
          //               Text(
          //                 'Help is just a moment away!!',
          //                 style: TextStyle(
          //                   fontSize: 24,
          //                   fontWeight: FontWeight.bold,
          //                   color: primaryTextColor,
          //                 ),
          //                 textAlign: TextAlign.center,
          //               ),
          //               const SizedBox(height: 10),
          //               // Data Safety Information
          //               Text(
          //                 'Your data is secure and handled with utmost care. Rest assured, our shield ensures your information stays private and protected.',
          //                 style: TextStyle(
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.normal,
          //                   color: Theme.of(context).colorScheme.onSurface,
          //                 ),
          //                 textAlign: TextAlign.center,
          //               ),
          //             ],
          //           ),
          //         ),
          //         // The Form Section

          //         Form(
          //           key: _additionalInfoFormKey, // Assign the form key
          //           child: Padding(
          //             padding: const EdgeInsets.all(16.0),
          //             child: Column(
          //               children: [
          //                 // City Input
          //                 TextFormField(
          //                   controller: TextControl.cityController,
          //                   decoration: InputDecoration(
          //                     hintText: 'City',
          //                     border: OutlineInputBorder(
          //                       borderRadius: BorderRadius.circular(
          //                           12), // Rounded corners
          //                     ),
          //                     contentPadding: const EdgeInsets.symmetric(
          //                         vertical: 15, horizontal: 10),
          //                     filled: true,
          //                   ),
          //                   validator: (value) {
          //                     if (value == null || value.isEmpty) {
          //                       return 'Please enter your city';
          //                     }
          //                     return null;
          //                   },
          //                 ),
          //                 const SizedBox(height: 15),
          //                 // State Input
          //                 TextFormField(
          //                   controller: TextControl.stateController,
          //                   decoration: InputDecoration(
          //                     hintText: 'State',
          //                     border: OutlineInputBorder(
          //                       borderRadius: BorderRadius.circular(12),
          //                     ),
          //                     contentPadding: const EdgeInsets.symmetric(
          //                         vertical: 15, horizontal: 10),
          //                     filled: true,
          //                   ),
          //                   validator: (value) {
          //                     if (value == null || value.isEmpty) {
          //                       return 'Please enter your state';
          //                     }
          //                     return null;
          //                   },
          //                 ),
          //                 const SizedBox(height: 15),
          //                 // Country Input
          //                 TextFormField(
          //                   controller: TextControl.countryController,
          //                   decoration: InputDecoration(
          //                     hintText: 'Country',
          //                     border: OutlineInputBorder(
          //                       borderRadius: BorderRadius.circular(12),
          //                     ),
          //                     contentPadding: const EdgeInsets.symmetric(
          //                         vertical: 15, horizontal: 10),
          //                     filled: true,
          //                   ),
          //                   validator: (value) {
          //                     if (value == null || value.isEmpty) {
          //                       return 'Please enter your country';
          //                     }
          //                     return null;
          //                   },
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         TabNavigationButtons(
          //           tabController: tabController,
          //           additionalInfoFormKey: _additionalInfoFormKey,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          const Tab(
            child: EmergencyContactForm(),
          ),
        ],
      ),
    );
  }

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
                    // ignore: use_build_context_synchronously
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
                                  controller: TextControl.urlController,
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
                                          TextControl.imageUrl =
                                              TextControl.urlController.text;
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
      hsLog('Error: $e');
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
          .child(path.basename(img.path));

      final uploadTask = ref.putFile(img);
      await uploadTask;
      final downloadURL = await ref.getDownloadURL();

      setState(() {
        TextControl.imageUrl = downloadURL;
      });
    } catch (e) {
      hsLog('Failed to upload image: $e');
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
    var dob = await _hsDobValidator.selectDOB(
        context, TextControl.dateOfBirth ?? DateTime.now());
    if (dob != null && dob != DateTime.now()) {
      setState(() {
        TextControl.dateOfBirth = dob;
        TextControl.dobController.text =
            DateFormat("MM/dd/yyy").format(TextControl.dateOfBirth!);
      });
    }
  }
}

class TextControl {
  static final TextEditingController urlController = TextEditingController();
  static final TextEditingController nameController = TextEditingController();
  static final TextEditingController aadharController = TextEditingController();
  static final TextEditingController dobController = TextEditingController();
  static final TextEditingController cityController = TextEditingController();
  static final TextEditingController stateController = TextEditingController();
  static final TextEditingController countryController =
      TextEditingController();
  static final TextEditingController mobileController = TextEditingController();
  static final TextEditingController otpController = TextEditingController();
  static final phoneControllers =
      List.generate(5, (_) => TextEditingController());
  static String selectedGender = "Male";
  static String? imageUrl;
  static DateTime? dateOfBirth;

  /// Populates the controllers using an HSUser instance
  static void populateControllers(HSUser user) {
    nameController.text = user.name ?? '';
    mobileController.text = user.mobileNo ?? '';
    aadharController.text = user.aadharCard ?? '';
    dobController.text = user.dateOfBirth != null
        ? DateFormat("MM/dd/yyyy").format(user.dateOfBirth!)
        : '';
    selectedGender = user.gender ?? 'Male'; // Default to Male if not set
    imageUrl = user.profileImage;
  }

  /// Clears all controllers
  static void dispose() {
    urlController.dispose();
    nameController.dispose();
    aadharController.dispose();
    dobController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    mobileController.dispose();
    for (var controller in TextControl.phoneControllers) {
      controller.dispose();
    }
    otpController.dispose();
  }
}

class PhoneVerificationView extends StatefulWidget {
  const PhoneVerificationView({super.key});

  @override
  State<PhoneVerificationView> createState() => _PhoneVerificationViewState();
}

class _PhoneVerificationViewState extends State<PhoneVerificationView> {
  bool otpSent = false;
  bool otpVerified = false;
  String? _phoneError;

  void _sendOTP() {
    setState(() {
      otpSent = true; // Show OTP input field
    });

    // Show bottom modal sheet for OTP input
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextControl.otpController,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  hintText: 'Enter the OTP sent to your phone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Trigger OTP verification logic here
                  setState(() {
                    otpVerified = true; // Mark OTP as verified
                  });
                  Navigator.pop(context); // Close the modal
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row with Phone Number Input and Send OTP Button
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: TextControl.mobileController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter phone number',
                  errorText: _phoneError, // Display error text if any
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      otpVerified ? Icons.check_circle : Icons.sms,
                      color: otpVerified ? Colors.green : null,
                    ),
                    onPressed: () {
                      if (TextControl.mobileController.text.length != 10) {
                        // Update the error state if the phone number is invalid
                        setState(() {
                          _phoneError = 'Enter Valid No.';
                        });
                      } else {
                        setState(() {
                          _phoneError = null;
                        });
                        _sendOTP();
                      }
                    },
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),

        // Show OTP Input and Verify OTP Button (if OTP is sent)
        if (otpVerified)
          const Text(
            'OTP Verified!',
            style: TextStyle(color: Colors.green),
          ),
      ],
    );
  }
}

class TabNavigationButtons extends StatefulWidget {
  final TabController tabController;
  final GlobalKey<FormState>? personalDetailsFormKey;
  final GlobalKey<FormState>? additionalInfoFormKey;

  const TabNavigationButtons({
    super.key,
    required this.tabController,
    this.additionalInfoFormKey,
    this.personalDetailsFormKey,
  });

  @override
  _TabNavigationButtonsState createState() => _TabNavigationButtonsState();
}

class _TabNavigationButtonsState extends State<TabNavigationButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Center the buttons
      children: [
        // Back Button
        // TextButton(
        //   onPressed: () {
        //     if (widget.tabController.index > 0) {
        //       widget.tabController.animateTo(
        //         widget.tabController.index - 1,
        //         duration: const Duration(milliseconds: 200),
        //       );
        //     }
        //   },
        //   child: const Text(
        //     "Back",
        //     style: TextStyle(fontSize: 16),
        //   ),
        // ),
        //: const SizedBox.shrink(),
        const SizedBox(width: 20), // Add space between buttons
        // Next Button
        TextButton(
          onPressed: () {
            if (widget.tabController.index == 0 &&
                widget.personalDetailsFormKey!.currentState!.validate()) {
              widget.tabController.animateTo(
                widget.tabController.index + 1,
                duration: const Duration(milliseconds: 200),
              );
            }
            saveUserDetails();
          },
          child: const Text(
            "Next",
            style: TextStyle(fontSize: 16),
          ),
        )
        // : const SizedBox.shrink(),
      ],
    );
  }

  Future<void> saveUserDetails() async {
    HSUser user = HSUser(
      id: HSUserAuthSDK.getUser()!.uid,
      name: TextControl.nameController.text,
      aadharCard: TextControl.aadharController.text,
      email: HSUserAuthSDK.getUser()!.email,
      dateOfBirth: TextControl.dateOfBirth,
      gender: TextControl.selectedGender,
      mobileNo: TextControl.mobileController.text,
      profileImage: TextControl.imageUrl,
    );

    await HSUserController.updateUser(
            user: user, userId: HSUserAuthSDK.getUser()!.uid)
        .then((v) => {hsLog("User Updated Succesfully")});
  }
}
