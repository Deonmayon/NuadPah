import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/adminManageNav.dart';

class UserManagePage extends StatefulWidget {
  const UserManagePage({Key? key}) : super(key: key);

  @override
  State<UserManagePage> createState() =>
      _UserManagePageState();
}

class _UserManagePageState extends State<UserManagePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();

  //table custom
  int currentPage = 1;
  final int totalPages = 251;
  final List<Map<String, String>> massageData = List.generate(8, (index) {
    return {
      "image":
          "https://picsum.photos/200?random=${index + 1}", // ใช้ภาพตัวอย่างแบบสุ่ม
      "name": "Esther Howard",
      "email": "esther@gmail.com",
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Edit User - ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          Text(
                            'Esther Howard',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                              color: Color(0xFF676767),
                            ),
                          ),
                        ],
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'First Name',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            hintText: 'Esther',
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF676767),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Last Name',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            hintText: 'Howard',
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF676767),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Email',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'esther@gmail.com',
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
                              const SizedBox(height: 10),
                              Text(
                                'Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'Password',
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
                        const SizedBox(width: 16),
                        Container(
                          width: 150,
                          height: 159,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFF676767),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              '250x250',
                              style: TextStyle(
                                color: Color(0xFF676767),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
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
                        'EDIT USER',
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

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                width: 372,
                height: 588,
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
                                height: 61,
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
                                      ClipOval(
                                        child: Image.network(
                                          item["image"]!,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // ข้อมูลข้อความ
                                      SizedBox(
                                        width: 255,
                                        height: 40,
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
                                            Text(
                                              item["email"]!,
                                              style: const TextStyle(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF676767),
                                                fontSize: 12,
                                              ),
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
    );
  }
}
