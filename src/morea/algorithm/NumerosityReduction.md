---
title: "SAX numerosity reduction"
published: true
morea_id: NumerosityReduction
morea_summary: "SAX Discretization numerosity reduction"
morea_type: reading
morea_sort_order: 1
morea_labels:
 - algorithm
---
## Numerosity Reduction

As it has been shown previously, neighboring subsequences extracted via sliding window are often similar to each other. When combined with the smoothing properties of SAX, this phenomenon persists through the discretization, resulting in a large number of consecutive SAX words that are identical. Later, these yield a large number of trivial matches, which significantly affect performance of algorithms built upon SAX. To address this issue, a numerosity reduction strategy is usually employed: if in the course of discretization, the same SAX word occurs more than once consecutively, instead of placing every instance into the resulting string, we record only its first occurrence. Applied to \\(S1\\)

$$ S_{1}= aac_{1}\, aac_{2}\, abc_{3}\, abb_{4}\, acd_{5}\, aac_{6}\, aac_{7}\, aac_{8}\, abc_{9}\, \dots $$

this process yields:

$$ S2 = \textit{aac}_{1}~ \textit{abc}_{3}~ \textit{abb}_{4}~ \textit{acd}_{5}~ \textit{aac}_{6}~ \textit{abc}_{9} $$

In addition to speeding up the algorithm and reducing its space requirements, the numerosity reduction procedure provides an important feature -- it naturally enables the discovery of variable-length motifs and anomalies. 