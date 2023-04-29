import 'package:file_picker/file_picker.dart';

Future<String> pickDocument() async {

  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    final String? file = result.files.single.path;
    return file!;
  } else {
    return '';
  }
}