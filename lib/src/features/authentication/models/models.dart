import 'package:simone/src/constants/image_strings.dart';

class DataModel {
  final String title;
  final String imageName;
  final String description;
  DataModel(
    this.title,
    this.imageName,
    this.description,
  );
}

List<DataModel> dataList = [
  DataModel("Motor", motor,
      "Many car accidents happen in the Philippines every day. Make sure you are protected."),
  DataModel("Travel", travel,
      "Adventures are more enjoyable when you travel worry-free!"),
];
