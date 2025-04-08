import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpState();
}

class _HelpState extends State<HelpPage> {
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();
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
              'ช่วยเหลือ',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 372,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 15,
                      color: Color(0x3F000000),
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: Color(0xFFB1B1B1),
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextFormField(
                          controller: textController,
                          focusNode: textFieldFocusNode,
                          decoration: InputDecoration(
                            hintText: 'ค้นหาคำถามที่คุณสงสัย',
                            hintStyle: const TextStyle(
                             
                              color: Color(0xFFB1B1B1),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'คำถามที่พบบ่อย',
                  style: TextStyle(
                    
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ExpandableCard(title: "How to Jookroo Jookroo"),
            ),
          ],
        ),
      ),
    );
  }
}


class ExpandableCard extends StatefulWidget {
  final String title;
  ExpandableCard({required this.title});

  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(isExpanded ? Icons.remove : Icons.add),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                style: TextStyle(color: Colors.black54),
              ),
            ),
        ],
      ),
    );
  }
}