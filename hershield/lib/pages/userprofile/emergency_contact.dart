import 'package:backend_shield/apis/auth/user_auth.dart';
import 'package:backend_shield/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hershield/pages/userprofile/onboard_form.dart';
import 'package:hershield/pages/userprofile/user_controller.dart';
import 'package:hershield/router.dart';

class EmergencyContactForm extends StatefulWidget {
  const EmergencyContactForm({super.key});

  @override
  _EmergencyContactFormState createState() => _EmergencyContactFormState();
}

class _EmergencyContactFormState extends State<EmergencyContactForm> {
  int? _validContactsCount;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  void _submitForm() async {
    List<String>? validContacts = TextControl.phoneControllers
        .where((controller) => controller.text.isNotEmpty)
        .where((controller) {
          final regex = RegExp(r'^[0-9]{10}$');
          return regex.hasMatch(controller.text);
        })
        .map((controller) => controller.text)
        .toList();

    if (validContacts.length >= 3) {
      HSUser user = HSUser(emergencyContact: validContacts);

      await HSUserController.updateUser(
        user: user,
        userId: HSUserAuthSDK.getUser()!.uid,
      );
      context.goNamed(RouteNames.sos);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Emergency contacts saved successfully!'),
      ));
    } else {
      if (_formKey.currentState?.validate() ?? false) {}
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter at least 3 valid contacts'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'Add Emergency Contacts',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    for (int i = 0; i < 5; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          controller: TextControl.phoneControllers[i],
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.phone_android),
                            labelText: "Phone Number ${i + 1}",
                            prefixText: "+91 ",
                            hintText: "Enter your Trusted Contact",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.cancel, size: 20),
                              onPressed: () {
                                setState(() {
                                  TextControl.phoneControllers[i].text = '';
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'Please enter a phone number';
                            }
                            final regex = RegExp(r'^[0-9]{10}$');
                            if (!regex.hasMatch(value!)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _validContactsCount = TextControl.phoneControllers
                                  .where((controller) =>
                                      controller.text.isNotEmpty)
                                  .length;
                            });
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            _submitForm();
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(fontSize: 16),
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
    );
  }
}
