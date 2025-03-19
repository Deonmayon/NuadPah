import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:frontend/pages/favouritepage.dart';
import 'package:frontend/pages/homepage2.dart';
import 'package:frontend/pages/learnpage.dart';
import 'package:frontend/pages/mappage.dart';

class HomeBottomNavigationBar extends StatefulWidget {
  final int initialIndex; // กำหนดค่า index เริ่มต้น
  final Function(int) onTap; // ฟังก์ชัน callback เมื่อเปลี่ยนแท็บ

  const HomeBottomNavigationBar({
    Key? key,
    this.initialIndex = 0,
    required this.onTap,
  }) : super(key: key);

  @override
  _HomeBottomNavigationBarState createState() =>
      _HomeBottomNavigationBarState();
}

class _HomeBottomNavigationBarState extends State<HomeBottomNavigationBar> {
  late int _selectedIndex;

  final List<String> _titles = ['Home', 'Learn', 'Location', 'Bookmark'];
  final List<IconData> _icons = [
    Icons.home,
    Icons.book,
    Icons.location_on,
    Icons.bookmark,
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // กำหนดค่าเริ่มต้น
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(
              top: BorderSide(color: Color(0xFFDBDBDB), width: 5),
            ),
          ),
          child: CurvedNavigationBar(
            backgroundColor: const Color(0xFFDBDBDB),
            color: Colors.white,
            buttonBackgroundColor: const Color(0xFFC0A172),
            height: 45,
            index: _selectedIndex,
            items: _icons.map((iconData) {
              return Icon(
                iconData,
                size: 35,
                color: _selectedIndex == _icons.indexOf(iconData)
                    ? Colors.white
                    : Color(0xFFB1B1B1),
              );
            }).toList(),
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomepageWidget(
                            email: '',
                          )),
                );

                widget.onTap(index);
              }
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LearnPage()),
                );

                widget.onTap(index);
              }
              if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),
                );

                widget.onTap(index);
              }
              if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Favouritepage()),
                );

                widget.onTap(index);
              } // เรียก callback
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: _titles.asMap().entries.map((entry) {
              int idx = entry.key;
              return Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    idx == _selectedIndex ? entry.value : '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Roboto',
                      color: Color(0xFFC0A172),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
