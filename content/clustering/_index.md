---
title: "Clustering"
weight: 5
summary: "Cluster individual time series in SAX-VSM tf·idf space — CBF walkthrough with k-means and hierarchical clustering."
---
Classification in SAX-VSM merges every training series of a class into **one tf·idf bag per class**. **Clustering** uses the same discretization and weighting but keeps **one bag per series**, then groups those vectors in cosine space. That is useful for exploratory views, dendrograms, or checking whether classes separate before you train a classifier.

The implementation is [`net.seninp.jmotif.cluster`](https://github.com/jMotif/sax-vsm_classic/tree/master/src/main/java/net/seninp/jmotif/cluster) in [sax-vsm_classic]({{< param github >}}) (`net.seninp:sax-vsm:2.0.1`). Distances are **cosine similarity** on tf·idf vectors — the same geometry as the [classifier]({{< ref "/classification" >}}).

## 1. CBF example

The [Cylinder–Bell–Funnel (CBF)](https://www.cs.ucr.edu/~eamonn/time_series_data/) benchmark is the clearest clustering demo in this stack: three distinct shapes, 100% classifier accuracy on the full test set at `-w 60 -p 8 -a 6`, and near-perfect unsupervised splits on the bundled 30-series train sample.

{{< fig src="cbf_clustering_overview.png" w="900" alt="CBF clustering: single-linkage dendrogram and 3×3 grid of Cylinder, Bell, and Funnel training series" >}}

*Single-linkage dendrogram on per-series tf·idf (top) and training shapes (bottom). Figure from [`cbf_clustering_plots.R`](https://github.com/jMotif/sax-vsm_classic/blob/master/src/resources/RCode/cbf_clustering_plots.R) in the Java repo.*

### Results on bundled train subsets

Same SAX parameters as the [classifier tutorial]({{< ref "/classification" >}}) (`EXACT` numerosity reduction, threshold `0.01`). **Purity** = fraction of series whose true class matches the plurality label in their cluster.

| Dataset | Train series | *k* | Classifier test error | k-means purity | HC single purity (*k*-cut) |
|---------|:------------:|:---:|----------------------:|---------------:|---------------------------:|
| **CBF** | 30 | 3 | **0.00** (900 test) | **0.90** (furthest-first, seed 2) | **1.00** |
| Gun_Point | 50 | 2 | **0.0133** (150 test) | **0.86** (furthest-first, seed 21) | 0.52–0.56 (root cut) |

CBF separates cleanly with single-linkage hierarchical clustering and a 3-way [`partition(k)`](https://github.com/jMotif/sax-vsm_classic/blob/master/src/main/java/net/seninp/jmotif/cluster/Dendrogram.java) cut. Gun_Point is harder: k-means recovers most of the structure but is seed-sensitive; a naive 2-cluster cut at the dendrogram root does not match the two motion classes.

## 2. Build tf·idf and cluster in Java

The facade [`SAXVSMClustering`](https://github.com/jMotif/sax-vsm_classic/blob/master/src/main/java/net/seninp/jmotif/cluster/SAXVSMClustering.java) mirrors [`SAXVSMEvaluator`](https://github.com/jMotif/sax-vsm_classic/blob/master/src/main/java/net/seninp/jmotif/SAXVSMEvaluator.java): read labeled UCR data, build per-series vectors, then cluster.

| Method | Role |
|--------|------|
| `seriesTfidf(data, params)` | One tf·idf row per series (`class:index` id); shared vocabulary |
| `kMeans(tfidf, k, init, seed)` | Lloyd k-means on cosine similarity |
| `hierarchical(tfidf, linkage)` | Agglomerative tree (`SINGLE` or `COMPLETE`) |
| `seriesLabels(data)` | True class per series id (for purity) |

```java
import java.util.List;
import java.util.Map;
import net.seninp.jmotif.cluster.ClusterAssignments;
import net.seninp.jmotif.cluster.Dendrogram;
import net.seninp.jmotif.cluster.KMeansInit;
import net.seninp.jmotif.cluster.Linkage;
import net.seninp.jmotif.cluster.SAXVSMClustering;
import net.seninp.jmotif.sax.NumerosityReductionStrategy;
import net.seninp.jmotif.text.Params;
import net.seninp.util.UCRUtils;

Map<String, List<double[]>> train =
    UCRUtils.readUCRData("src/resources/data/cbf/CBF_TRAIN");
Params params = new Params(60, 8, 6, 0.01, NumerosityReductionStrategy.EXACT);

Map<String, Map<String, Double>> tfidf = SAXVSMClustering.seriesTfidf(train, params);
Map<String, String> labels = SAXVSMClustering.seriesLabels(train);

ClusterAssignments km =
    SAXVSMClustering.kMeans(tfidf, 3, KMeansInit.FURTHEST_FIRST, 2L);
System.out.printf("k-means purity: %.2f%n", km.labelPurity(labels));

Dendrogram tree = SAXVSMClustering.hierarchical(tfidf, Linkage.SINGLE);
ClusterAssignments hc = tree.partition(3);
System.out.printf("HC purity: %.2f%n", hc.labelPurity(labels));
System.out.println("Newick: (" + tree.toNewick() + ")");
```

Expected on the bundled CBF train file: k-means purity **0.90**, single-linkage `partition(3)` purity **1.00** (locked in [`TestSAXVSMClustering`](https://github.com/jMotif/sax-vsm_classic/blob/master/src/test/java/net/seninp/jmotif/cluster/TestSAXVSMClustering.java)).

## 3. Command-line clustering

[`SAXVSMClusteringCLI`](https://github.com/jMotif/sax-vsm_classic/blob/master/src/main/java/net/seninp/jmotif/cluster/SAXVSMClusteringCLI.java) mirrors [`SAXVSMClassifier`](https://github.com/jMotif/sax-vsm_classic/blob/master/src/main/java/net/seninp/jmotif/SAXVSMClassifier.java): only **train** data is required (no test file). SAX options are the same (`-w`, `-p`, `-a`, `--strategy`, `--threshold`).

| Option | Default | Meaning |
|--------|---------|---------|
| `-train` / `--train_data` | *(required)* | UCR-format training file |
| `-k` / `--clusters` | `3` | Number of clusters |
| `-m` / `--method` | `kmeans` | `kmeans` or `hierarchical` |
| `--linkage` | `single` | `single` or `complete` (hierarchical only) |
| `--init` | `furthest_first` | `random` or `furthest_first` (k-means only) |
| `--seed` | `0` | k-means initialization seed |
| `--newick_out` | — | Optional file for hierarchical Newick output |

```bash
java -cp "target/sax-vsm-2.0.1-jar-with-dependencies.jar" \
  net.seninp.jmotif.cluster.SAXVSMClusteringCLI \
  -train src/resources/data/cbf/CBF_TRAIN -k 3 -w 60 -p 8 -a 6 \
  --init furthest_first --seed 2
```

Stdout ends with a summary line and per-cluster label counts, e.g. `clustering results: ... purity 0.90`. Hierarchical runs also print `newick: (...)` and accept `--newick_out`.

## 4. Lower-level API and figures

- **`ClusterAssignments`** — `clusterOf(id)`, `members(k)`, `labelPurity(trueLabels)`
- **`Dendrogram`** — `toNewick()`, `partition(k)` for a greedy *k*-way cut
- **`TextProcessor.perSeriesWordBags`** — build bags yourself if you need custom ids

For publication-style figures, run [`cbf_clustering_plots.R`](https://github.com/jMotif/sax-vsm_classic/blob/master/src/resources/RCode/cbf_clustering_plots.R) from `src/resources/RCode/` (requires [jmotif-R](https://github.com/jMotif/jmotif-R), `ggplot2`, `ggdendro`).

For supervised classification on the same data, see the [classification tutorial]({{< ref "/classification" >}}).
