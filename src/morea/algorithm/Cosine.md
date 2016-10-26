---
title: "Cosine similarity"
published: true
morea_id: Cosine
morea_summary: "Cosine similarity."
morea_type: reading
morea_sort_order: 1
morea_labels:
 - algorithm
---


# Cosine similarity

For two vectors \\( \boldsymbol{a} \\) and \\( \boldsymbol{b} \\) Cosine similarity is based on their inner product and defined as

$$ \mbox{similarity}(\boldsymbol{a}, \boldsymbol{b}) = cos(\theta) = \frac{ \mathbf{a} \cdot \mathbf{b} } {\left| \left| a \right| \right| \cdot \left| \left| b \right| \right| } = \frac{ \sum\limits_{i=1}^{n}{a_i  b_i} }{ \sqrt{\sum\limits_{i=1}^{n}{a_i^2}}  \sqrt{\sum\limits_{i=1}^{n}{b_i^2}} } $$

The resulting similarity value ranges from −1 meaning exactly opposite, to 1 meaning exactly the same, with 0 indicating orthogonality. Since we use \\( \mbox{tf} \ast \mbox{idf} \\) weights, which cannot be negative, the cosine similarity between two word bags representing the input time series sets will range from 0 to 1.