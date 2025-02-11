enum APIPath {
  getAllStation,
}

extension APIPathExtension on APIPath {
  String? get value {
    switch (this) {
      case APIPath.getAllStation:
        return 'getAllStation';
    }
  }
}
