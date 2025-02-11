import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/adminManageNav.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../api/massage.dart';


class SingleMassageManagePage extends StatefulWidget {
  const SingleMassageManagePage({Key? key}) : super(key: key);

  @override
  State<SingleMassageManagePage> createState() =>
      _SingleMassageManagePageState();
}

class _SingleMassageManagePageState extends State<SingleMassageManagePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController textController = TextEditingController();
  final TextEditingController _nameMassageController = TextEditingController();
  final TextEditingController _detailMassageController = TextEditingController();
  String? _selectedMassageType;
  String? _selectedMassageTime;
  File? _selectedImage;
  final FocusNode textFieldFocusNode = FocusNode();

  //table custom
  int currentPage = 1;
  final int totalPages = 251;
  List<Map<String, String>> massageData = [];

  @override
  void initState() {
    super.initState();
    _fetchMassageData();
  }

  Future<void> _fetchMassageData() async {
    final apiService = ApiService(baseUrl: 'http://10.0.2.2:3000');
    try {
      final response = await apiService.getAllMassages(); // Assuming you have a MassageApi class with getMassages method
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        setState(() {
          massageData = data.map<Map<String, String>>((item) {
            return {
              "image": item["image"],
              "name": item["name"],
              "type": item["type"],
              "duration": item["duration"]
            };
          }).toList();
        });
      } else {
        // Handle error response
        debugPrint('Error fetching massage data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching massage data: $e');
    }
  }



  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

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
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
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
                          'Create Single Massage',
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
                        Expanded(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                            'Name Massage',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                            controller: _nameMassageController,
                            decoration: InputDecoration(
                              hintText: 'Name Massage',
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
                                  'Type',
                                  style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  constraints: BoxConstraints(
                                  minHeight:
                                    35, // กำหนดความสูงขั้นต่ำ
                                  ),
                                  child: DropdownButtonFormField(
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    hintText: 'Select',
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
                                  items: ['Back', 'Neck', 'Foot']
                                    .map((type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(type,
                                          overflow: TextOverflow
                                            .visible),
                                      ))
                                    .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                    _selectedMassageType = value
                                      as String;// Cast to string
                                    });
                                  },
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
                                  'Time',
                                  style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  constraints: BoxConstraints(
                                  minHeight:
                                    35, // กำหนดความสูงขั้นต่ำ
                                  ),
                                  child: DropdownButtonFormField(
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    hintText: 'Select',
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
                                  items: [
                                    '5 mins',
                                    '10 mins',
                                    '15 mins'
                                  ]
                                    .map((time) => DropdownMenuItem(
                                        value: time,
                                        child: Text(time,
                                          overflow: TextOverflow
                                            .visible),
                                      ))
                                    .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                    _selectedMassageTime = value
                                      as String;// Cast to string
                                    });
                                  },
                                  ),
                                ),
                                ],
                              ),
                              ),
                            ],
                            ),
                          ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Choose Image
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            margin: const EdgeInsets.only(top: 25),
                            width: 130,
                            height: 139,
                            decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFF676767),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            ),
                            child: _selectedImage != null
                            ? Image.file(
                              _selectedImage!,
                              width: 250,
                              height: 250,
                              fit: BoxFit.cover,
                            )
                            : Center(
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
                        ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Massage',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _detailMassageController,
                            decoration: InputDecoration(
                              hintText: 'Explain about massage',
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
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _createMassage,
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
                        'EDIT SINGLE MASSAGE',
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

  // Create massage
  Future<void> _createMassage() async {
    final nameMassage = _nameMassageController.text;
    final detailMassage = _detailMassageController.text;
    final selectedMassageType = _selectedMassageType;
    final selectedMassageTime = _selectedMassageTime;

    if (nameMassage.isEmpty || detailMassage.isEmpty || selectedMassageType == null || selectedMassageTime == null || _selectedImage == null) {
      // Show error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    final apiService = ApiService(baseUrl: 'http://10.0.2.2:3000');
    try {
      final response = await apiService.addMassage(
        nameMassage,
        selectedMassageType,
        1, //ไม่รู้จะใส่อะไร ไม่ได้เก็บ round
        int.parse(selectedMassageTime.replaceAll(' mins', '')),
        detailMassage,
        _selectedImage!.path, // Add the missing argument here
      );

      if (response.statusCode == 201) {
        // Massage created successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Massage created successfully')),
        );
        Navigator.of(context).pop(); // Close the bottom sheet
        _fetchMassageData(); // Refresh the massage data
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating massage: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating massage: $e')),
      );
    }
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

      // Body
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
