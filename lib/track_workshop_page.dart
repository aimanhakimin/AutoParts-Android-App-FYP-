import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TrackWorkshopPage extends StatefulWidget {
  @override
  _TrackWorkshopPageState createState() => _TrackWorkshopPageState();
}

class _TrackWorkshopPageState extends State<TrackWorkshopPage> {
  bool _enginesSelected = false;
  bool _cleaningAndDetailingSelected = false;
  bool _bodykitsSelected = false;
  bool _aircondSelected = false;
  bool _tireAndWheelsSelected = false;
  bool _exhaustAndMufflersSelected = false;

  List<Workshop> _workshops = [];
  String? _userLocation;
  bool _showGeolocationMessage = false;

  @override
  void initState() {
    super.initState();
    _fetchWorkshops();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    _userLocation = place.administrativeArea;

    setState(() {
      _showGeolocationMessage = true;
      _sortWorkshopsByUserLocation();
    });
  }

  Future<void> _fetchWorkshops() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('workshops').get();
    List<Workshop> workshops = snapshot.docs.map((doc) {
      return Workshop(
        doc['name'],
        doc['address'],
        doc['mapLink'],
        doc['category'],
      );
    }).toList();

    setState(() {
      _workshops = workshops;
      _sortWorkshopsByUserLocation();
    });
  }

  void _sortWorkshopsByUserLocation() {
    if (_userLocation != null) {
      _workshops.sort((a, b) {
        bool aContains = a.address.contains(_userLocation!);
        bool bContains = b.address.contains(_userLocation!);
        if (aContains && !bContains) {
          return -1;
        } else if (!aContains && bContains) {
          return 1;
        } else {
          return 0;
        }
      });
    }
  }

  List<Workshop> get _filteredWorkshops {
    List<Workshop> filtered = _workshops;
    if (_enginesSelected) {
      filtered = filtered.where((workshop) => workshop.category == 'Engines').toList();
    }
    if (_cleaningAndDetailingSelected) {
      filtered = filtered.where((workshop) => workshop.category == 'Cleaning and Detailing').toList();
    }
    if (_bodykitsSelected) {
      filtered = filtered.where((workshop) => workshop.category == 'Bodykits').toList();
    }
    if (_aircondSelected) {
      filtered = filtered.where((workshop) => workshop.category == 'Aircond').toList();
    }
    if (_tireAndWheelsSelected) {
      filtered = filtered.where((workshop) => workshop.category == 'Tire and Wheels').toList();
    }
    if (_exhaustAndMufflersSelected) {
      filtered = filtered.where((workshop) => workshop.category == 'Exhaust and Mufflers').toList();
    }
    return filtered;
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/find_components');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/maintenance_log');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/track_workshop');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Workshop'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Track Workshop',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10.0),
            if (_showGeolocationMessage)
              Text(
                'Showing workshops near you based on your location.',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.green,
                ),
              ),
            SizedBox(height: 20.0),
            Text(
              'Filter By:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10.0),
            Wrap(
              spacing: 10.0,
              children: [
                FilterChip(
                  label: Text('Engines'),
                  onSelected: (bool selected) {
                    setState(() {
                      _enginesSelected = selected;
                    });
                  },
                  selected: _enginesSelected,
                  selectedColor: _enginesSelected ? Colors.blue : Colors.grey[300],
                ),
                FilterChip(
                  label: Text('Cleaning and Detailing'),
                  onSelected: (bool selected) {
                    setState(() {
                      _cleaningAndDetailingSelected = selected;
                    });
                  },
                  selected: _cleaningAndDetailingSelected,
                  selectedColor: _cleaningAndDetailingSelected ? Colors.blue : Colors.grey[300],
                ),
                FilterChip(
                  label: Text('Bodykits'),
                  onSelected: (bool selected) {
                    setState(() {
                      _bodykitsSelected = selected;
                    });
                  },
                  selected: _bodykitsSelected,
                  selectedColor: _bodykitsSelected ? Colors.blue : Colors.grey[300],
                ),
                FilterChip(
                  label: Text('Aircond'),
                  onSelected: (bool selected) {
                    setState(() {
                      _aircondSelected = selected;
                    });
                  },
                  selected: _aircondSelected,
                  selectedColor: _aircondSelected ? Colors.blue : Colors.grey[300],
                ),
                FilterChip(
                  label: Text('Tire and Wheels'),
                  onSelected: (bool selected) {
                    setState(() {
                      _tireAndWheelsSelected = selected;
                    });
                  },
                  selected: _tireAndWheelsSelected,
                  selectedColor: _tireAndWheelsSelected ? Colors.blue : Colors.grey[300],
                ),
                FilterChip(
                  label: Text('Exhaust and Mufflers'),
                  onSelected: (bool selected) {
                    setState(() {
                      _exhaustAndMufflersSelected = selected;
                    });
                  },
                  selected: _exhaustAndMufflersSelected,
                  selectedColor: _exhaustAndMufflersSelected ? Colors.blue : Colors.grey[300],
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredWorkshops.length,
                itemBuilder: (context, index) {
                  final workshop = _filteredWorkshops[index];
                  return ListTile(
                    title: Text(workshop.name),
                    subtitle: Text(workshop.address),
                    trailing: IconButton(
                      icon: Icon(Icons.map),
                      onPressed: () => _launchURL(workshop.mapLink),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Find Components',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Maintenance Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Track Workshop',
          ),
        ],
        currentIndex: 2, // Index of the 'Track Workshop' page
        onTap: _onItemTapped,
      ),
    );
  }
}

class Workshop {
  final String name;
  final String address;
  final String mapLink;
  final String category;

  Workshop(this.name, this.address, this.mapLink, this.category);
}
