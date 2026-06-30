---
title: "Time series motif discovery."
weight: 3
pagekind: "reading"
summary: "Time series recurrent patterns discovery."
---
## Introduction

This example uses a dataset from the [UCR Time Series Classification/Clustering collection](https://www.cs.ucr.edu/~eamonn/time_series_data/) — [`qtdbsele0606`](https://www.cs.ucr.edu/~eamonn/discords/qtdbsele0606.txt), an excerpt of a two-channel ECG Holter recording. We work with the normalized fragment from points 4779 to 7779 of the heartbeat series.

A single call to `SAXFactory.seriesToDiscordsAndMotifs` finds motifs and discords with the jMotif library:

```java
public static void main(String[] args) throws Exception {
  Instances tsData = readTSData();
  DiscordsAndMotifs dr = SAXFactory.seriesToDiscordsAndMotifs(
      toDoubleSeries(tsData), windowSize, alphabetSize, 2, 2);
  System.out.println(dr.toString());
}
```

The current implementation lives in the [sax-vsm_classic repository]({{< param github >}}); the original jMotif Google Code project that hosted this walkthrough has been retired.

Applied to the heartbeat segment, the output looks like this:

```
Motifs, as a list <frequency> [<offset1>,...,<offsetN>], from last to first:
51 at [122, 123, 124, 422, 423, 570, 571, ...
57 at [106, 107, 108, 109, 110, 257, 258, ...

Discords, as a list <distance> <offset>, from last to first:
4.214421668509215 at 2305
6.7017497715148995 at 2019
```

This reports two top motifs and two top discords. The first motif occurs `57` times at `[106, 107, 108, 109, 110, 257, 258, ...]`. Note that the method reports *every* occurrence, so neighboring offsets such as `106, 107, 108, 109, 110` describe the same recurring pattern under a sliding window — you will usually want to collapse each run to its first offset. The strongest discord (distance `6.70` at offset `2019`) marks the most unusual subsequence in the recording.
