import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MultipleCorners extends StatefulWidget {
  const MultipleCorners({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MultipleCornersState createState() => _MultipleCornersState();
}

class _MultipleCornersState extends State<MultipleCorners> {
  final List<TextEditingController> _northingControllers =
      List.generate(5, (_) => TextEditingController());
  final List<TextEditingController> _eastingControllers =
      List.generate(5, (_) => TextEditingController());
  String _selectedProjection = 'Old projection';
  final List<LatLng> _locations = [];
  GoogleMapController? _mapController;
  bool _showMap = false;
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _northingControllers) {
      controller.dispose();
    }
    for (var controller in _eastingControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  LatLng _convertToLatLng(double northing, double easting) {
    double latitude = northing;
    double longitude = easting;

    return LatLng(latitude, longitude);
  }

  Future<void> _updateLocations() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _locations.clear();
      for (int i = 0; i < _northingControllers.length; i++) {
        final northing = double.tryParse(_northingControllers[i].text);
        final easting = double.tryParse(_eastingControllers[i].text);
        if (northing != null && easting != null) {
          _locations.add(_convertToLatLng(northing, easting));
        }
      }

      _showMap = _locations.isNotEmpty;

      if (_locations.isNotEmpty && _mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_locations.first, 15.0),
        );
      }

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Coordinates are northing then followed by (space, tab, or comma) and then easting. One line for each corner.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: List.generate(_northingControllers.length, (index) {
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _northingControllers[index],
                          decoration: const InputDecoration(
                            hintText: 'Northing',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _eastingControllers[index],
                          decoration: const InputDecoration(
                            hintText: 'Easting',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  );
                }),
              ),
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
              onPressed: _updateLocations,
              child: const Text('Locate'),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              Container(
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_showMap)
              Container(
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GoogleMap(
                  onMapCreated: (controller) {
                    _mapController = controller;

                    if (_locations.isNotEmpty) {
                      _mapController!.animateCamera(
                        CameraUpdate.newLatLngZoom(_locations.first, 15.0),
                      );
                    }
                  },
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(0, 0),
                    zoom: 1,
                  ),
                  markers: _locations.map((location) {
                    return Marker(
                      markerId: MarkerId(location.toString()),
                      position: location,
                    );
                  }).toSet(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
