enum TabEnum {
  hot,
  home,
  crack,
  live,
  game,
  community,
  mine,
  novel,
  comics,
  tv,
  lFeng,
  lFengHall,
  lFengPeripheral,
  lFengEscort,
}

class TabMatcher {
  static TabEnum match(String value) {
    return TabEnum.values.firstWhere(
      (element) => value == element.value,
    );
  }
}

extension TabEnumExtension on TabEnum {
  String get value {
    switch (this) {
      case TabEnum.hot:
        return '热门';
      case TabEnum.home:
        return '首页';
      case TabEnum.crack:
        return '爆料';
      case TabEnum.live:
        return '直播';
      case TabEnum.game:
        return '游戏';
      case TabEnum.community:
        return '约炮';
      case TabEnum.mine:
        return '我的';
      case TabEnum.novel:
        return '小说';
      case TabEnum.comics:
        return '漫画';
      case TabEnum.tv:
        return 'tv影视';
      case TabEnum.lFeng:
        return '楼凤';
      case TabEnum.lFengHall:
        return '楼凤大厅';
      case TabEnum.lFengPeripheral:
        return '认证外围';
      case TabEnum.lFengEscort:
        return '伴游包养';
    }
  }

  String get type {
    switch (this) {
      case TabEnum.hot:
        return 'app://hot';
      case TabEnum.home:
        return 'app://home';
      case TabEnum.crack:
        return 'app://crack';
      case TabEnum.live:
        return 'app://live';
      case TabEnum.game:
        return 'app://game';
      case TabEnum.community:
        return 'app://community';
      case TabEnum.mine:
        return 'app://mine';
      case TabEnum.novel:
        return 'app://novel';
      case TabEnum.comics:
        return 'app://comics';
      case TabEnum.tv:
        return 'app://tv';
      case TabEnum.lFeng:
        return 'app://lFeng';
      case TabEnum.lFengHall:
        return 'app://lfeng_hall';
      case TabEnum.lFengPeripheral:
        return 'app://lfeng_peripheral';
      case TabEnum.lFengEscort:
        return 'app://lfeng_escort';
    }
  }
}
