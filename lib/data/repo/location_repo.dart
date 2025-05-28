import 'dart:async';

import 'package:friendly_partner/data/apis/api_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class LocationRepo {
  final ApiClient apiClient;
  LocationRepo({
    required this.apiClient,
  });
}
