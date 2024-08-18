// ignore: file_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class KrookieImagePage extends StatefulWidget {
  const KrookieImagePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _KrookieImagePageState createState() => _KrookieImagePageState();
}

class _KrookieImagePageState extends State<KrookieImagePage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final status = await _checkPermissions(source);
      if (status == PermissionStatus.granted) {
        final pickedFile = await _picker.pickImage(source: source);

        if (pickedFile != null) {
          setState(() {
            _imageFile = File(pickedFile.path);
          });
        }
      } else {
        print('Permission not granted');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<PermissionStatus> _checkPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      return await Permission.camera.request();
    } else {
      return await Permission.photos.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _imageFile != null
              ? Image.file(
                  _imageFile!,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                )
              : InkWell(
                  onTap: () => _showPicker(context),
                  child: Container(
                    width: 320,
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12)),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download,
                          size: 40,
                          color: Colors.grey,
                        ),
                        Text('Drop image here or click to upload'),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.green),
                  title: const Text('Photo Library'),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(
                  Icons.photo_camera,
                  color: Colors.green,
                ),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
