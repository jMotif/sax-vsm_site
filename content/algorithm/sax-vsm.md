---
title: "Interpretable time series classification with SAX-VSM"
weight: 8
pagekind: "reading"
summary: "The full SAX-VSM algorithm: per-class bags of SAX words, tf·idf weighting, and cosine-similarity classification."
labels:
  - algorithm
---
SAX-VSM combines two well-known techniques: Symbolic Aggregate approXimation — a symbolic representation of time series — and the classic Vector Space Model with its \( \mbox{tf} \ast \mbox{idf} \) weighting scheme from Information Retrieval.

Using SAX, the algorithm transforms all real-valued time series of one training class into a single collection of SAX words, which we call the class's "bag of words". Then, using \( \mbox{tf} \ast \mbox{idf} \) weighting, the algorithm transforms these collections (one per class) into class-characteristic weight vectors, which drive the classification via cosine similarity.

The algorithm in a nutshell:

{{< fig src="inanutshell.png" w="800" alt="SAX-VSM overview: training series become per-class bags of SAX words, tf·idf turns the bags into class weight vectors, and an unlabeled series is assigned the label of the most cosine-similar vector" >}}

Classifier **training** is shown on the left: all time series of Class #1 are converted into a single bag of words, and likewise for Class #2 — a process that yields two bags, one per class. Then \( \mbox{tf} \ast \mbox{idf} \) weighting is applied, producing two weight vectors, one characterizing each class.

**Classification** of an unlabeled time series uses the weight vectors obtained in training. The unlabeled series is discretized with exactly the same SAX parameters used in training, yielding a vector of SAX word frequencies. The cosine similarity between this frequency vector and each class weight vector is computed, and the label of the class with the maximal cosine value is assigned.

The individual steps are covered in the preceding modules: [z-normalization]({{< ref "/algorithm/znorm" >}}), [PAA]({{< ref "/algorithm/paa" >}}), [SAX]({{< ref "/algorithm/sax" >}}), [sliding-window discretization]({{< ref "/algorithm/slidingwindowsax" >}}), [numerosity reduction]({{< ref "/algorithm/numerosityreduction" >}}), [tf·idf]({{< ref "/algorithm/tfidf" >}}), and [cosine similarity]({{< ref "/algorithm/cosine" >}}). A hands-on walkthrough with the Java implementation lives in the [classification module]({{< ref "/classification" >}}).
