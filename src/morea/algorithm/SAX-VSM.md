---
title: "Interpretable time series classification with SAX-VSM"
published: true
morea_id: SAXVSM
morea_summary: "SAX-VSM algorithm description."
morea_type: reading
morea_sort_order: 1
morea_labels:
 - algorithm
---


# SAX-VSM Algorithm

SAX-VSM is based on two well-known techniques. The first technique is Symbolic Aggregate approXimation, which is a high-level symbolic representation of time series. The second technique is the classic Vector Space Model based on tf∗idf weighting scheme.

By using SAX, the algorithm transforms real-valued time series of a single input class into a combined collection of SAX words, which we call the "bag of words". Next, by using \\( tf∗idf \\) weighting, the algorithm transforms these collections (one collection for each of the input classes) into class-characteristic weight vectors, which, in turn, are used in classification built upon Cosine similarity.