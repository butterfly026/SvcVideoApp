import 'package:flutter/foundation.dart';
//
// void main() {
//   // 版本号示例
//   String versionStr1 = '3.2.2';
//   String versionStr2 = '3.3';
//   bool v = VersionUtil.isGt(versionStr1, versionStr2);
//   print("v = ${v}");
// }

class VersionUtil {
  static bool isGt(String v1, String v2) {
    // 解析版本号
    Version version1 = Version.parse(v1);
    Version version2 = Version.parse(v2);
    // 比较版本号
    int v = version1.compareTo(version2);
    if (kDebugMode) {
      if ( v > 0) {
        print('version comparison->$v1 大于 $v2');
      } else if (v < 0) {
        print('version comparison->$v1 小于 $v2');
      } else {
        print('version comparison->$v1 等于 $v2');
      }
    }
    return v > 0;
  }
}

class Version implements Comparable<Version> {
  final List<int> parts;

  Version(this.parts);

  // 解析版本号字符串
  factory Version.parse(String versionStr) {
    List<int> versionParts =
        versionStr.split('.').map(int.parse).toList();

    // 补齐版本号至三位数
    while (versionParts.length < 3) {
      versionParts.add(0);
    }

    return Version(versionParts);
  }

  @override
  int compareTo(Version other) {
    for (int i = 0; i < 3; i++) {
      if (parts[i] != other.parts[i]) {
        return parts[i].compareTo(other.parts[i]);
      }
    }
    return 0; // 两个版本号相等
  }

  @override
  String toString() {
    return parts.join('.');
  }
}
