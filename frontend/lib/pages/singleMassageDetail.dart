import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/api/massage.dart';
import 'package:frontend/components/reviewCard.dart';

class SingleMassageDetailPage extends StatefulWidget {
  final int? massageID; // Make nullable

  const SingleMassageDetailPage({
    Key? key,
    this.massageID,
    required String rating, // Remove required
  }) : super(key: key);

  @override
  State<SingleMassageDetailPage> createState() =>
      _SingleMassageDetailPageState();
}

class _SingleMassageDetailPageState extends State<SingleMassageDetailPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;

  int get massageId => widget.massageID ?? 0;

  late Map<String, dynamic> detail = {
    'mt_id': 0,
    'mt_name': '',
    'mt_type': '',
    'mt_round': 0,
    'mt_time': 0,
    'mt_detail': '',
    'mt_image_name': '',
    'avg_rating': '0.0',
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

    await fetchSingleMassageDetail();
    await fetchSingleMassageReviews();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchSingleMassageDetail() async {
    final apiService = MassageApiService();

    try {
      final response = await apiService.getSingleMassageDetail(massageId);

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

  Future<void> fetchSingleMassageReviews() async {
    final apiService = MassageApiService();

    try {
      final response = await apiService.getSingleMassageReviews(massageId);

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
          child: Column(
            children: [
              // Header with image and buttons
              SizedBox(
                width: double.infinity,
                height: 225,
                child: Stack(
                  children: [
                    Image.network(
                      detail['mt_image_name']?.isNotEmpty == true
                          ? detail['mt_image_name']
                          : 'https://dxaytybkoraatubbincp.supabase.co/storage/v1/object/public/nuadpahstorage//user_icon.png',
                      width: double.infinity,
                      height: 210,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade300,
                        child: Icon(Icons.image_not_supported,
                            size: 50, color: Colors.grey),
                      ),
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
                            CircleAvatar(
                              radius: 12.5,
                              backgroundImage: NetworkImage(detail[
                                              'mt_image_name']
                                          ?.isNotEmpty ==
                                      true
                                  ? detail['mt_image_name']
                                  : 'https://dxaytybkoraatubbincp.supabase.co/storage/v1/object/public/nuadpahstorage//user_icon.png'),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'บริเวณ: ${detail['mt_type']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 16),
                            FaIcon(
                              FontAwesomeIcons.solidClock,
                              color: Colors.white,
                              size: 15,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '\u2248 ${detail['mt_time']} นาที',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 16),
                            FaIcon(
                              FontAwesomeIcons.solidStar,
                              color: Colors.white,
                              size: 15,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${detail['avg_rating']?.toString()} / 5',
                              style: TextStyle(
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
                      detail['mt_name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Text(
                      detail['mt_detail'],
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(103, 103, 103, 1),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // จัดให้อยู่กลางในแนวนอน
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

              // Review Section
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
                        maxHeight: MediaQuery.of(context).size.height * 0.3,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: reviews.map((review) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ReviewCard(
                                reviewID: review['rsm_id'],
                                imageName: review['image_name'],
                                firstname: review['firstname'],
                                lastname: review['lastname'],
                                rating: review['rating'],
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
    );
  }
}
