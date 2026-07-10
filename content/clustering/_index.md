---
title: "Clustering"
weight: 5
summary: "Cluster time series by grouping their SAX-VSM tf·idf bags with k-means or hierarchical clustering."
---
SAX-VSM represents each time series as a **tf·idf-weighted bag of SAX words**. Classification assigns a label by cosine similarity to class vectors; **clustering** groups those same bags without labels — useful for exploratory views of a dataset, dendrograms, or sanity-checking whether classes separate in tf·idf space.

The implementation lives in [`net.seninp.jmotif.cluster`](https://github.com/jMotif/sax-vsm_classic/tree/master/src/main/java/net/seninp/jmotif/cluster) inside [sax-vsm_classic]({{< param github >}}) (`net.seninp:sax-vsm:2.0.1` on Maven Central). Distances are **cosine distance** on the sparse tf·idf vectors — the same geometry as the [classifier]({{< ref "/classification" >}}).

## Input format

Both clusterers take a map `HashMap<String, HashMap<String, Double>>`:

- **outer key** — bag id (typically a time series name or index);
- **inner map** — SAX word → tf·idf weight for that bag.

Build this from training data with the same SAX parameters you would use for classification (`TextProcessor` / SAX-VSM training pipeline in the Java library).

## k-means

[`TextKMeans.cluster`](https://github.com/jMotif/sax-vsm_classic/blob/master/src/main/java/net/seninp/jmotif/cluster/TextKMeans.java) runs Lloyd-style k-means on the bags. Choose the number of clusters and an initial-centroid strategy (`RandomStartStrategy`, `FurthestFirstStrategy`, or a custom `StartStrategy`). The method returns `HashMap<String, List<String>>` mapping each cluster id to the bag names assigned to it.

```java
import net.seninp.jmotif.cluster.RandomStartStrategy;
import net.seninp.jmotif.cluster.TextKMeans;

HashMap<String, List<String>> clusters = TextKMeans.cluster(tfidf, 3, new RandomStartStrategy());
```

## Hierarchical clustering

[`HC.Hc`](https://github.com/jMotif/sax-vsm_classic/blob/master/src/main/java/net/seninp/jmotif/cluster/HC.java) builds an agglomerative hierarchy over the bags using a precomputed cosine-distance matrix. Pass a [`LinkageCriterion`](https://github.com/jMotif/sax-vsm_classic/blob/master/src/main/java/net/seninp/jmotif/cluster/LinkageCriterion.java) (`SINGLE`, `COMPLETE`, `UPGMA`, and others). The result is a [`Cluster`](https://github.com/jMotif/sax-vsm_classic/blob/master/src/main/java/net/seninp/jmotif/cluster/Cluster.java) tree; call `toNewick()` to export a Newick dendrogram string for external viewers.

```java
import net.seninp.jmotif.cluster.Cluster;
import net.seninp.jmotif.cluster.HC;
import net.seninp.jmotif.cluster.LinkageCriterion;

Cluster tree = HC.Hc(tfidf, LinkageCriterion.COMPLETE);
String newick = "(" + tree.toNewick() + ")";
```

## Example in the source tree

[`TestTextKMeans`](https://github.com/jMotif/sax-vsm_classic/blob/master/src/test/java/net/seninp/jmotif/cluster/TestTextKMeans.java) runs both k-means and hierarchical clustering on a small synthetic tf·idf map and writes a Newick file. Unit tests in the same package cover linkage and centroid updates.

There is no dedicated CLI entry point for clustering yet — call the classes from Java, or build bags in Python/R and cluster in Java if you need the exact SAX-VSM weighting.
