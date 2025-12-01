import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import '../controllers/location_controller.dart';
import '../../../core/services/map_service.dart';

class MapPage extends GetView<LocationController> {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () => controller.getCurrentLocation(),
          ),
          Obx(() => Switch(
                value: controller.isTracking.value,
                onChanged: (value) {
                  if (value) {
                    controller.startLocationTracking();
                  } else {
                    controller.stopLocationTracking();
                  }
                },
              )),
        ],
      ),
      body: Obx(() {
        final mapService = Get.find<MapService>();
        final currentLocation = mapService.currentLocation.value;
        final selectedLocation = mapService.selectedLocation.value;
        final zoom = mapService.mapZoom.value;

        if (currentLocation == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Mengambil lokasi...'),
              ],
            ),
          );
        }

        return FlutterMap(
          options: MapOptions(
            initialCenter: selectedLocation ?? currentLocation,
            initialZoom: zoom,
            onTap: (tapPosition, latLng) {
              controller.selectLocationOnMap(latLng);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.kantinkost54.app',
            ),
            // Current location marker
            MarkerLayer(
              markers: [
                Marker(
                  point: currentLocation,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_history,
                    color: Colors.blue,
                    size: 40,
                  ),
                ),
              ],
            ),
            // Selected location marker
            if (selectedLocation != null && selectedLocation != currentLocation)
              MarkerLayer(
                markers: [
                  Marker(
                    point: selectedLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            // Location history polyline
            if (controller.locationHistory.length > 1)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: controller.locationHistory,
                    color: const Color(0xFF0000FF).withOpacity(0.7), // GUNAKAN Color().withOpacity()
                    strokeWidth: 4,
                  ),
                ],
              ),
          ],
        );
      }),
      floatingActionButton: Obx(() {
        final mapService = Get.find<MapService>();
        final currentLocation = mapService.currentLocation.value;
        final selectedLocation = mapService.selectedLocation.value;
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (selectedLocation != null && selectedLocation != currentLocation)
              FloatingActionButton(
                onPressed: () {
                  final distance = controller.calculateDistanceToSelected(selectedLocation);
                  Get.back(result: {
                    'location': selectedLocation,
                    'distance': distance,
                  });
                },
                child: const Icon(Icons.check),
              ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () => controller.getCurrentLocation(),
              child: const Icon(Icons.gps_fixed),
            ),
          ],
        );
      }),
    );
  }
}