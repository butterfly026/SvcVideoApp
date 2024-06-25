class PageData<T> {
  PageData({
    required this.list,
    this.success = false,
  });

  bool success;
  List<T> list = [];
}
