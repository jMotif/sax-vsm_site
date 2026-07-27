---
title: "Time series motif discovery"
weight: 3
pagekind: "reading"
summary: "Finding recurrent patterns (motifs) and discords in a time series with the jmotif-sax library."
---
## Introduction

This example uses a dataset derived from the [PhysioNet QT Database](https://physionet.org/content/qtdb/1.0.0/) — a 2,299-point excerpt of the `sele0606` ECG Holter recording (the same segment used throughout the [GrammarViz tutorials](https://grammarviz2.github.io/grammarviz2_site/), available as [`ecg0606_1.csv`](https://github.com/GrammarViz2/grammarviz2_src/blob/master/data/ecg0606_1.csv)).

The SAX-based motif and discord machinery lives in the [jmotif-sax library](https://github.com/jMotif/SAX) (`net.seninp:jmotif-sax:2.0.2` on Maven Central, and the SAX layer underneath SAX-VSM). Motifs are found with the EMMA algorithm, discords with HOT-SAX:

```java
import net.seninp.jmotif.sax.NumerosityReductionStrategy;
import net.seninp.jmotif.sax.motif.EMMAImplementation;
import net.seninp.jmotif.sax.motif.MotifRecord;
import net.seninp.jmotif.sax.discord.DiscordRecord;
import net.seninp.jmotif.sax.discord.DiscordRecords;
import net.seninp.jmotif.sax.discord.HOTSAXImplementation;

double[] series = /* read the CSV into an array */;

// the most frequent ~heartbeat-length pattern (motif length 100,
// similarity range 0.5, PAA 6, alphabet 4, z-norm threshold 0.01)
MotifRecord motif = EMMAImplementation.series2EMMAMotifs(series, 100, 0.5, 6, 4, 0.01);
System.out.println("motif at " + motif.getLocation() + ", seen " + motif.getFrequency()
    + " times: " + motif.getOccurrences());

// the two most unusual subsequences (window 100, PAA 3, alphabet 3)
DiscordRecords discords = HOTSAXImplementation.series2Discords(series, 2, 100, 3, 3,
    NumerosityReductionStrategy.NONE, 0.01);
for (DiscordRecord d : discords) {
  System.out.println("discord at " + d.getPosition() + ", NN distance " + d.getNNDistance());
}
```

Applied to the heartbeat segment, this prints:

```text
motif at 1690, seen 5 times: [807, 951, 1095, 1837, 2124]
discord at 430, NN distance 5.279080006170648
discord at 318, NN distance 4.175756357304875
```

The motif occurrences are ordinary heartbeats — the recurring shape of the recording. The strongest discord at position 430 marks the most unusual subsequence: the anomalous third heartbeat, first identified in the [HOT SAX paper](https://www.cs.ucr.edu/~eamonn/HOT%20SAX%20%20long-ver.pdf).

Note that EMMA reports each occurrence once per matching subsequence; with a sliding window, neighboring offsets can describe the same underlying pattern, so tight clusters of offsets are usually collapsed to their first member.

For *variable-length* motif and discord discovery — where pattern lengths are not fixed in advance — see the grammar-inference approach in [GrammarViz](https://grammarviz2.github.io/grammarviz2_site/), the sibling project of SAX-VSM.

> Historical note: this walkthrough originally targeted the retired jMotif Google Code project and its `SAXFactory.seriesToDiscordsAndMotifs` API; the example above uses the current [jmotif-sax](https://github.com/jMotif/SAX) API and was verified against version 2.0.1; the motif/discord API is unchanged in 2.0.2.
