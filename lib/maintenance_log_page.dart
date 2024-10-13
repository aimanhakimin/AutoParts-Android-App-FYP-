import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MaintenanceLogPage extends StatefulWidget {
  const MaintenanceLogPage({Key? key}) : super(key: key);

  @override
  _MaintenanceLogPageState createState() => _MaintenanceLogPageState();
}

class _MaintenanceLogPageState extends State<MaintenanceLogPage> {
  List<CarDetail> carDetails = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadCarDetails();
  }

  Future<void> _loadCarDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('carDetails')
            .where('userId', isEqualTo: user.uid)
            .get();
        setState(() {
          carDetails = snapshot.docs
              .map((doc) => CarDetail.fromJson({...doc.data(), 'id': doc.id}))
              .toList();
        });
      }
    } catch (e) {
      print('Error loading car details: $e');
    }
  }

  Future<void> _saveCarDetail(CarDetail carDetail) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('carDetails').add({
          ...carDetail.toJson(),
          'userId': user.uid,
        });
        _loadCarDetails();
      }
    } catch (e) {
      print('Error saving car detail: $e');
    }
  }

  Future<void> _updateCarDetail(CarDetail carDetail) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('carDetails').doc(carDetail.id).update({
          ...carDetail.toJson(),
          'userId': user.uid,
        });
        _loadCarDetails();
      }
    } catch (e) {
      print('Error updating car detail: $e');
    }
  }

  Future<void> _deleteCarDetail(String id) async {
    try {
      await _firestore.collection('carDetails').doc(id).delete();
      _loadCarDetails();
    } catch (e) {
      print('Error deleting car detail: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maintenance Log'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Maintenance Log',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            _buildAddCarButton(context),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: carDetails.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildCarDetailItem(context, carDetails[index]);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Default to Maintenance Log
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Find Components',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Maintenance Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Track Workshop',
          ),
        ],
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.lightBlueAccent,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/find_components');
              break;
            case 1:
              // Already on Maintenance Log, do nothing
              break;
            case 2:
              Navigator.pushNamed(context, '/track_workshop');
              break;
          }
        },
      ),
    );
  }

  Widget _buildAddCarButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              _showAddCarDialog(context);
            },
            icon: Icon(Icons.add),
            color: Theme.of(context).primaryColor,
          ),
          Text(
            'Add new car info',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarDetailItem(BuildContext context, CarDetail carDetail) {
    return GestureDetector(
      onTap: () {
        // Navigate to car detail page or expand details
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car details (right side)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carDetail.carName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    carDetail.carType,
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    'Manufactured Year: ${carDetail.manufacturedYear}',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    'Last Service Date: ${carDetail.lastServiceDate}',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Repairs:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  ...carDetail.repairs.map((repair) => Text(
                        '- $repair',
                        style: TextStyle(fontSize: 14.0),
                      )),
                ],
              ),
            ),
            const SizedBox(width: 10.0),
            // Edit and Remove buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    _showEditCarDialog(context, carDetail);
                  },
                  icon: Icon(Icons.edit),
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: () async {
                    await _deleteCarDetail(carDetail.id!); // Use the id to delete the document
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: AddCarDialog(
            onSave: _saveCarDetail,
          ),
        );
      },
    );
  }

  void _showEditCarDialog(BuildContext context, CarDetail carDetail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: AddCarDialog(
            carDetail: carDetail,
            onSave: _updateCarDetail,
          ),
        );
      },
    );
  }
}

class AddCarDialog extends StatefulWidget {
  final Function(CarDetail) onSave;
  final CarDetail? carDetail;

  const AddCarDialog({Key? key, required this.onSave, this.carDetail})
      : super(key: key);

  @override
  _AddCarDialogState createState() => _AddCarDialogState();
}

class _AddCarDialogState extends State<AddCarDialog> {
  TextEditingController _carNameController = TextEditingController();
  TextEditingController _carTypeController = TextEditingController();
  TextEditingController _manufacturedYearController = TextEditingController();
  TextEditingController _repairsController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.carDetail != null) {
      _carNameController.text = widget.carDetail!.carName;
      _carTypeController.text = widget.carDetail!.carType;
      _manufacturedYearController.text = widget.carDetail!.manufacturedYear;
      _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.carDetail!.lastServiceDate);
      _repairsController.text =
          widget.carDetail!.repairs.isNotEmpty ? widget.carDetail!.repairs.join(', ') : '';
    }
  }

  @override
  void dispose() {
    _carNameController.dispose();
    _carTypeController.dispose();
    _manufacturedYearController.dispose();
    _repairsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _carNameController,
            decoration: InputDecoration(
              labelText: 'Car Name',
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _carTypeController,
            decoration: InputDecoration(
              labelText: 'Car Type',
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _manufacturedYearController,
            decoration: InputDecoration(
              labelText: 'Manufactured Year',
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedDate != null
                      ? 'Last Service Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'
                      : 'Last Service Date: ',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _repairsController,
            decoration: InputDecoration(
              labelText: 'Repairs',
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  final carDetail = CarDetail(
                    carName: _carNameController.text,
                    carType: _carTypeController.text,
                    manufacturedYear: _manufacturedYearController.text,
                    lastServiceDate: _selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                        : '',
                    repairs: _repairsController.text.split(',').map((e) => e.trim()).toList(),
                    imageUrl: '', // Remove imageUrl since we're not using it
                  );

                  widget.onSave(carDetail);
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CarDetail {
  final String carName;
  final String carType;
  final String manufacturedYear;
  final String lastServiceDate;
  final List<String> repairs;
  final String imageUrl; // Can be removed if not needed
  final String? id;

  CarDetail({
    required this.carName,
    required this.carType,
    required this.manufacturedYear,
    required this.lastServiceDate,
    required this.repairs,
    required this.imageUrl,
    this.id,
  });

  factory CarDetail.fromJson(Map<String, dynamic> json) {
    return CarDetail(
      carName: json['carName'] ?? '',
      carType: json['carType'] ?? '',
      manufacturedYear: json['manufacturedYear'] ?? '',
      lastServiceDate: json['lastServiceDate'] ?? '',
      repairs: json['repairs'] != null ? List<String>.from(json['repairs']) : [],
      imageUrl: json['imageUrl'] ?? '',
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carName': carName,
      'carType': carType,
      'manufacturedYear': manufacturedYear,
      'lastServiceDate': lastServiceDate,
      'repairs': repairs,
      'imageUrl': imageUrl,
    };
  }
}
