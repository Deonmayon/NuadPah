// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class MassageCardLarge extends StatelessWidget {
//   final String image;
//   final String avatar;
//   final String name;
//   final String type;
//   final String duration;
//   final String rating;

//   const MassageCardLarge({
//     Key? key,
//     required this.image,
//     required this.avatar,
//     required this.name,
//     required this.type,
//     required this.duration,
//     required this.rating,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20.0),
//       child: Container(
//         width: 290,
//         height: 230,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 15,
//               color: const Color(0x40000000),
//               offset: Offset(0, 5),
//             )
//           ],
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               width: double.infinity,
//               height: 135,
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: const BorderRadius.all(Radius.circular(15)),
//                     child: Image.network(
//                       image,
//                       width: 290,
//                       height: 120,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Positioned(
//                     top: 10,
//                     right: 10,
//                     child: Container(
//                       width: 35,
//                       height: 35,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: Color(0x99DBDBDB),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: IconButton(
//                         padding: EdgeInsets.zero,
//                         alignment: Alignment.center,
//                         icon: const FaIcon(
//                           FontAwesomeIcons.solidBookmark,
//                           size: 20,
//                           color: Colors.white,
//                         ),
//                         onPressed: () {},
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     left: 15,
//                     child: Container(
//                       height: 30,
//                       padding: EdgeInsets.symmetric(horizontal: 2),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircleAvatar(
//                             radius: 12.5,
//                             backgroundImage: NetworkImage(avatar),
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             'Type: $type',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.w400,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(15.0),
//               child: Text(
//                 name,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15.0),
//               child: Row(
//                 children: [
//                   Icon(FontAwesomeIcons.solidClock,
//                       size: 15, color: Color(0xFFB1B1B1)),
//                   SizedBox(width: 5),
//                   Text(
//                     '≈ $duration',
//                     style: TextStyle(fontSize: 12, color: Color(0xFF676767)),
//                   ),
//                   SizedBox(width: 10),
//                   Icon(FontAwesomeIcons.solidStar,
//                       size: 15, color: Color(0xFFB1B1B1)),
//                   SizedBox(width: 5),
//                   Text(
//                     rating,
//                     style: TextStyle(fontSize: 12, color: Color(0xFF676767)),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 5),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class MassageCardLarge extends StatelessWidget {
//   final String name;
//   final String type;
//   final String rating;
//   final List<String> images;
//   final bool isSet;

//   const MassageCardLarge({
//     Key? key,
//     required this.name,
//     required this.type,
//     required this.rating,
//     required this.images,
//     required this.isSet,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20.0),
//       child: Container(
//         width: 290,
//         height: 250,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 15,
//               color: const Color(0x40000000),
//               offset: Offset(0, 5),
//             )
//           ],
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               width: double.infinity,
//               height: 140,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(15),
//                     topRight: Radius.circular(15)),
//                 child: isSet && images.isNotEmpty
//                     ? PageView(
//                         children: images
//                             .map((img) => Image.network(
//                                   img,
//                                   width: 290,
//                                   height: 140,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) =>
//                                       Container(
//                                     color: Colors.grey.shade300,
//                                     child: Icon(Icons.image_not_supported,
//                                         size: 50, color: Colors.grey),
//                                   ),
//                                 ))
//                             .toList(),
//                       )
//                     : Image.network(
//                         images.isNotEmpty
//                             ? images[0]
//                             : 'https://via.placeholder.com/290x140',
//                         width: 290,
//                         height: 140,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) => Container(
//                           color: Colors.grey.shade300,
//                           child: Icon(Icons.image_not_supported,
//                               size: 50, color: Colors.grey),
//                         ),
//                       ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name.isNotEmpty ? name : 'Unknown Name',
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Row(
//                     children: [
//                       Icon(FontAwesomeIcons.solidBookmark,
//                           size: 15, color: Colors.blueGrey),
//                       const SizedBox(width: 5),
//                       Text(
//                         'Type: ${type.isNotEmpty ? type : "Unknown"}',
//                         style: const TextStyle(
//                             fontSize: 12, color: Colors.black54),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   Row(
//                     children: [
//                       Icon(FontAwesomeIcons.solidStar,
//                           size: 15, color: Colors.orange),
//                       const SizedBox(width: 5),
//                       Text(
//                         rating.isNotEmpty ? rating : 'N/A',
//                         style: const TextStyle(
//                             fontSize: 12, color: Colors.black54),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class MassageCardLarge extends StatelessWidget {
//   final String name;
//   final String type;
//   final String rating;
//   final List<String> images;
//   final bool isSet;

//   const MassageCardLarge({
//     Key? key,
//     required this.name,
//     required this.type,
//     required this.rating,
//     required this.images,
//     required this.isSet,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20.0),
//       child: Container(
//         width: 290,
//         height: 230,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 15,
//               color: const Color(0x40000000),
//               offset: Offset(0, 5),
//             )
//           ],
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               width: double.infinity,
//               height: 135,
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: const BorderRadius.all(Radius.circular(15)),
//                     child: isSet && images.isNotEmpty
//                         ? PageView(
//                             children: images
//                                 .map((img) => Image.network(
//                                       img,
//                                       width: 290,
//                                       height: 120,
//                                       fit: BoxFit.cover,
//                                       errorBuilder:
//                                           (context, error, stackTrace) =>
//                                               Container(
//                                         color: Colors.grey.shade300,
//                                         child: Icon(Icons.image_not_supported,
//                                             size: 50, color: Colors.grey),
//                                       ),
//                                     ))
//                                 .toList(),
//                           )
//                         : Image.network(
//                             images.isNotEmpty
//                                 ? images[0]
//                                 : 'https://via.placeholder.com/290x140',
//                             width: 290,
//                             height: 120,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 Container(
//                               color: Colors.grey.shade300,
//                               child: Icon(Icons.image_not_supported,
//                                   size: 50, color: Colors.grey),
//                             ),
//                           ),
//                   ),
//                   Positioned(
//                     top: 10,
//                     right: 10,
//                     child: Container(
//                       width: 35,
//                       height: 35,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: Color(0x99DBDBDB),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: IconButton(
//                         padding: EdgeInsets.zero,
//                         alignment: Alignment.center,
//                         icon: const FaIcon(
//                           FontAwesomeIcons.solidBookmark,
//                           size: 20,
//                           color: Colors.white,
//                         ),
//                         onPressed: () {},
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     left: 15,
//                     child: Container(
//                       height: 30,
//                       padding: EdgeInsets.symmetric(horizontal: 2),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircleAvatar(
//                             radius: 12.5,
//                             backgroundImage: NetworkImage(
//                                 'https://picsum.photos/id/237/200/300'), // Add a default avatar URL here
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             'Type: ${type.isNotEmpty ? type : "Unknown"}',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.w400,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(15.0),
//               child: Text(
//                 name.isNotEmpty ? name : 'Unknown Name',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15.0),
//               child: Row(
//                 children: [
//                   Icon(FontAwesomeIcons.solidClock,
//                       size: 15, color: Color(0xFFB1B1B1)),
//                   SizedBox(width: 5),
//                   Text(
//                     'Duration: TBD', // Replace with actual duration if needed
//                     style: TextStyle(fontSize: 12, color: Color(0xFF676767)),
//                   ),
//                   SizedBox(width: 10),
//                   Icon(FontAwesomeIcons.solidStar,
//                       size: 15, color: Color(0xFFB1B1B1)),
//                   SizedBox(width: 5),
//                   Text(
//                     rating.isNotEmpty ? rating : 'N/A',
//                     style: TextStyle(fontSize: 12, color: Color(0xFF676767)),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 5),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MassageCardLarge extends StatelessWidget {
  final String name;
  final String score;
  final String type;
  final String image;
  final bool isSet;

  const MassageCardLarge({
    Key? key,
    required this.name,
    required this.score,
    required this.type,
    required this.image,
    required this.isSet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 290,
        height: 230,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: const Color(0x40000000),
              offset: Offset(0, 5),
            )
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 135,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Image.network(
                  image.isNotEmpty
                      ? image
                      : 'https://via.placeholder.com/290x140',
                  width: 290,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade300,
                    child: Icon(Icons.image_not_supported,
                        size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                name.isNotEmpty ? name : 'Unknown Name',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.solidStar,
                      size: 15, color: Color(0xFFB1B1B1)),
                  SizedBox(width: 5),
                  Text(
                    score.isNotEmpty ? score : 'N/A',
                    style: TextStyle(fontSize: 12, color: Color(0xFF676767)),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Type: ${type.isNotEmpty ? type : "Unknown"}',
                    style: TextStyle(fontSize: 12, color: Color(0xFF676767)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
