import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/favor/favor_cat.dart';
import 'package:flutter_video_community/global/widgets/state/empty_view.dart';
import 'package:flutter_video_community/modules/favor/favor_list.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/keep_alive_widget.dart';
import 'package:get/get.dart';
import 'favor_controller.dart';

class FavorPage extends StatefulWidget {
  const FavorPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _FavorPageState();
}

class _FavorPageState extends State<FavorPage> with TickerProviderStateMixin {
  final _controller = Get.put(FavorController());
  late TabController tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<FavorCatModel> tabList = _controller.tabList;

      return DefaultTabController(
        length: tabList.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("我的收藏"),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              },
            ),
            actions: [
              IconButton(
                constraints: const BoxConstraints.expand(width: 100),
                icon: Text(
                  _controller.editable.value ? '完成' : '管理',
                 style: TextStyle(
                 fontSize: Dimens.font_sp18,
                fontWeight: FontWeight.w500,
                      ),
                ), onPressed: () {
                _controller.editable.value = !_controller.editable.value;
              },)
            ],
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: Images.imgBgHeader, fit: BoxFit.fitWidth)),
            ),
            bottom: TabBar(
              unselectedLabelColor: const Color(0xFF626773),
              unselectedLabelStyle: const TextStyle(
                fontSize: 20
              ),
              labelColor: const Color(0xFFF9552A),
              labelStyle: const TextStyle(
                fontSize: 22
              ),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: const Color(0xFFF9552A),
              indicatorWeight: 3,
              tabs: List.generate(tabList.length,
                      (index) =>
                      Tab(text: tabList[index].name)),
            ),
          ),
          body: tabList.isNotEmpty ? Stack(
            children: [
              TabBarView(
                children: tabList.map((e){
                  return  KeepAliveWidget(
                      child: FavorList(type: e.getType(), route: e.url, openWay: e.openWay,));
                }).toList(),),
              if (_controller.favorDelList.isNotEmpty) Positioned(
                bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                color: Colors.red,
                    child: GradientButton(
                      text: '删除收藏',
                      width: double.infinity,
                      height: double.infinity,
                      onTap: () {
                        _controller.delFavorList();
                        //_controller.readChapterContent();
                      },
                    ),
              ))
            ],
          ) : const EmptyView(),
        ),
      );
    });
  }

//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           const Image(
//             image: Images.imgBgHeader,
//             fit: BoxFit.fitWidth,
//           ),
//           Column(
//             children: [
//               CustomAppBar(
//                 title: const Text('收藏'),
//                 backgroundColor: Colors.transparent,
//                 systemOverlayStyle: const SystemUiOverlayStyle(
//                   statusBarColor: Colors.transparent,
//                   statusBarIconBrightness: Brightness.dark,
//                 ),
//               ),
//               Expanded(
//                 child: TabBarView(
//                   controller: tabController,
//                   children: _controller.tabList.map(
//                     (element) {
//                       if (element.openWay == LaunchType.web.value) {
//                         return KeepAliveWidget(
//                           child: WebAppPage(
//                             data: element.toWebData(),
//                           ),
//                         );
//                       }
//                       return KeepAliveWidget(
//                         child: Container(),
//                       );
//                     },
//                   ).toList(),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ));
// }
}
