
//用于配置webview
class WebViewOption {

  bool getTitle = false;
  bool showLoading = true; //网页加载完之前的加载动画
  //webview是否代理系统返回事件, 如果true, webview有回退历史,则在返回webview里的页面
  //比如native-> webA -> webB, 如果为true, 点手机返回则从webB ->  webA -> native
  //如果为false, 点手机返回则从webB -> native
  //bool backProxy = false;
}