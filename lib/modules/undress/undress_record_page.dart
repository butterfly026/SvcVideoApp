import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/widgets/keep_alive_widget.dart';
import 'package:get/get.dart';
import 'undress_record_list.dart';

class UndressRecordPage extends StatefulWidget {
  const UndressRecordPage({super.key,});

  @override
  State<StatefulWidget> createState() => _UndressRecordPageState();
}

class _UndressRecordPageState extends State<UndressRecordPage> with TickerProviderStateMixin {
  List<(String, int)> tabList = [("排队中", 1), ('生成成功', 2), ("生成失败", 3)];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabList.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("一键脱衣"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
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
                    Tab(text: tabList[index].$1)),
          ),
        ),
        body: TabBarView(
          children: tabList.map((e){
            return  KeepAliveWidget(
                child: UndressRecordList(taskStatus: e.$2));
          }).toList(),),
      ),
    );
  }
}
