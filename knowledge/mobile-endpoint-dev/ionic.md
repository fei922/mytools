# 移动开发框架Ionic 学习

>ionic 是一个强大的 HTML5 应用程序开发框架(HTML5 Hybrid Mobile App Framework )。 
可以帮助您使用 Web 技术，比如 HTML、CSS 和 Javascript 构建接近原生体验的移动应用程序。

> ionic 主要关注外观和体验，以及和你的应用程序的 UI 交互，
特别适合用于基于 Hybird 模式的 HTML5 移动应用程序开发。

> ionic是一个轻量的手机UI库，具有速度快，界面现代化、美观等特点。
为了解决其他一些UI库在手机上运行缓慢的问题，它直接放弃了IOS6和Android4.1以下的版本支持，
来获取更好的使用体验。

### 参考资料

* [Ionic 菜鸟教程](http://www.runoob.com/ionic/ionic-tutorial.html)
* [官网入门](https://ionicframework.com/getting-started)
* [官方完整文档](https://ionicframework.com/docs/)
* [Ionic Pro induction](https://ionicframework.com/docs/pro/)

### 说明

本例中使用的软件环境
* windows 10
* npm  3.10.8
* nodejs 6.9.1
* cordova  8.0.0
* ionic 3.16.0


### 入门

参考[官网入门](https://ionicframework.com/getting-started)

```text
F:\monster\android\ionic>ionic start myApp tabs
√ Creating directory .\myApp - done!
× Downloading and extracting tabs starter - failed!
Error: read ECONNRESET
    at exports._errnoException (util.js:1026:11)
    at TLSWrap.onread (net.js:569:26)
# 由于一开始安装的最新版，会出现一个错误，模版下不下来
# 参考 https://juejin.im/post/5ad541f76fb9a028db592ebe 下面的一个评论 "ionic cli 3.16.0 以下都可以。"
# 将ionic降到3.16.0版本

F:\monster\android\ionic>npm install -g ionic@3.16.0
C:\Users\zhoufeirj\AppData\Roaming\npm\ionic -> C:\Users\zhoufeirj\AppData\Roaming\npm\node_modules\ionic\bin\ionic
- chownr@1.0.1 node_modules\ionic\node_modules\chownr
- eventemitter3@3.1.0 node_modules\ionic\node_modules\eventemitter3
- follow-redirects@1.5.0 node_modules\ionic\node_modules\follow-redirects
- is-extglob@2.1.1 node_modules\ionic\node_modules\http-proxy-middleware\node_modules\is-extglob
- is-glob@3.1.0 node_modules\ionic\node_modules\http-proxy-middleware\node_modules\is-glob
- yallist@3.0.2 node_modules\ionic\node_modules\minipass\node_modules\yallist
- minipass@2.3.3 node_modules\ionic\node_modules\minipass
- fs-minipass@1.2.5 node_modules\ionic\node_modules\fs-minipass
- minizlib@1.1.0 node_modules\ionic\node_modules\minizlib
- requires-port@1.0.0 node_modules\ionic\node_modules\requires-port
- http-proxy@1.17.0 node_modules\ionic\node_modules\http-proxy
- http-proxy-middleware@0.17.4 node_modules\ionic\node_modules\http-proxy-middleware
- yallist@3.0.2 node_modules\ionic\node_modules\tar\node_modules\yallist
- untildify@3.0.3 node_modules\ionic\node_modules\untildify
C:\Users\zhoufeirj\AppData\Roaming\npm
`-- ionic@3.16.0
  +-- @ionic/cli-framework@0.0.2
  `-- @ionic/cli-utils@1.16.0
    +-- proxy-middleware@0.15.0
    `-- tar@2.2.1
      +-- block-stream@0.0.9
      `-- fstream@1.0.11
npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@^1.0.0 (node_modules\ionic\node_modules\chokidar\node_modules\fsevents):
npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@1.2.4: wanted {"os":"darwin","arch":"any"} (current: {"os":"win32","arch":"x64"})

F:\monster\android\ionic> cd myApp

F:\monster\android\ionic\myApp>ionic serve
Starting app-scripts server: --address 0.0.0.0 --port 8100 --livereload-port 35729 --dev-logger-port 53703 --nobrowser -
Ctrl+C to cancel
[10:24:14]  watch started ...
[10:24:14]  build dev started ...
[10:24:14]  clean started ...
[10:24:14]  clean finished in 4 ms
[10:24:14]  copy started ...
[10:24:14]  deeplinks started ...
[10:24:14]  deeplinks finished in 53 ms
[10:24:14]  transpile started ...
[10:24:18]  transpile finished in 3.70 s
[10:24:18]  preprocess started ...
[10:24:18]  preprocess finished in 1 ms
[10:24:18]  webpack started ...
[10:24:18]  copy finished in 4.04 s
[10:24:25]  webpack finished in 7.28 s
[10:24:25]  sass started ...
Without `from` option PostCSS could generate wrong source map and will not find Browserslist config. Set it to CSS file path or to `undefined` to prevent this warning.
[10:24:26]  sass finished in 1.04 s
[10:24:26]  postprocess started ...
[10:24:26]  postprocess finished in 35 ms
[10:24:26]  lint started ...
[10:24:26]  build dev finished in 12.35 s
[10:24:26]  watch ready in 12.46 s
[10:24:26]  dev server running: http://localhost:8100/
[OK] Development server running!
     Local: http://localhost:8100
     External: http://172.26.233.49:8100, http://10.0.75.1:8100, http://10.9.11.168:8100, http://169.254.33.230:8100,
     http://192.168.30.1:8100, http://192.168.223.122:8100
     DevApp: myApp@8100 on zhoufeirj01
[10:24:30]  lint finished in 4.18 s
events.js:160
      throw er; // Unhandled 'error' event
      ^

Error: read ECONNRESET
    at exports._errnoException (util.js:1026:11)
    at TCP.onread (net.js:569:26)

```