---
title: "TFIDF statistics"
published: true
morea_id: TFIDF
morea_summary: "TF*IDF statistics overview."
morea_type: reading
morea_sort_order: 1
morea_labels:
 - algorithm
---


# Term Frequency - Inverse Document Frequency statistics

We use the vector space model exactly as it is known in Information Retrieval (Salton). Similarly, we define and use the following expressions: _term_ - a single SAX word, _bag of words_ - an unordered collection of SAX words, _corpus_ - a set of bags, and _weight matrix_ - a matrix defining weights of all words in a corpus. 

Given a training set, SAX-VSM builds a bag of SAX words for each of the classes by processing each of the input time series with sliding window-based SAX discretization. Bags are combined into a corpus, which is built as a _term frequency matrix_, whose
rows correspond to the set of all SAX words (terms) found in _all classes_, whereas each column denotes a class of the training set. 
Each element of this matrix is an observed frequency of a term in a class. Because SAX words extracted from the time series of one class are often not found in others, this matrix is usually sparse. 

Next, SAX-VSM applies \\( \mbox{tf} \ast \mbox{idf} \\) weighting scheme for each element of this matrix to transform a frequency value into a weight coefficient. The \\( \mbox{tf} \ast \mbox{idf} \\) weight for a term \\( t \\) is defined as a product of two factors: term frequency (\\(\mbox{tf}\\)) and inverse document frequency (\\( \mbox{idf} \\)). For the first factor, we use logarithmically scaled term frequency:

$$ \mbox{tf}_{t, d} =  \begin{cases} \log(1 + \mbox{f}_{t,d}), &\mbox{if f}_{t,d}>0  \\ 0, & \mbox{otherwise} \end{cases} $$ 

where \\(t\\) is the term, \\(d\\) is a bag of words (a document in IR terms), and \\(\mbox{f}_{t,d}\\) is a frequency of the term in a bag.

The inverse document frequency we compute as usual:

$$ \mbox{idf}_{t, D} =  \log\frac{|D|}{|d \in D : t \in d|} = \log\frac{N}{\mbox{df}_{t}} $$

where \\(N\\) is the cardinality of a corpus \\(D\\) (the total number of classes) and the 
denominator \\(\mbox{df}_{t}\\) is a number of bags where the term \\(t\\) appears.

Then, \\( \mbox{tf} \ast \mbox{idf} \\) weight value for a term \\( t \\) in the bag \\( d \\) of a corpus \\( D \\) 
is defined as 

$$ \mbox{tf * idf}(t, d, D) =  \mbox{tf}_{t, d} \times \mbox{idf}_{t, D} = \log(1 + \mbox{f}_{t,d}) \times \log\frac{N}{\mbox{df}_{t}} $$

for all cases where \\( \mbox{f}\_{t,d} > 0\\) and \\( \mbox{df}\_{t} > 0 \\) , or zero otherwise.

Once all frequency values are computed, term frequency matrix becomes the term weight matrix, whose columns used as _class' term weight vectors_ that facilitate the classification using Cosine similarity.