import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/network_caller/network_caller.dart';
import 'package:snapshare/utils/app_colors.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Future<void> _placeListFromApi(String query) async {
    var apiKey = 'AIzaSyAd82MdYr_CD_FTd6tMZPWgdYMDWgdqqwM'; //not valid key
    Uri url =
        Uri.https('maps.googleapis.com', 'maps/api/place/autocomplete/json', {
      'input': query,
      'key': apiKey,
    });
    String? response = await NetworkCaller.fetchUrl(url);
    response != null ? print(response) : null;
  }

  final List<String> _locationsList = [
    'Jamuna Future Park',
    'Bashundhara City',
    'Dhaka University',
    'Gulshan Lake Park',
    'National Museum'
  ];
  final List<String> _selectedLocations = [];
  List<String> _searchedLocations = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchedLocations = _locationsList; // Initially show all locations
  }

  void _filterLocations(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchedLocations = _locationsList;
      } else {
        _searchedLocations = _locationsList
            .where((location) =>
                location.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = AppColor.forText(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: textColor,
        ),
        title: Text(
          'Select Locations',
          style: TextStyle(color: textColor),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: _selectedLocations);
            },
            child: Text(
              'Done',
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: textColor,
                ),
                hintText: 'Search Location...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterLocations,
              // onChanged: (value) {
              //   _placeListFromApi(value);
              // },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchedLocations.length,
              itemBuilder: (context, index) {
                final location = _searchedLocations[index];
                final isSelected = _selectedLocations.contains(location);
                return ListTile(
                  title: Text(
                    location,
                    style: TextStyle(color: textColor),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedLocations.remove(location);
                      } else {
                        _selectedLocations.add(location);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
