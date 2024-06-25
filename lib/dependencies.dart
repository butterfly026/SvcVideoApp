// ignore_for_file: always_specify_types, strict_raw_type

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_community/data/repository/index/index_repository.dart';
import 'package:flutter_video_community/data/repository/mine/mine_repository.dart';

import 'data/repository/community/community_repository.dart';
import 'data/repository/content/work_repository.dart';
import 'data/repository/game/game_repository.dart';
import 'data/repository/main/main_repository.dart';
import 'global/repository/global_repository.dart';

//provider
List<RepositoryProvider> buildRepositories() {
  return [
    RepositoryProvider<GlobalRepository>(
      create: (_) => GlobalRepository(),
    ),
    RepositoryProvider<IndexRepository>(
      create: (_) => IndexRepository(),
    ),
    RepositoryProvider<MainRepository>(
      create: (_) => MainRepository(),
    ),
    RepositoryProvider<WorkRepository>(
      create: (_) => WorkRepository(),
    ),
    RepositoryProvider<GameRepository>(
      create: (_) => GameRepository(),
    ),
    RepositoryProvider<MineRepository>(
      create: (_) => MineRepository(),
    ),
    RepositoryProvider<CommunityRepository>(
      create: (_) => CommunityRepository(),
    ),
  ];
}
