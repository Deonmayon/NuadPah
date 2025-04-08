import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/api/auth.dart';
import 'package:frontend/components/profileFunctionBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AccountdetailsPage extends StatefulWidget {
  const AccountdetailsPage({super.key});

  @override
  State<AccountdetailsPage> createState() => _AccountdetailsPageState();
}

class _AccountdetailsPageState extends State<AccountdetailsPage> {
  bool isLoading = true;
  bool isSaving = false;
  String firstName = '';
  String lastName = '';
  XFile? _temporaryImage;

  Map<String, dynamic> userData = {
    'email': '',
    'first_name': '',
    'last_name': '',
    'image_name': '',
    'role': '',
  };

  String userEmail = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true; // Set loading state to true before fetching
    });

    await getUserData();

    setState(() {
      isLoading = false; // Set loading state to false after all data is fetched
    });
  }

  // Fetch user data from local storage
  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedUserData = prefs.getString('userData');
    final decodedUserData = cachedUserData != null
        ? jsonDecode(cachedUserData)
        : {
            'email': '',
            'first_name': '',
            'last_name': '',
            'image_name': '',
            'role': '',
          };
    setState(() {
      userData = decodedUserData;
      userEmail = decodedUserData['email'];
    });
  }

  Future<void> updateUserData() async {
    setState(() {
      isSaving = true;
    });

    final apiService = AuthApiService();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint("Token is null, user not logged in.");
      return;
    }

    try {
      await apiService.updateUserData(
        userData['id'] ?? 0,
        userData['email'],
        '', // empty password means no password change
        firstName.isEmpty ? userData['firstname'] : firstName,
        lastName.isEmpty ? userData['lastname'] : lastName,
        userData['image_name'],
      );

      // Refresh user data
      await loadData();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      // Navigate to profile page after successful update
      Navigator.pushReplacementNamed(context, '/profile');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  Future<void> _updateProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _temporaryImage = image;
      isLoading = true;
    });

    try {
      final apiService = AuthApiService();
      debugPrint('Attempting to upload image from path: ${image.path}');

      final response = await apiService.sendImageToSupabase(image.path);
      debugPrint('Raw Supabase response: ${response.toString()}');
      debugPrint('Response data: ${response.data}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.data != null) {
        String imageUrl = response.data;
        debugPrint(
            'Image uploaded successfully. URL: $imageUrl'); // Add debug log
        // Update the userData map first
        setState(() {
          userData['image_name'] = imageUrl;
        });

        // Then update the backend
        await apiService.updateUserData(
          userData['userid'] ?? 0, // Change from 'id' to 'userid'
          userData['email'],
          '', // empty password means no password change
          userData['firstname'],
          userData['lastname'],
          imageUrl,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to update profile picture: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.arrowLeft,
                  color: Colors.black, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Text(
              'รายละเอียดบัญชี',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 30),
          ],
        ),
        elevation: 1,
        toolbarHeight: 70,
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _temporaryImage != null
                              ? FileImage(File(_temporaryImage!.path))
                              : NetworkImage('${userData['image_name']}')
                                  as ImageProvider,
                          // : NetworkImage('https://picsum.photos/seed/picsum/200/300') as ImageProvider,
                        ),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            EditableField(
                              label: "First name",
                              initialValue: '${userData['firstname']}',
                              onChanged: (value) => firstName = value,
                            ),
                            SizedBox(height: 5),
                            EditableField(
                              label: "Last name",
                              initialValue: '${userData['lastname']}',
                              onChanged: (value) => lastName = value,
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: isSaving ? null : updateUserData,
                              child: isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Save Changes'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      ProfileFunctionBar(
                        icon: Icons.person,
                        title: 'แก้ไขรูปภาพโปรไฟล์',
                        onTap: _updateProfilePicture,
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class EditableField extends StatefulWidget {
  final String label;
  final String initialValue;
  final Function(String) onChanged;

  const EditableField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<EditableField> createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Color(0xFFDBDBDB),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(fontSize: 12, color: Color(0xFF676767)),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _controller.clear(),
                child: Icon(Icons.close, size: 20, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
