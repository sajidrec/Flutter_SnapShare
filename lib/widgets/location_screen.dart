import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final List<String> _locations = [
    'Jamuna Future Park',
    'Bashundhara City',
    'Dhaka University',
    'Gulshan Lake Park',
    'National Museum'
  ];
  final List<String> _selectedLocations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Locations'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: _selectedLocations);
            },
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _locations.length,
        itemBuilder: (context, index) {
          final location = _locations[index];
          final isSelected = _selectedLocations.contains(location);
          return ListTile(
            title: Text(location),
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
    );
  }
}
