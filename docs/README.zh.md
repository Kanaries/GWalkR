<img src="./img/hex_logo.png" align="right" alt="logo" width="120" height = "139" style = "border: none; float: right;">

# GWalkR: 一行代码将数据集转化为交互式可视化分析工具

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

#### 通过 CRAN 安装 （推荐）

```R
install.packages("GWalkR")
```

#### 通过运行R脚本安装

如果您已在R中安装了`devtools`，您可以在脚本中运行以下R代码来下载。

```R
devtools::install_url("https://kanaries-app.s3.ap-northeast-1.amazonaws.com/oss/gwalkr/GWalkR_latest.tar.gz")
```

#### 通过下载 .tar.gz 文件包安装

或者，从[这个链接](https://kanaries-app.s3.ap-northeast-1.amazonaws.com/oss/gwalkr/GWalkR_latest.tar.gz)中下载包 GWalkR_latest.tar.gz。
打开 R Studio，点击 "Packages" 窗口中的 "Install"，然后在 "Install from" 中选择 "Package Archive File (.tgz; .tar.gz)"。然后，选择您的文件系统中的下载好的包，最后点击"Install"。

### 用一行代码开始您的数据探索吧

```R
library(GWalkR)
data(iris)
gwalkr(iris)
```

<img width="1437" alt="image" src="https://github.com/Bruceshark/GWalkR/assets/33870780/718d8ff6-4ad5-492d-9afb-c4ed67573f51">

