---
title: "TF-IDF weighting for time series (tf·idf)"
weight: 6
pagekind: "reading"
summary: "How term frequency and inverse document frequency turn per-class bags of SAX words into class-characteristic weight vectors."
labels:
  - algorithm
---
We use the vector space model with TF-IDF (term frequency–inverse document frequency) weighting exactly as it is known in Information Retrieval (Salton). Accordingly, we define and use the following terms: a _term_ is a single SAX word, a _bag of words_ is an unordered collection of SAX words, a _corpus_ is a set of bags, and the _weight matrix_ defines the weights of all words in a corpus.

Given a training set, SAX-VSM builds a bag of SAX words for each class by processing every input time series with sliding window-based SAX discretization. The bags are combined into a corpus represented as a _term frequency matrix_: its rows correspond to the set of all SAX words (terms) found in _all classes_, and each column denotes one class of the training set. Each element of this matrix is the observed frequency of a term in a class. Because SAX words extracted from one class's time series are often absent from the others, this matrix is usually sparse.

Next, SAX-VSM applies the \( \mbox{tf} \ast \mbox{idf} \) weighting scheme to each element of this matrix, turning frequency values into weight coefficients. The \( \mbox{tf} \ast \mbox{idf} \) weight of a term \( t \) is the product of two factors: term frequency (\(\mbox{tf}\)) and inverse document frequency (\( \mbox{idf} \)). For the first factor, we use the logarithmically scaled term frequency

$$ \mbox{tf}_{t, d} = \begin{cases} \ln(1 + \mbox{f}_{t,d}), &\mbox{if f}_{t,d} \gt 0 \\ 0, & \mbox{otherwise} \end{cases} $$

where \(t\) is the term, \(d\) is a bag of words (a document, in IR terms), and \(\mbox{f}_{t,d}\) is the frequency of the term in the bag.

The inverse document frequency is computed as usual:

$$ \mbox{idf}_{t, D} =  \ln\frac{|D|}{|d \in D : t \in d|} = \ln\frac{N}{\mbox{df}_{t}} $$

where \(N\) is the cardinality of the corpus \(D\) (the total number of classes) and the denominator \(\mbox{df}_{t}\) is the number of bags in which the term \(t\) appears.

The \( \mbox{tf} \ast \mbox{idf} \) weight of a term \( t \) in bag \( d \) of corpus \( D \) is then

$$ \mbox{tf} \ast \mbox{idf}(t, d, D) =  \mbox{tf}_{t, d} \times \mbox{idf}_{t, D} = \ln(1 + \mbox{f}_{t,d}) \times \ln\frac{N}{\mbox{df}_{t}} $$

for all cases where \( \mbox{f}_{t,d} \gt 0\) and \( \mbox{df}_{t} \gt 0 \), and zero otherwise. Note that a word appearing in *every* class gets \(\mbox{idf} = \ln(N/N) = 0\), and thus carries no weight — exactly the behavior we want, since such a word cannot discriminate between the classes. (Both logarithms are natural; since the idf base is a uniform per-word factor, it cancels in the cosine similarity and does not affect classification.)

Once all values are computed, the term frequency matrix becomes the term weight matrix, whose columns are the _class term weight vectors_ used for classification via [cosine similarity]({{< ref "/algorithm/cosine" >}}).
