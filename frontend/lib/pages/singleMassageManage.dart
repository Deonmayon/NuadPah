import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/adminManageNav.dart';

class SingleMassageManagePage extends StatefulWidget {
  const SingleMassageManagePage({Key? key}) : super(key: key);

  @override
  State<SingleMassageManagePage> createState() => _SingleMassageManagePageState();
}

class _SingleMassageManagePageState extends State<SingleMassageManagePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();

  //table custom
  int currentPage = 1;
  final int totalPages = 251;
  final List<Map<String, String>> massageData = List.generate(5, (index) {
    return {
      "image":
          "https://picsum.photos/200?random=${index + 1}", // ใช้ภาพตัวอย่างแบบสุ่ม
      "name": "Name Massage",
      "type": "Type: Back",
      "duration": "5 minutes"
    };
  });

  void previousPage() {
    setState(() {
      if (currentPage > 1) currentPage--;
    });
  }

  void nextPage() {
    setState(() {
      if (currentPage < totalPages) currentPage++;
    });
  }

  @override
  void dispose() {
    textController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 1,
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
              'Admin Manage',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 30),
          ],
        ),
        toolbarHeight: 70,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(219, 219, 219, 1),
                width: 1,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AdminManageNav(),
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
                            hintText: 'Search',
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
                    Container(
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
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                width: 372,
                height: 490,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBDBDB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 352,
                          height: 40,
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Color(0xFFDBDBDB), width: 4)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 25, // ความกว้างของปุ่ม
                                height: 25, // ความสูงของปุ่ม
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white, // พื้นหลังของปุ่ม
                                  border: Border.all(
                                      color: const Color(0xFFC0A172),
                                      width: 2), // เส้นขอบ
                                  borderRadius: BorderRadius.circular(
                                      5), // ทำให้เป็นสี่เหลี่ยม
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    size: 15,
                                    color: Color(0xFFC0A172),
                                  ),
                                  onPressed: previousPage,
                                ),
                              ),
                              Text("Page $currentPage of $totalPages"),
                              Container(
                                width: 25, // ความกว้างของปุ่ม
                                height: 25, // ความสูงของปุ่ม
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white, // พื้นหลังของปุ่ม
                                  border: Border.all(
                                      color: const Color(0xFFC0A172),
                                      width: 2), // เส้นขอบ
                                  borderRadius: BorderRadius.circular(
                                      5), // ทำให้เป็นสี่เหลี่ยม
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                    size: 15,
                                    color: Color(0xFFC0A172),
                                  ),
                                  onPressed: nextPage,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: massageData.length,
                            itemBuilder: (context, index) {
                              final item = massageData[index];
                              return Container(
                                width: 352,
                                height: 78,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xFFDBDBDB),
                                      width: 1,
                                    ),
                                    top: BorderSide(
                                      color: Color(0xFFDBDBDB),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      // รูปภาพ
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          item["image"]!,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // ข้อมูลข้อความ
                                      SizedBox(
                                        width: 233,
                                        height: 60,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item["name"]!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 2,
                                                      horizontal: 5),
                                                  constraints:
                                                      const BoxConstraints(
                                                    minWidth: 77,
                                                    minHeight: 20,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFDBDBDB),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Text(
                                                    item["type"]!,
                                                    style: const TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(
                                                    width:
                                                        8), // ระยะห่างระหว่างข้อมูล
                                                Container(
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 2,
                                                      horizontal: 5),
                                                  constraints:
                                                      const BoxConstraints(
                                                    minWidth: 77,
                                                    minHeight: 20,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFDBDBDB),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Text(
                                                    item["duration"]!,
                                                    style: const TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      // ปุ่มเพิ่มเติม
                                      Container(
                                        width: 25, // ความกว้างของปุ่ม
                                        height: 25, // ความสูงของปุ่ม
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color:
                                              Colors.white, // พื้นหลังของปุ่ม
                                          border: Border.all(
                                              color: const Color(0xFFC0A172),
                                              width: 2), // เส้นขอบ
                                          borderRadius: BorderRadius.circular(
                                              5), // ทำให้เป็นสี่เหลี่ยม
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          alignment: Alignment.center,
                                          icon: const Icon(
                                            Icons.more_vert,
                                            size: 15,
                                            color: Color(0xFFC0A172),
                                          ),
                                          onPressed: () {
                                            // การกระทำเมื่อกดปุ่ม
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // แถบควบคุมหน้าตาราง
                        Container(
                          width: 352,
                          height: 40,
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Color(0xFFDBDBDB), width: 4)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 25, // ความกว้างของปุ่ม
                                height: 25, // ความสูงของปุ่ม
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white, // พื้นหลังของปุ่ม
                                  border: Border.all(
                                      color: const Color(0xFFC0A172),
                                      width: 2), // เส้นขอบ
                                  borderRadius: BorderRadius.circular(
                                      5), // ทำให้เป็นสี่เหลี่ยม
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    size: 15,
                                    color: Color(0xFFC0A172),
                                  ),
                                  onPressed: previousPage,
                                ),
                              ),
                              Text("Page $currentPage of $totalPages"),
                              Container(
                                width: 25, // ความกว้างของปุ่ม
                                height: 25, // ความสูงของปุ่ม
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white, // พื้นหลังของปุ่ม
                                  border: Border.all(
                                      color: const Color(0xFFC0A172),
                                      width: 2), // เส้นขอบ
                                  borderRadius: BorderRadius.circular(
                                      5), // ทำให้เป็นสี่เหลี่ยม
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                    size: 15,
                                    color: Color(0xFFC0A172),
                                  ),
                                  onPressed: nextPage,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70, // กำหนดความกว้างของปุ่ม
        height: 70, // กำหนดความสูงของปุ่ม
        child: FloatingActionButton(
          onPressed: () {
            // ทำงานเมื่อกดปุ่ม "+"
          },
          backgroundColor: const Color(0xFFC0A172), // สีปุ่ม
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            size: 40, // ขนาดของไอคอน
            color: Colors.white, // สีของไอคอน
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // ตำแหน่งของปุ่ม
    );
  }
}
