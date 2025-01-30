import 'package:flutter/material.dart';
import 'dart:ui';

class DashedBorderContainer extends StatefulWidget {
  final double width;
  final double height;
  final String? selectedValue;
  final List<Map<String, String>> items;
  final ValueChanged<String?> onChanged;

  const DashedBorderContainer({
    Key? key,
    required this.width,
    required this.height,
    this.selectedValue,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  _DashedBorderContainerState createState() => _DashedBorderContainerState();
}

class _DashedBorderContainerState extends State<DashedBorderContainer> {
  String? currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return currentValue == null
        ? GestureDetector(
            onTap: () async {
              String? selected = await _showSelectionDialog(context);
              if (selected != null) {
                setState(() {
                  currentValue = selected;
                });
                widget.onChanged(selected);
              }
            },
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: Color(0xFF676767),
                  ),
                ),
              ),
            ),
          )
        : _buildSelectedItem();
  }

  Widget _buildSelectedItem() {
    final selectedItem = widget.items.firstWhere(
      (item) => item['name'] == currentValue,
      orElse: () => {},
    );

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Color(0x26000000),
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    if (selectedItem['image'] != null)
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            selectedItem['image']!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedItem['name'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDBDBDB),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          selectedItem["type"] ?? '',
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
                          selectedItem["duration"] ?? '',
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: InkWell(
                onTap: () {
                  setState(() {
                    currentValue = null;
                  });
                  widget.onChanged(null);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5757),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(
                    Icons.delete,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              ),
              
            ],
          ),
        ],
      ),
    );
  }

  Future<String?> _showSelectionDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Single Massage'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: ListTile(
                    leading: item['image'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              item['image']!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : null,
                    title: Text(item['name'] ?? ''),
                    onTap: () {
                      Navigator.of(context).pop(item['name']);
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final double borderRadius; // ระบุขอบโค้ง

  DashedBorderPainter({this.borderRadius = 10});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0xFF676767)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double dashWidth = 10;
    double dashSpace = 10;
    

    // สร้าง Path สำหรับกรอบโค้ง
    Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

    // วาดเส้นประจาก Path
    PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        Path extractPath = pathMetric.extractPath(
          distance,
          distance + dashWidth,
        );
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
