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

SAX-VSM is based on two well-known techniques. The first technique is Symbolic Aggregate approXimation, which is a high-level symbolic representation of time series. The second technique is the classic Vector Space Model based on \\( \mbox{tf} \ast \mbox{idf} \\) weighting scheme.

By using SAX, the algorithm transforms real-valued time series of a single input class into a combined collection of SAX words, which we call the "bag of words". Next, by using \\( \mbox{tf} \ast \mbox{idf} \\) weighting, the algorithm transforms these collections (one collection for each of the input classes) into class-characteristic weight vectors, which, in turn, are used in classification built upon Cosine similarity. 

The algorithm in a nutshell is illustrated below:

<div class="container">
  <div class="row">
    <div class="col-sm-8">
      <img style="margin-top: 5px; margin-bottom: 5px" src="../assets/inanutshell.png" width="800px" class="img-responsive center-block">
    </div>
  </div>
</div>

Classifier training is shown schematically at the left: all time series of the Class #1 are converted into a single bag of words, as well as the time series representing the Class #2 -- a process which yields two bag of words, one bag per class. Next, \\( \mbox{tf} \ast \mbox{idf} \\) weighting is applied resulting in the two \\( \mbox{tf} \ast \mbox{idf} \\) weight vectors chracterizing each of the two classes. 

Classification of an unlabeled time series uses the weight vectors obtained at the training step to compute the similarity score using the Cosine similarity between these vectors and the vector of SAX words frequency obtained by processing the unlabeled input time series with exactly the same SAX discretization parameters used in training. The classification label is assigned by the label of the weight vector which yields the maximal Cosine value.