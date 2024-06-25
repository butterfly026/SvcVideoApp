class UpdateDownloadProgress {
  UpdateDownloadProgress({
    this.progress = 0,
    this.appId = '',
    this.path = '',
    this.web = false,
    this.downloadCompleted = false,
  });

  double progress;
  String appId;
  String path;
  bool web;
  bool downloadCompleted;
}
