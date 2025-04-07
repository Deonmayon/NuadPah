import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/api/massage.dart';
import 'package:frontend/components/reviewCard.dart';

class SetMassageDetailPage extends StatefulWidget {
  final int massageID;
  final String rating;

  const SetMassageDetailPage(
      {super.key, required this.massageID, required this.rating});

  @override
  State<SetMassageDetailPage> createState() => _SetMassageDetailPageState();
}

class _SetMassageDetailPageState extends State<SetMassageDetailPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _controller = PageController();

  bool isLoading = true;

  int get massageId => widget.massageID;
  String get rating => widget.rating;

  late Map<String, dynamic> detail = {
    'ms_id': 0,
    'mt_ids': <int>[],
    'ms_name': '',
    'ms_types': <String>[],
    'ms_time': 0,
    'ms_detail': '',
    'ms_image_names': <String>[],
    'massageTechniqueDetails': <Map<String, dynamic>>[],
  };

  late List<Map<String, dynamic>> reviews = [
    {
      'rsm_id': 0,
      'image_name': '',
      'firstname': '',
      'lastname': '',
      'rating': 0,
      'detail': '',
      'datetime': '',
    }
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    await fetchSetMassageDetail();
    await fetchSetMassageReviews();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchSetMassageDetail() async {
    final apiService = MassageApiService();

    try {
      final response = await apiService.getSetMassageDetail(massageId);

      setState(() {
        detail = Map<String, dynamic>.from(response.data);
      });
    } catch (e) {
      setState(() {
        print(
            "Error fetching recommend massages: ${e.toString()}"); // Only prints error message
      });
    }
  }

  Future<void> fetchSetMassageReviews() async {
    final apiService = MassageApiService();

    try {
      final response = await apiService.getSetMassageReviews(massageId);

      setState(() {
        // Convert the response data and ensure rating is an integer
        reviews = (response.data as List).map<Map<String, dynamic>>((item) {
          var review = Map<String, dynamic>.from(item);
          // Ensure rating is an integer
          review['rating'] = int.parse(review['rating'].toString());
          return review;
        }).toList();
      });
    } catch (e) {
      print("Error fetching reviews: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Header with image and buttons
                    SizedBox(
                      width: double.infinity,
                      height: 225,
                      child: Stack(
                        children: [
                          PageView(
                            controller: _controller,
                            scrollDirection: Axis.horizontal,
                            children: detail['ms_image_names']
                                .map<Widget>((imageName) {
                              return Image.network(
                                imageName,
                                width: double.infinity,
                                height: 210,
                                fit: BoxFit.cover,
                              );
                            }).toList(),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.arrowLeft,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.solidBookmark,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                debugPrint('Bookmark pressed');
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(192, 161, 114, 1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (detail['ms_image_names'].isNotEmpty)
                                    CircleAvatar(
                                      radius: 12.5,
                                      backgroundImage: NetworkImage(
                                          detail['ms_image_names'][0]),
                                    ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'บริเวณ: ${detail['ms_types'].join(", ")}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const FaIcon(
                                    FontAwesomeIcons.solidClock,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '\u2248 ${detail['ms_time']} นาที',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const FaIcon(
                                    FontAwesomeIcons.solidStar,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$rating / 5',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content Section
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail['ms_name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // จัดให้อยู่กลางในแนวนอน
                            children: [
                              SizedBox(
                                width: 372,
                                height: 40,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(192, 161, 114, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    debugPrint('Learn with AI pressed');
                                  },
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'เรียนรู้ด้วย AI',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      FaIcon(
                                        FontAwesomeIcons.vrCardboard,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Scrollable section
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...detail['massageTechniqueDetails']
                                .map(
                                  (technique) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: ExpandableCard(
                                      title: technique['mt_name'],
                                      imagePath: technique['mt_image_name'],
                                      type: technique['mt_type'],
                                      duration:
                                          "≈ ${technique['mt_time']} นาที",
                                      detail: technique['mt_detail'],
                                    ),
                                  ),
                                )
                                .toList(),
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('คะแนนและรีวิว',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        color: Colors.black,
                                        letterSpacing: 0.0,
                                      )),
                                  SizedBox(height: 10),
                                  // Review Card
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: reviews.map((review) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: ReviewCard(
                                              reviewID: review['rssm_id'],
                                              imageName: review['image_name'],
                                              firstname: review['firstname'],
                                              lastname: review['lastname'],
                                              rating: int.parse(
                                                  review['rating'].toString()),
                                              detail: review['detail'],
                                              datetime: review['datetime'],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class ExpandableCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final String type;
  final String duration;
  final String detail;

  ExpandableCard({
    required this.title,
    required this.imagePath,
    required this.type,
    required this.duration,
    required this.detail,
  });

  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool isExpanded = false;

  String get title => widget.title;
  String get imagePath => widget.imagePath;
  String get type => widget.type;
  String get duration => widget.duration;
  String get detail => widget.detail;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imagePath,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDBDBDB),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "บริเวณ : ${type}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDBDBDB),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  duration,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Color.fromRGBO(192, 161, 114, 1),
                    ),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 8),
                Text(
                  detail,
                  style: TextStyle(color: Colors.black),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

// class ReviewCard extends StatelessWidget {
//   const ReviewCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             children: [
//               CircleAvatar(
//                 radius: 15,
//                 backgroundImage: AssetImage('assets/images/profilePicture.jpg'),
//               ),
//               SizedBox(width: 8),
//               Text(
//                 'Cameron Williamson',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w500,
//                   fontSize: 14,
//                   color: Color.fromRGBO(103, 103, 103, 1),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: List.generate(
//               5,
//               (index) => Padding(
//                 padding:
//                     const EdgeInsets.only(right: 5.0), // ระยะห่างระหว่างไอคอน
//                 child: Icon(
//                   index < 4
//                       ? FontAwesomeIcons.solidStar
//                       : FontAwesomeIcons.star,
//                   color: index < 4
//                       ? const Color.fromRGBO(192, 161, 114, 1)
//                       : Colors.grey,
//                   size: 15,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             'Lorem ipsum dolor sit amet,  occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
//             style: TextStyle(
//               fontWeight: FontWeight.w400,
//               fontSize: 12,
//               color: Color.fromRGBO(103, 103, 103, 1),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
