import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MlHome extends StatefulWidget {
  const MlHome({super.key});

  @override
  State<MlHome> createState() => _MlHomeState();
}

class _MlHomeState extends State<MlHome> {
  final ImagePicker picker = ImagePicker();
  List<XFile> _images = [];

  @override
  void initState() {
    super.initState();
    getLostData();
  }

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles);
      });
    }
  }

  Future<void> getLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) return;

    final List<XFile>? files = response.files;
    if (files != null) {
      setState(() {
        _images.addAll(files);
      });
    } else {
      _handleError(response.exception);
    }
  }

  void _handleError(dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error retrieving images: $error')),
    );
  }

  void _startDiagnosis() {
    // Placeholder for actual diagnosis logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting diagnosis...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaf Disease Diagnosis'),
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.teal.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(12),
                height: isLargeScreen ? 320 : 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _images.isEmpty
                    ? const Center(
                  child: Text(
                    'No images selected',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                    : GridView.builder(
                  itemCount: _images.length,
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_images[index].path),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.folder_open),
              label: const Text('Load Images from Device'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startDiagnosis,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Start Diagnosis'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
