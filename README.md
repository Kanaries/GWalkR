# GWalkR: Your One-Stop R Package for Exploratory Data Analysis with Visualization

Start Exploratory Data Analysis (EDA) in R with a Single Line of Code!
[GWalkR](https://github.com/Kanaries/GWalkR) is an interactive Exploratory Data Analysis (EDA) Tool in R.
It integrates the htmlwidgets with [Graphic Walker](https://github.com/Kanaries/graphic-walker).
It can can simplify your R data analysis and data visualization workflow, by turning your data frame into a Tableau-style User Interface for visual exploration.

<img width="1437" alt="image" src="https://github.com/Bruceshark/GWalkR/assets/33870780/26967dda-57c0-4abd-823c-63037c8f5168">


## Getting Started

### Setup GWalkR

#### Through Package Archive File (.tar.gz)

First, download the package archive file `GWalkR_0.1.0.tar.gz` from the Github release.
Open R Studio, click "Install" in the "Packages" window, and select "Package Archive File (.tgz; .tar.gz)" in the "Install from". Then, select the archive in your file system and click "Install".

#### Through Running R Script

Alternatively, you can run the following R code in your script to download without a lot of clicking.

```R
url <- "https://github.com/Bruceshark/GWalkR/releases/download/preview/GWalkR_0.1.0.tar.gz"
destfile <- "GWalkR_0.1.0.tar.gz"
download.file(url, destfile)
install.packages(destfile, repos = NULL, type = "source")
```

#### Through CRAN

To be supported soon. Stay tuned!


### Start Your Data Exploration in a Single Line of Code

```R
library(GWalkR)
data(iris)
gwalkr(iris)
```

