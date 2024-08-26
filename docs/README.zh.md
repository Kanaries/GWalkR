<img src="./img/hex_logo.png" align="right" alt="logo" width="120" height = "139" style = "border: none; float: right;">

# GWalkR: 一行代码将数据集转化为交互式可视化分析工具

[![arxiv](https://img.shields.io/badge/arXiv-2406.11637-b31b1b.svg)](https://arxiv.org/abs/2406.11637)
[![CRAN
status](https://www.r-pkg.org/badges/version/GWalkR)](https://CRAN.R-project.org/package=GWalkR)
![](https://img.shields.io/github/actions/workflow/status/kanaries/GWalkR/web-app-build.yml?style=flat-square)
![](https://img.shields.io/github/license/kanaries/GWalkR?style=flat-square)
[![](https://img.shields.io/badge/twitter-kanaries_data-03A9F4?style=flat-square&logo=twitter)](https://twitter.com/kanaries_data)
[![](https://img.shields.io/discord/987366424634884096?color=%237289da&label=Discord&logo=discord&logoColor=white&style=flat-square)](https://discord.com/invite/WWHraZ8SeV)

一行代码，开启您在R中的数据探索之旅！

[GWalkR](https://github.com/Kanaries/GWalkR) 是R中的交互式探索性数据分析（EDA）工具。
它整合了htmlwidgets和 [Graphic Walker](https://github.com/Kanaries/graphic-walker)。
通过将您的数据框转换为Tableau风格的用户界面进行可视化探索，它可以简化您的R数据分析和数据可视化工作流程。


<img width="1437" alt="image" src="https://github.com/Bruceshark/GWalkR/assets/33870780/26967dda-57c0-4abd-823c-63037c8f5168">

> 如果你喜欢使用Python，你可以在Python中使用[PyGWalker](https://github.com/Kanaries/pygwalker)。

## 快速开始

### 安装 GWalkR

```R
install.packages("GWalkR")
library(GWalkR)
```

### 用一行代码开始您的数据探索吧

```R
data(iris)
gwalkr(iris)
```

<img width="1437" alt="image" src="https://github.com/Bruceshark/GWalkR/assets/33870780/718d8ff6-4ad5-492d-9afb-c4ed67573f51">

## 主要功能
### 查看数据概览
<img width="700" alt="image" src="https://github.com/bruceyyu/GWalkR/assets/33870780/67131cfa-a25b-44ae-90a0-95902ea5edb1">

### 通过简单的拖拽操作创建数据可视化
<img width="700" alt="image" src="https://github.com/Bruceshark/GWalkR/assets/33870780/718d8ff6-4ad5-492d-9afb-c4ed67573f51">

### 发现有趣的数据点？使用笔刷功能进一步分析！
<img width="700" alt="image" src="https://github.com/bruceyyu/GWalkR/assets/33870780/8033885d-3699-4f50-84e1-2201b3846b5a">

### 为R Notebook（如R Markdown）提供强大支持

在网页上展示可编辑和交互的图表，让您的数据洞察更加生动 [(示例)]((https://bruceyyu.github.io/show/tidytuesday_etymology.nb.html))。

<img width="700" alt="image" src="https://github.com/bruceyyu/GWalkR/assets/33870780/4798367c-0dd4-4ad3-b25b-7ea48b79205a">

## 开发指南
我们欢迎来自开源社区的开发者帮助改进此R包！

由于构建的Web库不被Git追踪，这里的源代码无法直接运行。请按以下步骤在您的设备上运行源代码：

1. 运行 `git clone https://github.com/Kanaries/GWalkR.git` 克隆此仓库。
2. 进入 `/web_app` 并运行 `yarn install`。
3. 您可以在TypeScript代码的Web应用或 `/R` 目录下的R脚本中实现您的功能。
4. 运行 `yarn run build` 构建Web应用，并确保构建后的库位于 `/inst/htmlwidgets/lib/` 下。
5. 在R Studio中运行 `devtools::load_all("{GWalkR的路径}")` 来加载包（确保您已经卸载了从CRAN安装的GWalkR）。

如需了解更多R包开发的相关信息，请参考 [*R Packages*](https://r-pkgs.org/) 这本书。