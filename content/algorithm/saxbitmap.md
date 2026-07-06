---
title: "SAX bitmap patterns visualization"
weight: 9
pagekind: "reading"
summary: "Turning SAX word frequencies into color bitmaps for at-a-glance comparison of large time series collections."
labels:
  - algorithm
---
As the authors of this technique put it, the time series bitmap is ["...a simple parameter-light tool that allows users to efficiently navigate through large collections of time series..."](https://www.cs.ucr.edu/~eamonn/time_series_bitmaps.pdf). Based on the SAX transform and frequency counting, the technique converts any time series (or a segment of one) into a small color image.

The construction works as follows. The series is discretized with SAX, and every subword of a chosen length *L* (in bitmap terms, the *level*: level 1 counts single letters, level 2 counts pairs, and so on) is tallied. The \(a^{L}\) possible subwords are arranged in a fixed grid — for the 4-letter alphabet, a 2×2 grid at level 1, 4×4 at level 2 — in the recursive layout familiar from Chaos Game representations of DNA sequences. Each cell is then colored by the (normalized) frequency of its subword.

Two properties make the result useful. First, similar time series produce similar bitmaps, so a wall of thumbnails can be scanned visually, and anomalous series stand out immediately. Second, the bitmap distance (Euclidean distance between the frequency grids) is cheap to compute, so bitmaps double as features for clustering, classification, and anomaly detection over large collections — without any parameter tuning beyond the SAX alphabet and the level.

The same frequency-counting idea underlies the SAX-VSM classifier on this site: where the bitmap arranges word counts into an image for the human eye, SAX-VSM feeds them through [tf·idf]({{< ref "/algorithm/tfidf" >}}) for the classifier. See the [time series bitmaps paper](https://www.cs.ucr.edu/~eamonn/time_series_bitmaps.pdf) for the full method, including the clustering and anomaly-detection applications.
