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
* Server 端陆续收集每一个 View 的截图、属性列表，然后先后