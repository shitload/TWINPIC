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

更多细节对比可以参阅一篇网友文章：