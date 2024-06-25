import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

Future<Uint8List?> getImageFromPicker() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  Uint8List? bytesFromPicker = await image!.readAsBytes();
  return bytesFromPicker;
}
