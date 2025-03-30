import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/profileFunctionBar.dart';

class AccountdetailsPage extends StatefulWidget {
  const AccountdetailsPage({Key? key}) : super(key: key);

  @override
  State<AccountdetailsPage> createState() => _AccountdetailsPageState();
}

class _AccountdetailsPageState extends State<AccountdetailsPage> {
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
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 30),
          ],
        ),
        elevation: 1,
        toolbarHeight: 70,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage('https://picsum.photos/seed/5/600'),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  EditableField(label: "First name", initialValue: "Jookroo"),
                  SizedBox(height: 5),
                  EditableField(label: "Last name", initialValue: "Oorkooj"),
                ],
              ),
            ),
            SizedBox(height: 40),
            const ProfileFunctionBar(
              icon: Icons.person,
              title: 'แก้ไขรูปภาพโปรไฟล์', 
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

  EditableField({required this.label, required this.initialValue});

  @override
  _EditableFieldState createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
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
