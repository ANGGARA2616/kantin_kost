import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/location_service.dart';

class LocationStatusWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const LocationStatusWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final LocationService locationService = Get.find<LocationService>();
    
    return Obx(() {
      return Card(
        child: ListTile(
          leading: Icon(
            locationService.currentPosition.value != null 
              ? Icons.location_on 
              : Icons.location_off,
            color: locationService.currentPosition.value != null 
              ? Colors.green 
              : Colors.orange,
          ),
          title: Text(
            locationService.currentAddress.value,
            style: const TextStyle(fontSize: 14),
          ),
          subtitle: locationService.isLocationLoading.value
              ? const LinearProgressIndicator()
              : locationService.hasLocationPermission.value
                  ? const Text('Lokasi aktif')
                  : const Text('Izin lokasi diperlukan'),
          trailing: IconButton(
            icon: const Icon(Icons.map),
            onPressed: onTap,
          ),
          onTap: onTap,
        ),
      );
    });
  }
}