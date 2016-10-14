---
title: "Time series motif discovery."
published: true
morea_id: motifs
morea_summary: "Time series recurrent patterns discovery."
morea_type: reading
morea_sort_order: 3
---

# Finding recurrent patterns in time series using SAX.

# Introduction

For this example I use one of the datasets from [The UCR Time Series Classification/Clustering page & collection of test datasets](http://www.cs.ucr.edu/~eamonn/time_series_data/) - [this one](http://www.cs.ucr.edu/~eamonn/discords/qtdbsele0606.txt) which represents excerpt of two-channel ECG Holter recording. The figure below shows the normalized fragment (from 4779 to 7779) of the heartbeat series:

http://jmotif.googlecode.com/svn/trunk/RCode/motifs/raw_heartbeat.png

The call of `SAXFactory.seriesToDiscordsAndMotifs` allows to find motifs with JMotif library in a single code line:
```
  public static void main(String[args) throws Exception {

    Instances tsData = readTSData();

    DiscordsAndMotifs dr = SAXFactory.seriesToDiscordsAndMotifs(toDoubleSeries(tsData), windowSize,
        alphabetSize, 2, 2);

    System.out.println(dr.toString());

  }
```

(The full code to get instances and convert into double is here [http://jmotif.googlecode.com/svn-history/r368/trunk/src/edu/hawaii/jmotif/webexample/MotifsDiscordsExample.java MotifsDiscordsExample.java](]))
The output of this code when applied to the plotted segment of heartbeat series is like this: 
```
Motifs, as a list <frequency> [<offset1>,...,<offsetN>], from last to first:
51 at [122, 123, 124, 422, 423, 570, 571, ...
57 at [106, 107, 108, 109, 110, 257, 258, ... 

Discords, as a list <distance> <offset>, from last to first:
4.214421668509215 at 2305
6.7017497715148995 at 2019
```

which informs us about two top motifs and two top discords which are highlighted in two figures below:

http://jmotif.googlecode.com/svn/trunk/RCode/motifs/motifs_heartbeat.png

here I highlighted all of the occurrences of the first motif which was observed `57` times at `[106, 107, 108, 109, 110, 257, 258, ... `. Note that this method reports all of the motif' occurrences so you might want to perform some reduction, like to reduce `106, 107, 108, 109 & 110` to `106` - the very first occurrence, etc.

http://jmotif.googlecode.com/svn/trunk/RCode/motifs/discord_motifs_heartbeat.png

here I highlighted the first discord occurrence in addition to the first motif occurences.