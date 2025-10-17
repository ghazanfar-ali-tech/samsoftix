import 'package:flutter/material.dart';
import 'package:pixels_api/models/pixel_model.dart';
import 'package:pixels_api/services/pexels_service.dart';

class PhotoProvider with ChangeNotifier {
  PixelPhotos? _photos;
  bool _isLoading = false;

  PixelPhotos? get photos => _photos;
  bool get isLoading => _isLoading;

  Future<void> fetchPhotos(String query) async {
    _isLoading = true;
    notifyListeners();

    _photos = await PexelsService.fetchPhotos(query: query);

    _isLoading = false;
    notifyListeners();
  }
}
