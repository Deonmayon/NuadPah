import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/adminManageNav.dart';
import 'package:frontend/components/DashedBorderContainer.dart';

class SetOfMassageManagePage extends StatefulWidget {
  const SetOfMassageManagePage({Key? key}) : super(key: key);

  @override
  State<SetOfMassageManagePage> createState() => _SetOfMassageManagePageState();
}

class _SetOfMassageManagePageState extends State<SetOfMassageManagePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();

  String? selectedValue;

  //table custom
  int currentPage = 1;
  final int totalPages = 251;
  final List<Map<String, String>> massageData = List.generate(4, (index) {
    return {
      "image1": "https://picsum.photos/200?random=${index + 1}", // ใช้ภาพตัวอย่างแบบสุ่ม
      "image2": "https://picsum.photos/200?random=${index + 2}",
      "image3": "https://picsum.photos/200?random=${index + 3}",
      "name": "Name Set of Massage",
      "type": "Type: Back, Shoulder, Neck",
      "duration": "15 minutes"
    };
  });

  final List<Map<String, String>> items = [
    {
      "name": "Name Massage 1",
      "image": "https://fastly.picsum.photos/id/611/200/200.jpg?hmac=1Tkz2gFbAArMMLUWylD-8s6PzYgu0sPIdO71hlp9Xs0", // ใส่ URL รูปที่ต้องการ
      "type": "Type: Back",
      "duration": "4 minutes"
    },
    {
      "name": "Name Massage 2",
      "image": "https://fastly.picsum.photos/id/721/200/200.jpg?hmac=QLtStUqefglPXev8bwvDQ34SN-dSYO2_a299oUpbP7g", // ใส่ URL รูปที่ต้องการ
      "type": "Type: Shoulder",
      "duration": "5 minutes"
    },
    {
      "name": "Name Massage 3",
      "image": "https://fastly.picsum.photos/id/586/200/200.jpg?hmac=qCQKBciYy8H3AxcVxnTZLYwXw02r33F5_3E4UmlB8H4", // ใส่ URL รูปที่ต้องการ
      "type": "Type: Neck",
      "duration": "7 minutes"
    },
  ];

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

  void showCreateMassagePopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow height adjustment based on content
      backgroundColor: const Color(
          0xFFDBDBDB), // Transparent background to maintain rounded corners
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20), // Add rounded corners at the top
        ),
      ),
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        child: Container(
          width: double.infinity, // Full width
          color: const Color(0xFFDBDBDB),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjust height based on content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with full-width line
              Container(
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFDBDBDB),
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFF676767),
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Create Set of Massage',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 4, // 60% (3 ส่วน)
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name Set of Massage',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Name Set of Massage',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Color(0xFF676767),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF676767),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF676767),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          flex: 2, // 40% (2 ส่วน)
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Time',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Add Massage',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Color(0xFF676767),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF676767),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF676767),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 4, // 60% (3 ส่วน)
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Type',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Add Massage',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Color(0xFF676767),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF676767),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF676767),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          flex: 2, // 40% (2 ส่วน)
                          child: Column(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Single Massage',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DashedBorderContainer(
                          width: MediaQuery.of(context).size.width,
                          height: 78,
                          selectedValue: selectedValue,
                          items: items,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        DashedBorderContainer(
                          width: MediaQuery.of(context).size.width,
                          height: 78,
                          selectedValue: selectedValue,
                          items: items,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        DashedBorderContainer(
                          width: MediaQuery.of(context).size.width,
                          height: 78,
                          selectedValue: selectedValue,
                          items: items,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        DashedBorderContainer(
                          width: MediaQuery.of(context).size.width,
                          height: 78,
                          selectedValue: selectedValue,
                          items: items,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC0A172),
                        minimumSize: const Size(double.infinity, 50),
                      ).copyWith(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Set border radius here
                          ),
                        ),
                      ),
                      child: const Text(
                        'CREATE',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSelectMassagePopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow height adjustment based on content
      backgroundColor: const Color(
          0xFFDBDBDB), // Transparent background to maintain rounded corners
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20), // Add rounded corners at the top
        ),
      ),
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        child: Container(
          width: double.infinity, // Full width
          color: const Color(0xFFDBDBDB),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjust height based on content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with full-width line
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFFDBDBDB),
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFF676767),
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: showCreateMassagePopup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC0A172),
                        minimumSize: const Size(double.infinity, 50),
                      ).copyWith(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Set border radius here
                          ),
                        ),
                      ),
                      child: const Text(
                        'EDIT SET OF MASSAGE',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF5757),
                        minimumSize: const Size(double.infinity, 50),
                      ).copyWith(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Set border radius here
                          ),
                        ),
                      ),
                      child: const Text(
                        'DELETE',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                height: 532,
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
                                height: 108,
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
                                      Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        clipBehavior: Clip
                                            .hardEdge, // เพิ่ม clipBehavior เพื่อให้ตัดขอบตาม borderRadius
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  child: Image.network(
                                                    item["image1"]!,
                                                    width: 45,
                                                    height: 45,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                ClipRRect(
                                                  child: Image.network(
                                                    item["image2"]!,
                                                    width: 45,
                                                    height: 45,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ClipRRect(
                                              child: Image.network(
                                                item["image3"]!,
                                                width: 90,
                                                height: 45,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(width: 8),
                                      // ข้อมูลข้อความ
                                      SizedBox(
                                        width: 193,
                                        height: 90,
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
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                IntrinsicWidth(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 2,
                                                        horizontal: 5),
                                                    constraints:
                                                        const BoxConstraints(
                                                      minHeight: 20,
                                                      minWidth:
                                                          75, // ค่าขั้นต่ำที่ต้องการ
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFFDBDBDB),
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
                                                ),
                                                const SizedBox(height: 8),
                                                IntrinsicWidth(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 2,
                                                        horizontal: 5),
                                                    constraints:
                                                        const BoxConstraints(
                                                      minWidth:
                                                          164, // ค่าขั้นต่ำที่ต้องการ
                                                      minHeight: 20,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFFDBDBDB),
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
                                          onPressed: showSelectMassagePopup,
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
          onPressed: showCreateMassagePopup,
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
