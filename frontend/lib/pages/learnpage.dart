import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/HomeButtomNavigationBar.dart';
import 'package:frontend/components/massagecardSmall.dart';
import 'package:frontend/components/massagecardSet.dart';
import '../../api/massage.dart';
import 'dart:async';
import 'package:dio/dio.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  State<LearnPage> createState() => _LearnState();
}

class _LearnState extends State<LearnPage> {
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();
  int _selectedTab = 0;

  // Cache data
  static List<dynamic> _cachedSingleMassages = [];
  static List<dynamic> _cachedSetMassages = [];

  // Data for current view
  List<dynamic> singleMassages = [];
  List<dynamic> setMassages = [];
  List<dynamic> filteredSingleMassages = [];
  List<dynamic> filteredSetMassages = [];

  // Pagination parameters
  final int _pageSize = 10;
  int _currentSinglePage = 1;
  int _currentSetPage = 1;
  bool _hasMoreSingleData = true;
  bool _hasMoreSetData = true;
  bool _isLoadingMore = false;

  // UI state
  bool isLoading = true;
  bool isInitialLoad = true;
  final ScrollController _scrollController = ScrollController();

  // Search and filter state
  String selectedTime = "Please select";
  final List<String> timeOptions = [
    "5 minutes",
    "10 minutes",
    "15 minutes",
    "20 minutes",
    "30 minutes",
    "1 hour",
  ];

  String selectedType = "Please select";
  final List<String> typeOptions = [
    "คอ",
    "บ่า ไหล่",
    "หลัง",
    "แขน",
    "ขา",
  ];

  // Debounce for search
  Timer? _debounce;

  void _resetFilters() {
    setState(() {
      selectedTime = "Please select";
      selectedType = "Please select";

      // Apply search filter only
      _applySearchFilter();

      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    textController.addListener(_onSearchChanged);

    // Initial data load
    loadData();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    if (_selectedTab == 0 && _hasMoreSingleData) {
      _loadMoreSingleMassages();
    } else if (_selectedTab == 1 && _hasMoreSetData) {
      _loadMoreSetMassages();
    }
  }

  Future<void> loadData() async {
    if (isInitialLoad) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      if (_selectedTab == 0) {
        if (_cachedSingleMassages.isEmpty) {
          await fetchSingleMassages();
        } else {
          // Use cached data
          setState(() {
            singleMassages = List.from(_cachedSingleMassages);
            _applyFiltersToData();
          });
        }
      } else {
        if (_cachedSetMassages.isEmpty) {
          await fetchSetMassages();
        } else {
          // Use cached data
          setState(() {
            setMassages = List.from(_cachedSetMassages);
            _applyFiltersToData();
          });
        }
      }
    } finally {
      setState(() {
        isLoading = false;
        isInitialLoad = false;
      });
    }
  }

  Future<void> fetchSingleMassages() async {
    final apiService = MassageApiService();

    try {
      // Try to use pagination API if available
      Response response;
      try {
        response =
            await apiService.getMassagesByPage(_currentSinglePage, _pageSize);
      } on Exception catch (_) {
        // Fallback to getting all massages if pagination not supported
        print("Pagination API not available, falling back to getAllMassages");
        response = await apiService.getAllMassages();
      }

      final List<dynamic> allData = response.data as List;

      // Simulate pagination on client-side if server doesn't support it
      final bool isPaginationSupported =
          response.headers.map['x-pagination-supported'] != null;

      List<dynamic> newData;
      if (!isPaginationSupported) {
        // Manual pagination
        final int startIndex = (_currentSinglePage - 1) * _pageSize;
        final int endIndex = startIndex + _pageSize > allData.length
            ? allData.length
            : startIndex + _pageSize;

        if (startIndex >= allData.length) {
          newData = [];
        } else {
          newData = allData.sublist(startIndex, endIndex);
        }
      } else {
        newData = allData;
      }

      setState(() {
        if (_currentSinglePage == 1) {
          singleMassages = newData;
        } else {
          singleMassages.addAll(newData);
        }

        // Update cache
        if (_currentSinglePage == 1) {
          _cachedSingleMassages = List.from(newData);
        } else {
          _cachedSingleMassages.addAll(newData);
        }

        _hasMoreSingleData = newData.length == _pageSize;
        _currentSinglePage++;

        _applyFiltersToData();
      });
    } catch (e) {
      print("Error fetching massages: ${e.toString()}");
    }
  }

  Future<void> _loadMoreSingleMassages() async {
    if (!_hasMoreSingleData || _isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    await fetchSingleMassages();

    setState(() {
      _isLoadingMore = false;
    });
  }

  Future<void> fetchSetMassages() async {
    final apiService = MassageApiService();

    try {
      // Try to use pagination API if available
      Response response;
      try {
        response =
            await apiService.getSetMassagesByPage(_currentSetPage, _pageSize);
      } on Exception catch (_) {
        // Fallback to getting all massages if pagination not supported
        print(
            "Pagination API not available, falling back to getAllSetMassages");
        response = await apiService.getAllSetMassages();
      }

      final List<dynamic> allData = response.data as List;

      // Simulate pagination on client-side if server doesn't support it
      final bool isPaginationSupported =
          response.headers.map['x-pagination-supported'] != null;

      List<dynamic> newData;
      if (!isPaginationSupported) {
        // Manual pagination
        final int startIndex = (_currentSetPage - 1) * _pageSize;
        final int endIndex = startIndex + _pageSize > allData.length
            ? allData.length
            : startIndex + _pageSize;

        if (startIndex >= allData.length) {
          newData = [];
        } else {
          newData = allData.sublist(startIndex, endIndex);
        }
      } else {
        newData = allData;
      }

      setState(() {
        if (_currentSetPage == 1) {
          setMassages = newData;
        } else {
          setMassages.addAll(newData);
        }

        // Update cache
        if (_currentSetPage == 1) {
          _cachedSetMassages = List.from(newData);
        } else {
          _cachedSetMassages.addAll(newData);
        }

        _hasMoreSetData = newData.length == _pageSize;
        _currentSetPage++;

        _applyFiltersToData();
      });
    } catch (e) {
      print("Error fetching set massages: ${e.toString()}");
    }
  }

  Future<void> _loadMoreSetMassages() async {
    if (!_hasMoreSetData || _isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    await fetchSetMassages();

    setState(() {
      _isLoadingMore = false;
    });
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _applySearchFilter();
    });
  }

  void _applySearchFilter() {
    final query = textController.text.toLowerCase();

    if (_selectedTab == 0) {
      // Filter single massages based on search query
      _filterSingleMassages(query);
    } else {
      // Filter set massages based on search query
      _filterSetMassages(query);
    }
  }

  void _filterSingleMassages(String query) {
    setState(() {
      filteredSingleMassages = singleMassages.where((massage) {
        // Apply search
        final name = (massage['mt_name'] ?? '').toString().toLowerCase();
        final type = (massage['mt_type'] ?? '').toString().toLowerCase();
        final matchesSearch = name.contains(query) || type.contains(query);

        // Apply time filter
        bool matchesTime = true;
        if (selectedTime != "Please select") {
          int selectedMinutes = _extractMinutes(selectedTime);
          int massageTime = massage['mt_time'] ?? 0;
          matchesTime = selectedMinutes == massageTime;
        }

        // Apply type filter
        bool matchesType = selectedType == "Please select" ||
            massage['mt_type'] == selectedType;

        return matchesSearch && matchesTime && matchesType;
      }).toList();
    });
  }

  void _filterSetMassages(String query) {
    setState(() {
      filteredSetMassages = setMassages.where((massage) {
        // Apply search
        final name = (massage['ms_name'] ?? '').toString().toLowerCase();
        final types = (massage['ms_types'] as List<dynamic>? ?? [])
            .join(' ')
            .toLowerCase();
        final matchesSearch = name.contains(query) || types.contains(query);

        // Apply time filter
        bool matchesTime = true;
        if (selectedTime != "Please select") {
          int selectedMinutes = _extractMinutes(selectedTime);
          int massageTime = massage['ms_time'] ?? 0;
          matchesTime = selectedMinutes == massageTime;
        }

        // Apply type filter
        bool matchesType = selectedType == "Please select" ||
            (massage['ms_types'] as List<dynamic>).contains(selectedType);

        return matchesSearch && matchesTime && matchesType;
      }).toList();
    });
  }

  void _applyFiltersToData() {
    _applySearchFilter();
  }

  // Helper method to extract minutes from time string
  int _extractMinutes(String timeString) {
    if (timeString.contains("hour")) {
      return 60; // Convert "1 hour" to 60 minutes
    }

    // Extract numeric part
    RegExp regExp = RegExp(r'(\d+)');
    Match? match = regExp.firstMatch(timeString);
    if (match != null && match.groupCount >= 1) {
      return int.parse(match.group(1)!);
    }
    return 0;
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
                            selectedTime = option;
                          });
                          Navigator.pop(context, option);
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
                            selectedType = option;
                          });
                          Navigator.pop(context, option);
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
      _applyFiltersToData();
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
                            GestureDetector(
                              onTap: _resetFilters,
                              child: const Text(
                                'ล้าง',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto',
                                  color: Color.fromARGB(255, 255, 0, 0),
                                ),
                              ),
                            ),
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
                    // Time selector
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
                                  selectedTime = time;
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
                    // Type selector
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
                                  selectedType = type;
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
                      onTap: showFilterPopup,
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

            // Use FutureBuilder for better loading handling
            Expanded(
              child: isInitialLoad
                  ? _buildLoadingIndicator()
                  : _selectedTab == 0
                      ? SingleMassageTab(
                          massages: filteredSingleMassages,
                          scrollController: _scrollController,
                          isLoadingMore: _isLoadingMore,
                          hasMore: _hasMoreSingleData)
                      : SetOfMassageTab(
                          massages: filteredSetMassages,
                          scrollController: _scrollController,
                          isLoadingMore: _isLoadingMore,
                          hasMore: _hasMoreSetData),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        initialIndex: 1,
        onTap: (index) {},
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC0A172)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'กำลังโหลดข้อมูล...',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF676767),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_selectedTab != index) {
            setState(() {
              _selectedTab = index;
              // Reset initial loading if we're switching tabs for the first time
              if ((index == 0 && singleMassages.isEmpty) ||
                  (index == 1 && setMassages.isEmpty)) {
                isInitialLoad = true;
              }
            });
            loadData();
          }
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
    _debounce?.cancel();
    textController.removeListener(_onSearchChanged);
    textController.dispose();
    textFieldFocusNode.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}

class SingleMassageTab extends StatelessWidget {
  final List<dynamic> massages;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final bool hasMore;

  const SingleMassageTab(
      {required this.massages,
      required this.scrollController,
      required this.isLoadingMore,
      required this.hasMore});

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
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: massages.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= massages.length) {
          return hasMore
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFC0A172)),
                    ),
                  ),
                )
              : const SizedBox.shrink();
        }

        final massage = massages[index];
        return MassageCard(
          mtID: massage['mt_id'].toInt() ?? 0,
          image: massage['mt_image_name'] ??
              'https://picsum.photos/seed/picsum/200/300',
          name: massage['mt_name'] ?? 'Unknown Massage',
          detail: massage['mt_detail'] ?? 'No description available.',
          type: massage['mt_type'] ?? 'Unknown Type',
          time: massage['mt_time'] ?? 'Unknown Duration',
          rating: massage['avg_rating']?.toString(),
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
  final ScrollController scrollController;
  final bool isLoadingMore;
  final bool hasMore;

  const SetOfMassageTab(
      {required this.massages,
      required this.scrollController,
      required this.isLoadingMore,
      required this.hasMore});

  @override
  Widget build(BuildContext context) {
    if (massages.length < 1) {
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
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: massages.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= massages.length) {
          return hasMore
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFC0A172)),
                    ),
                  ),
                )
              : const SizedBox.shrink();
        }

        final massage = massages[index];

        return MassageCardSet(
          msID: (massage['ms_id'] ?? 0) as int,
          title: (massage['ms_name'] ?? 'Unknown Title') as String,
          description:
              (massage['ms_detail'] ?? 'No description available.') as String,
          types: (massage['ms_types'] as List<dynamic>? ?? []).cast<String>(),
          duration: (massage['ms_time'] ?? 0) as int,
          images:
              ((massage['ms_image_names'] as List<dynamic>? ?? []).isNotEmpty &&
                      massage['ms_image_names'].length > 0
                  ? massage['ms_image_names']
                  : 'https://picsum.photos/seed/picsum/200/300'),
          rating: massage['avg_rating']?.toString(),
          onFavoriteChanged: (isFavorite) {
            // Handle favorite changed
          },
        );
      },
    );
  }
}
