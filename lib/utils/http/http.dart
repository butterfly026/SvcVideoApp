library http;

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/utils/common_util.dart';
import 'package:flutter_video_community/utils/encrypt_util.dart';
import 'package:flutter_video_community/utils/http/src/service.dart';

part 'src/dio_utils.dart';

part 'src/exception.dart';

part 'src/interceptors.dart';

var http = DioUtils.getInstance();

final httpService = ApiService(dio: http);
