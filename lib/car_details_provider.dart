import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarDetail {
  final String carName;
  final String carType;
  final String manufacturedYear;
  final String lastServiceDate;
  final String imageUrl;

  CarDetail({
    required this.carName,
    required this.carType,
    required this.manufacturedYear,
    required this.lastServiceDate,
    required this.imageUrl,
  });

  factory CarDetail.fromJson(Map<String, dynamic> json) {
    return CarDetail(
      carName: json['carName'],
      carType: json['carType'],
      manufacturedYear: json['manufacturedYear'],
      lastServiceDate: json['lastServiceDate'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carName': carName,
      'carType': carType,
      'manufacturedYear': manufacturedYear,
      'lastServiceDate': lastServiceDate,
      'imageUrl': imageUrl,
    };
  }
}

class CarDetailsProvider with ChangeNotifier {
  List<CarDetail> _carDetails = [];

  List<CarDetail> get carDetails => _carDetails;

  void addCarDetail(CarDetail carDetail) {
    _carDetails.add(carDetail);
    notifyListeners();
    _saveCarDetailsToPrefs();
  }

  void updateCarDetail(CarDetail oldCarDetail, CarDetail updatedCarDetail) {
    final index = _carDetails.indexOf(oldCarDetail);
    if (index != -1) {
      _carDetails[index] = updatedCarDetail;
      notifyListeners();
      _saveCarDetailsToPrefs();
    }
  }

  void removeCarDetail(int index) {
    _carDetails.removeAt(index);
    notifyListeners();
    _saveCarDetailsToPrefs();
  }

  Future<void> loadCarDetailsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('carDetails')) {
      final List<dynamic> carDetailsJson =
          json.decode(prefs.getString('carDetails')!);
      _carDetails =
          carDetailsJson.map((json) => CarDetail.fromJson(json)).toList();
      notifyListeners();
    }
  }

  void _saveCarDetailsToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'carDetails', json.encode(_carDetails.map((e) => e.toJson()).toList()));
  }
}
