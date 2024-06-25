enum ContentEnum { video, comic, novel, tv }

extension ClassifyEnumExtension on ContentEnum {
  String get value {
    switch (this) {
      case ContentEnum.video:
        return '视频';
      case ContentEnum.comic:
        return '动漫';
      case ContentEnum.novel:
        return '小说';
      case ContentEnum.tv:
        return '合集';
    }
  }

  String get type {
    switch (this) {
      case ContentEnum.video:
        return 'video';
      case ContentEnum.comic:
        return 'comic';
      case ContentEnum.novel:
        return 'novel';
      case ContentEnum.tv:
        return 'tv';
    }
  }
}
