---
title: "Cosine similarity"
weight: 7
pagekind: "reading"
summary: "The angle-based similarity measure that scores an unlabeled time series against each class's tf·idf weight vector."
labels:
  - algorithm
---
For two vectors \( \boldsymbol{a} \) and \( \boldsymbol{b} \), cosine similarity is based on their inner product and defined as

$$ \mbox{similarity}(\boldsymbol{a}, \boldsymbol{b}) = \cos(\theta) = \frac{ \mathbf{a} \cdot \mathbf{b} } {\left| \left| a \right| \right| \cdot \left| \left| b \right| \right| } = \frac{ \sum\limits_{i=1}^{n}{a_i  b_i} }{ \sqrt{\sum\limits_{i=1}^{n}{a_i^2}}  \sqrt{\sum\limits_{i=1}^{n}{b_i^2}} } $$

In general the similarity ranges from −1 (exactly opposite) to 1 (exactly the same), with 0 indicating orthogonality. Since we use \( \mbox{tf} \ast \mbox{idf} \) weights, which cannot be negative, the cosine similarity between a term frequency vector and a class weight vector always falls between 0 and 1.

In SAX-VSM, classification is a single pass of this formula: the unlabeled time series is discretized into a term frequency vector (using exactly the SAX parameters from training), the cosine similarity against each class's weight vector is computed, and the label of the most similar class wins.
