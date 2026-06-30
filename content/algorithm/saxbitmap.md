---
title: "SAX bitmap patterns visualization"
weight: 9
pagekind: "reading"
summary: "How to use SAX for bitmap-like time series pattern visualization."
labels:
  - algorithm
---
As the authors of this technique explained, the time series bitmap is ["...a simple
parameter-light tool that allows users to efficiently navigate through large collections of time series..."](https://www.cs.ucr.edu/~eamonn/time_series_bitmaps.pdf). Based on SAX transform and occurrence frequency counting, the time series bitmap algorithm transforms any input time series (or its segment) into a bitmap, where each SAX word's frequency is mapped to a color cell. Similar series produce similar bitmaps, which makes them easy to scan visually.

> This section is a stub. See the [time series bitmaps paper](https://www.cs.ucr.edu/~eamonn/time_series_bitmaps.pdf) for the full method.
