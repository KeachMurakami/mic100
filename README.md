
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `mic100`

<!-- badges: start -->

<!-- badges: end -->

Simple functions for MIC-100.

## Workflow

``` r
library(mic100)

# ファイル名、記録時刻、光合成速度をまとめたファイルを出力
# これに対応する試験区コードなどを記入することになる
annotate_mic(path = "path_to_CSV_dir", output = "path_to_annotate_csv")

# 測定時気温等を含むデータを取得
read_mic(file = "hogehoge.csv")

# CO2濃度推移を含む詳細データを取得
read_mic(file = "hogehoge.csv", simple = FALSE)
```
