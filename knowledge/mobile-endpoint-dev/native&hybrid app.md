# 原生应用native与混合应用hybrid 对比


##### [请问何为混合应用 (Hybrid APP) ，与原生 Native 应用相比它的优劣势。](https://www.nowcoder.com/questionTerminal/f8617b133fc549c3b2630e086c93c32d)

Hybrid APP 是 Native APP 上结合使用了 Web View （Native APP 的模块或称组件，用来加载Web资源），采用了Web 技术的 APP，本质上属于原生应用（APP外壳）。

优势：

兼容性良好，“一次开发，多处运行”，能够减少原生APP开发在多平台带来的问题
代码移植性高
开发者社区活跃，能够及时应用最新适合的Web技术来解决问题，提高用户体验
APP更加轻便，内容更新方便，部分更新不用从 APP Store 下载

劣势：

性能：相对不如 Native APP 性能良好、体验流畅
Web技术在APP中操作权限有限，需要APP同步支持


https://juejin.im/entry/5693197160b27e9ba8dd505a

  Native APP，即所有的程序都由本地组件渲染完成。这类APP优点是显而易见的，渲染速度快、用户体验好；缺点同时也十分突出：出现了错误一定要等待下一次用户进行APP更新才能够修复。

  Web APP的优点恰好就是Native APP的缺点所在，其页面全部采用H5撰写并存放在服务器端。每次进行页面渲染时都从服务器请求最新的页面。一旦页面有错误，服务器端进行更新便能立刻解决。不过其弊端也容易窥见：每次页面都需要请求服务器，造成渲染时等待时间过长，从而导致的用户体验不够完美，并且性能上较Native APP慢了1-2个数量级；与此同时还会导致更多的用户流量消耗。另一个缺点则在于，Web APP在移动端上调用本地的硬件设备存在一定的不便。不过这些弊端也都有相应的解决方案，如PhoneGap将网页提前打包在本地以减少网络的请求时间；同时也提供一系列的插件来访问本地的硬件设备。然而，尽管如此，其渲染速度上还是存在一定的差距。

  Hybrid APP则是综合了二者优缺点的解决方案。饿了么移动对于此二类APP的观点在于，纯粹展示性的模块会更适合使用Web页面来达到渲染的目的；而更多的数据操作性、动画渲染性的模块则更适合采用Native的方式。


### 跨平台移动开发技术

https://sdk.cn/datas?category_id=100108

### 移动端开发框架比较

##### [Weex](https://weex.apache.org/cn/index.html)

> Weex 是一个使用 Web 开发体验来开发高性能原生应用的框架

> Weex 的结构是解耦的，渲染引擎与语法层是分开的，也不依赖任何特定的前端框架，目前主要支持 Vue.js 和 Rax 这两个前端框架。

+ 一次编写，到处运行
+ 挑战React Naitive
+ 阿里巴巴开源的

###### 谁在用

阿里、优酷、淘宝、天猫

目前最新的是0.19 [release](https://github.com/apache/incubator-weex/releases)


###### [atlas](http://atlas.taobao.org/docs/)
