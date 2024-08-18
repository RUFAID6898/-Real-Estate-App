import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SingleCorner extends StatefulWidget {
  const SingleCorner({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SingleCornerState createState() => _SingleCornerState();
}

class _SingleCornerState extends State<SingleCorner> {
  String _selectedProjection = 'Old projection';
  final TextEditingController _northingController = TextEditingController();
  final TextEditingController _eastingController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorDialog('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorDialog('Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorDialog(
            'Location permissions are permanently denied. Please enable them in settings.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _northingController.text = position.latitude.toString();
        _eastingController.text = position.longitude.toString();
        _currentPosition = LatLng(position.latitude, position.longitude);
        _moveCameraToPosition(_currentPosition!);
      });
    } catch (e) {
      _showErrorDialog('Failed to get location: $e');
    }
  }

  void _moveCameraToPosition(LatLng position) {
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _locateButtonPressed() {
    if (_currentPosition != null) {
      setState(() {
        _northingController.text = _currentPosition!.latitude.toString();
        _eastingController.text = _currentPosition!.longitude.toString();
      });

      _moveCameraToPosition(_currentPosition!);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Current Values'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Northing: ${_northingController.text}'),
              Text('Easting: ${_eastingController.text}'),
              Text('Projection Type: $_selectedProjection'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      _showErrorDialog('Location not available yet. Please wait.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: _currentPosition == null
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition!,
                        zoom: 15,
                      ),
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      markers: _currentPosition != null
                          ? {
                              Marker(
                                markerId: const MarkerId('currentLocation'),
                                position: _currentPosition!,
                              ),
                            }
                          : {},
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Northing',
                          style: TextStyle(fontSize: 18),
                        ),
                        TextField(
                          controller: _northingController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Easting',
                          style: TextStyle(fontSize: 18),
                        ),
                        TextField(
                          controller: _eastingController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Projection Type:'),
            ),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: _selectedProjection,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedProjection = newValue!;
                    });
                  },
                  items: ['Old projection', 'New projection']
                      .map<DropdownMenuItem<String>>(
                        (value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _locateButtonPressed,
              child: const Text('Locate'),
            ),
          ],
        ),
      ),
    );
  }
}
