import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/HomeButtomNavigationBar.dart';
import 'package:frontend/components/massagecardSmall.dart';
import 'package:frontend/components/massagecardSet.dart';
import '../../api/massage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  State<LearnPage> createState() => _LearnState();
}

class _LearnState extends State<LearnPage> {
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();
  int _selectedTab = 0;

  List<dynamic> singleMassages = [];
  List<dynamic> setMassages = [];
  List<dynamic> filteredSingleMassages = [];
  List<dynamic> filteredSetMassages = [];

  String selectedTime = "Please select";
  final List<String> timeOptions = [
    "5 minutes",
    "10 minutes",
    "15 minutes",
    "30 minutes",
    "1 hour"
  ];

  String selectedType = "Please select";
  final List<String> typeOptions = [
    "back",
    "neck",
    "shoulder",
    "arms",
  ];

  @override
  void initState() {
    super.initState();
    Future.wait([fetchSingleMassages()]);
    Future.wait([fetchSetMassages()]);
    textController.addListener(_handleSearch);
  }

  Future<void> fetchSingleMassages() async {
    final apiService = MassageApiService();

    try {
      final response = await apiService.getAllMassages();

      setState(() {
        singleMassages = response.data as List;
        filteredSingleMassages = singleMassages;
      });
    } catch (e) {
      setState(() {
        print(
            "Error fetching massages: ${e.toString()}"); // Only prints error message
      });
    }
  }

  Future<void> fetchSetMassages() async {
    final apiService = MassageApiService();

    try {
      final response = await apiService.getAllSetMassages();

      setState(() {
        setMassages = response.data as List;
        filteredSetMassages = setMassages;
      });
    } catch (e) {
      setState(() {
        print(
            "Error fetching massages: ${e.toString()}"); // Only prints error message
      });
    }
  }

  void _handleSearch() {
    final query = textController.text.toLowerCase();
    setState(() {
      if (_selectedTab == 0) {
        filteredSingleMassages = singleMassages.where((massage) {
          final name = (massage['mt_name'] ?? '').toString().toLowerCase();
          final type = (massage['mt_type'] ?? '').toString().toLowerCase();
          return name.contains(query) || type.contains(query);
        }).toList();
      } else {
        filteredSetMassages = setMassages.where((massage) {
          final name = (massage['ms_name'] ?? '').toString().toLowerCase();
          final types =
              (massage['ms_types'] as List<dynamic>? ?? []).join(' ').toLowerCase();
          return name.contains(query) || types.contains(query);
        }).toList();
      }
    });
  }

  Future<String?> _showTimePicker() async {
    return await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: timeOptions.map((option) {
                  return Column(
                    children: [
                      ListTile(
                        title:
                            Text(option, style: const TextStyle(fontSize: 14)),
                        onTap: () {
                          setModalState(() {
                            selectedTime = option; // ✅ อัปเดตค่าใน Modal
                          });

                          Navigator.pop(
                              context, option); // ✅ ปิด Modal พร้อมส่งค่ากลับ
                        },
                      ),
                      Divider(height: 1, color: Color(0xFFB1B1B1)),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  Future<String?> _showTypePicker() async {
    return await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: typeOptions.map((option) {
                  return Column(
                    children: [
                      ListTile(
                        title:
                            Text(option, style: const TextStyle(fontSize: 14)),
                        onTap: () {
                          setModalState(() {
                            selectedType = option; // ✅ อัปเดตค่าใน Modal
                          });

                          Navigator.pop(
                              context, option); // ✅ ปิด Modal พร้อมส่งค่ากลับ
                        },
                      ),
                      Divider(height: 1, color: Color(0xFFB1B1B1)),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  void _applyFilters() {
    setState(() {
      if (_selectedTab == 0) {
        filteredSingleMassages = singleMassages.where((massage) {
          bool matchesTime =
              selectedTime == "Please select" || massage['mt_time'] == selectedTime;
          bool matchesType =
              selectedType == "Please select" || massage['mt_type'] == selectedType;
          return matchesTime && matchesType;
        }).toList();
      } else {
        filteredSetMassages = setMassages.where((massage) {
          bool matchesTime = selectedTime == "Please select" ||
              massage['ms_time'].toString() == selectedTime;
          bool matchesType = selectedType == "Please select" ||
              (massage['ms_types'] as List<dynamic>).contains(selectedType);
          return matchesTime && matchesType;
        }).toList();
      }
      Navigator.pop(context);
    });
  }

  void showFilterPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFDBDBDB),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                width: double.infinity,
                color: const Color(0xFFDBDBDB),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      height: 55,
                      decoration: const BoxDecoration(color: Color(0xFFDBDBDB)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 20),
                            const Text(
                              'กรองการค้นหา',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 15,
                              color: Color(0x3F000000),
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InkWell(
                            onTap: () async {
                              String? time = await _showTimePicker();
                              if (time != null) {
                                setModalState(() {
                                  selectedTime = time; // ✅ อัปเดตค่าให้ Modal
                                });
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "ระยะเวลา",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      selectedTime,
                                      style: TextStyle(
                                        color: selectedTime == "Please select"
                                            ? Color(0xFFB1B1B1)
                                            : Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                      color: Color(0xFF000000),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 15,
                              color: Color(0x3F000000),
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InkWell(
                            onTap: () async {
                              String? type = await _showTypePicker();
                              if (type != null) {
                                setModalState(() {
                                  selectedType = type; // ✅ อัปเดตค่าให้ Modal
                                });
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "ประเภท",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      selectedType,
                                      style: TextStyle(
                                        color: selectedTime == "Please select"
                                            ? Color(0xFFB1B1B1)
                                            : Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                      color: Color(0xFF000000),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Apply Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GestureDetector(
                        onTap: _applyFilters,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(192, 161, 114, 1),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 15,
                                color: Color(0x3F000000),
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: const Text(
                              "APPLY",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'เรียนรู้การนวด',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
        elevation: 1,
        toolbarHeight: 70,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  _buildTabButton('ท่านวดเดี่ยว', 0),
                  _buildTabButton('เซ็ตท่านวด', 1),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                            hintText: 'ค้นหาท่านวดที่คุณต้องการ',
                            hintStyle: const TextStyle(
                              fontFamily: 'Roboto',
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
                    GestureDetector(
                      onTap:
                          showFilterPopup, // ฟังก์ชันที่ต้องการให้ทำงานเมื่อกด
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          color: Color(0xFFC0A172),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.list,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // แสดงผลตามแท็บที่เลือก
            Expanded(
              child: _selectedTab == 0
                  ? SingleMassageTab(massages: filteredSingleMassages)
                  : SetOfMassageTab(massages: filteredSetMassages),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        initialIndex: 1, // หน้าแรกเริ่มที่ Home
        onTap: (index) {},
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          width: 186,
          height: 52,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: isSelected ? Color(0xFFC0A172) : Colors.white,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.black : Color(0xFFB1B1B1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.removeListener(_handleSearch);
    textController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }
}

class SingleMassageTab extends StatelessWidget {
  final List<dynamic> massages;

  const SingleMassageTab({required this.massages});

  @override
  Widget build(BuildContext context) {
    if (massages.isEmpty) {
      return const Center(
        child: Text(
          'ไม่พบท่านวดที่คุณค้นหา',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Color(0xFFB1B1B1),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: massages.length,
      itemBuilder: (context, index) {
        final massage = massages[index];
        return MassageCard(
          mt_id: massage['mt_id'] ?? 0,
          // image: massage['mt_image_name'] ??
          //     'https://picsum.photos/seed/picsum/200/300',
          image: 'https://picsum.photos/seed/picsum/200/300',
          name: massage['mt_name'] ?? 'Unknown Massage',
          detail: massage['mt_detail'] ?? 'No description available.',
          type: massage['mt_type'] ?? 'Unknown Type',
          time: massage['mt_time'] ?? 'Unknown Duration',
          onFavoriteChanged: (isFavorite) {
            print('Massage favorited: $isFavorite');
          },
        );
      },
    );
  }
}

class SetOfMassageTab extends StatelessWidget {
  final List<dynamic> massages;

  const SetOfMassageTab({required this.massages});

  @override
  Widget build(BuildContext context) {
    if (massages.isEmpty) {
      return const Center(
        child: Text(
          'ไม่พบเซ็ตท่านวดที่คุณค้นหา',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Color(0xFFB1B1B1),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: massages.length,
      itemBuilder: (context, index) {
        final massage = massages[index];
        final imageNames = massage['ms_image_names'] as List<dynamic>? ?? [];

        return MassageCardSet(
          ms_id: (massage['ms_id'] ?? 0) as int,
          title: (massage['ms_name'] ?? 'Unknown Title') as String,
          description:
              (massage['ms_detail'] ?? 'No description available.') as String,
          types: (massage['ms_types'] as List<dynamic>? ?? []).cast<String>(),
          duration: (massage['ms_time'] ?? 0) as int,
          // imageUrl1: imageNames.isNotEmpty
          //     ? imageNames[0] as String
          //     : 'https://picsum.photos/seed/default1/200/300',
          // imageUrl2: imageNames.length > 1
          //     ? imageNames[1] as String
          //     : 'https://picsum.photos/seed/default2/200/300',
          // imageUrl3: imageNames.length > 2
          //     ? imageNames[2] as String
          //     : 'https://picsum.photos/seed/default3/200/300',
          imageUrl1: 'https://picsum.photos/seed/picsum/200/300',
          imageUrl2: 'https://picsum.photos/seed/picsum/200/300',
          imageUrl3: 'https://picsum.photos/seed/picsum/200/300',
          onFavoriteChanged: (isFavorite) {
            // Replace with a logging framework or remove in production
          },
        );
      },
    );
  }
}
