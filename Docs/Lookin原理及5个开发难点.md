# Lookin 原理及 5 个开发难点

Lookin 是一款 iOS 开发时常用的调试软件。

作为作者，本文将首次介绍它的运作原理、5 个开发难点及解决方案。

如果你要做类似的调试软件，本文可能会帮你少踩一些坑。

桌面端代码：https://github.com/hughkli/Lookin
iOS 端代码：https://github.com/QMUI/LookinServer

![](https://cdnfile.lookin.work/static_images/doc0412/doc_1.png)

## 竞品对比
![](https://cdnfile.lookin.work/static_images/doc0412/doc_2.png)

抛开不太好用的 Xcode UI Inspector 不谈，它的主要竞品是国外收费的 Reveal。

概括来说，二者在刷新速度等性能方面差异不大，但 Reveal 作为收费、成熟的商业团队产品，功能更全更稳定，文档完善，且有着很好的迭代节奏。

而 Lookin 功能较少、迭代较慢，尤其在布局约束调试方面很弱，但有着免费开源的优点，且不乏测距、变量名显示等小的亮点功能。

更多细节对比可以参阅一篇网友文章： 《A Side-By-Side Comparison of Two Great iOS Views Debugging Tools》：https://betterprogramming.pub/a-side-by-side-comparison-of-two-great-ios-views-debugging-tools-85fefbf69881
![](https://cdnfile.lookin.work/static_images/doc0412/doc_3.png)

## 主要原理
![](https://cdnfile.lookin.work/static_images/doc0412/doc_4.png)

当你在 macOS 端点击“刷新”时，大概会发生以下过程：

* 你需要先在你的 iOS 项目中集成 LookinServer 这个 framework，然后它可以和 LookinClient 收发数据
* 先通过 Ping/Pong 确认 iOS 端没有处于后台、断点等无法响应的情况
* Server 端收到 Hierarchy 请求后，遍历所有 View，然后把信息打包发给 Client 端，Client 端重新组装为图层树
* Server 端陆续收集每一个 View 的截图、属性列表，然后先后打包发送给 Client 端，以供 Client 端渲染出更详细的数据，这个过程可能长达 3 ～ 10 秒
* Client 端会把“当前用户正在操作哪些 views”的信息不断告知 Server 端，Server 端会据此调整当前打包任务的优先级，以求优先打包收集那些用户关注的 View 信息

以上就是原理了，总结来说非常简单，就是典型的 C/S 架构：Client 端请求需要的信息，Server 端通过 Runtime 接口拿到数据后，打包发回给 Client 端就好了。

但要把实际产品落地的话，还有很多的细节问题要处理，下面会罗列出当时花了不少时间去尝试解决的问题。

## 困难点

### iOS 程序员如何学习写 macOS 程序？
这似乎不是个值得讨论的“技术问题”，但实际上，这恰恰是最现实、最花时间的问题，主要是两个痛苦点：
* 和年轻的 UIKit 比起来，AppKit 的历史包袱很重，很多 API 非常晦涩难用
* 由于从业者少，macOS 的开发资料极少，遇到 Bug 之类的完全搜不出来，要自己踩坑

当时的我可能花了 150 个小时在这方面。

### 如何在 macOS 和 iOS 之间传输数据？

当时觉得这个问题非常底层非常 geek，但后来惊喜地发现其实有大量的第三方库可以直接使用，比如：Peertalk、CocoaAsyncSocket、GCDWebServer、MultipeerConnectivity……

由于时间关系，当时只尝试了 Peertalk，因此我无法比较它们的优劣。

但 Peertalk 只能帮你单向传输数据而不保证送达，就像 UDP 一样。比如 Server 端处于后台、主线程卡住等情况就收不到数据。因此你需要在它的基础上封装一层类似 HTTP 风格的接口出来，还要处理 timeout、多台 iOS 设备同时连接、双端版本校验、断链重试、一个请求多个回复等各种细节。

我在解决了上述部分细节问题后，把通讯部分独立出了一个组件：https://github.com/hughkli/KKConnector

### 如何正确渲染展开/折叠图像？
![](https://cdnfile.lookin.work/static_images/doc0412/doc_5.png)

如上图，我们在展开/折叠图层时，图像会跟随变化，直觉上很自然，但这个“变化”的规则到底是什么呢？
 
最初的错误想法是：给每个 View 都截一张图片，那么“展开/折叠”就是改变这个图片的 Z-Index。换句话说，如果把全部节点都折叠起来只留下一个 UIWindow，那么就把所有图片的 Z-Index 置为 0 即可。

但实践发现行不通，如下图所示，界面的渲染并不是简单的“把每个图层叠放在一起”，还有 ClipsToBounds 等各种逻辑。 
![](https://cdnfile.lookin.work/static_images/doc0412/doc_6.png)

对此，Lookin 和 Reveal 的最终做法是：利用 drawViewHierarchyInRect 或 renderInContext 这两个 API 给每个 UIView/CALayer 都生成两张截图：
1. 包含所有 subviews 的截图，我们称之为 GroupScreenshot
2. 把所有 subviews 都隐藏然后进行截图，我们称之为 SoloScreenshot

然后：

3. 当一个节点被展开时，使用 SoloScreenshot 去渲染这个节点
4. 当一个节点被收起时，使用 GroupScreenshot 去渲染这个节点

### 如何渲染 3D 图像？

![](https://cdnfile.lookin.work/static_images/doc0412/doc_7.gif)

最初的 0.9.3 beta 版本的方案：
*