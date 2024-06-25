part of '../router.dart';

class AppRouter {
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final RouteObserver<ModalRoute<void>> routeObservers = RouteObservers();

  static const splash = '/splash';
  static const main = '/main';
  static const vipRecharge = '/mine/recharge/vip';
  static const coinRecharge = '/mine/recharge/coin';
  static const settings = '/mine/settings';
  static const retrieveAccount = '/mine/settings/account/retrieve';
  static const scanCredentials = '/mine/settings/account/retrieve/scan';
  static const webPage = '/main/web';
  static const videoPlayer = '/video/player';
  static const share = '/mine/share';
  static const videoLivePlayer = '/video/live/player';
  static const gameDeposit = '/video/game/deposit';
  static const gameWithdrawal = '/video/game/withdrawal';
  static const undress = '/undress';
  static const undressRecord = '/undress/record';
  static const louFeng = '/louFeng';
  static const communityDetails = '/louFeng/details';
  static const tvSeries = '/tvSeries';
  static const tvSeriesVideoPlayer = '/tvSeries/video/player';
  static const releasePost = '/loufeng/post/release';
  static const videoSearch = '/video/search';
  static const gameActivity = '/game/activity';
  static const workDetail = '/work/detail';
  static const workMore = '/work/more';
  static const workSearch = '/work/search';
  static const comicsRead = '/comics/read';
  static const novelRead = '/novel/read';
  static const comicsSearch = '/comics/search';
  static const novelSearch = '/novel/search';
  static const tvSeriesSearch = '/tvSeries/search';
  static const videoApp = '/video/app';
  static const coupon = '/mine/coupon';
  static const favor = '/favor';
  static const orderHistory = '/orderHistory';
  static const gameWithdrawalRecord = '/game/withdrawalRecord';
  static const gamePlay = '/game/play';
  static const gameDetails = '/game/detail';
  static const liveRoom = '/live/room';

  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: main,
      page: () => const MainPage(),
    ),
    GetPage(
      name: vipRecharge,
      page: () => const VipRechargePage(),
    ),
    GetPage(
      name: coinRecharge,
      page: () => const CoinRechargePage(),
    ),
    GetPage(
      name: settings,
      page: () => const SettingsPage(),
    ),
    GetPage(
      name: retrieveAccount,
      page: () => const RetrieveAccountPage(),
    ),
    GetPage(
      name: scanCredentials,
      page: () => const ScanCredentialsPage(),
    ),
    GetPage(
      name: webPage,
      page: () => const WebViewPage(),
    ),
    GetPage(
      name: videoPlayer,
      page: () => const VideoPlayPage(),
    ),
    GetPage(
      name: share,
      page: () => const SharePage(),
    ),
    // GetPage(
    //   name: videoLivePlayer,
    //   page: () => const VideoLivePlayerPage(),
    // ),
    GetPage(
      name: gameDeposit,
      page: () => const DepositPage(),
    ),
    GetPage(
      name: gameWithdrawal,
      page: () => const WithdrawalPage(),
    ),
    GetPage(
      name: undress,
      page: () => const UndressPage(),
    ),
    GetPage(
      name: undressRecord,
      page: () => const UndressRecordPage(),
    ),
    GetPage(
      name: louFeng,
      page: () => const CommunityPage(),
    ),
    GetPage(
      name: communityDetails,
      page: () => const CommunityDetailsPage(),
    ),
    GetPage(
      name: tvSeries,
      page: () => const TvSeriesPage(),
    ),
    // GetPage(
    //   name: tvSeriesVideoPlayer,
    //   page: () => const TvSeriesVideoPlayerPage(),
    // ),
    GetPage(
      name: gamePlay,
      //page: () => const GameDetailsPage(),
      page: () => const GamePlayPage(),
    ),
    GetPage(
      name: gameDetails,
      page: () => const GameDetailsPage(),
    ),
    GetPage(
      name: releasePost,
      page: () => const ReleasePostPage(),
    ),
    GetPage(
      name: videoSearch,
      page: () => const VideoSearchPage(),
    ),
    GetPage(
      name: gameActivity,
      page: () => const GameActivityPage(),
    ),
    GetPage(
      name: workMore,
      page: () => const WorkMorePage(),
    ),
    GetPage(
      name: comicsRead,
      page: () => const ComicsReadPage(),
    ),
    GetPage(
      name: novelRead,
      page: () => const NovelReadPage(),
    ),
    GetPage(
      name: workSearch,
      page: () => const WorkSearchPage(),
    ),
    GetPage(
      name: comicsSearch,
      page: () => const ComicsSearchPage(),
    ),
    GetPage(
      name: novelSearch,
      page: () => const NovelSearchPage(),
    ),

    GetPage(
      name: tvSeriesSearch,
      page: () => const TvSeriesSearchPage(),
    ),
    GetPage(
      name: videoApp,
      page: () => const VideoAppPage(),
    ),
    GetPage(
      name: coupon,
      page: () => const CouponPage(),
    ),
    GetPage(
      name: favor,
      page: () => const FavorPage(),
    ),
    GetPage(
      name: orderHistory,
      page: () => const OrderHistoryPage(),
    ),
    GetPage(
      name: gameWithdrawalRecord,
      page: () => const WithdrawalRecordPage(),
    ),
    GetPage(
      name: workDetail,
      page: () => const WorkDetailPage(),
        preventDuplicates: false
    ),
    GetPage(
        name: liveRoom,
        //page: () => DeviceUtil.isAndroid ? const LiveRoom() : const LiveRoomIos(),
        page: () => const LiveRoomIos(),
    ),
  ];
}
