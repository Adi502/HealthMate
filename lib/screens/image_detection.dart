import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageDetection extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTFLite();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
    Tflite.close();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;

  Future<List<String>> classifyImage(String imagePath) async {
    try {
      final results = await Tflite.runModelOnImage(
        path: imagePath,
        numResults: 1,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5,
        asynch: true,
      );

      final classificationResults = <String>[];
      if (results != null && results.isNotEmpty) {
        final label = results[0]['label'];
        final foodName = extractFoodName(label);
        classificationResults.add('$foodName ');
      }

      print('Classification results: $classificationResults');

      return classificationResults;
    } catch (e) {
      print('Error classifying image: $e');
      return [];
    }
  }

  String extractFoodName(String label) {
    // Assuming the label format is "<index> <food name>"
    final parts = label.split(' ');
    if (parts.length > 1) {
      return parts.sublist(1).join(' '); // Join all parts except the index
    }
    return label; // If label doesn't contain space-separated parts
  }


  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();

      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.max,
      );
      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            // ObjectDetector(image);
          }
          update();
        });
      });
      isCameraInitialized(true);
      update();
    } else {
      print("Permission Denied!");
    }
  }

  initTFLite() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  void classifyFoodFromQuery(String query) {
    String foodName = query.substring(3).trim();
    print('Food name extracted from query: $foodName');
    // Now you can use foodName for further processing or classification
    // For example, you can call classifyImage(foodName) to classify the image.
    // classifyImage(foodName);
  }
}
