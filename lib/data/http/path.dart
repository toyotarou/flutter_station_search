enum APIPath {
  getAllStation,
  getTokyoTrainStation,
}

extension APIPathExtension on APIPath {
  String? get value {
    switch (this) {
      case APIPath.getAllStation:
        return 'getAllStation';

      case APIPath.getTokyoTrainStation:
        return 'getTokyoTrainStation';
    }
  }
}
