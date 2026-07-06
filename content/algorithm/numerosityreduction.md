---
title: "SAX numerosity reduction"
weight: 5
pagekind: "reading"
summary: "Collapsing runs of identical consecutive SAX words — smaller output, faster algorithms, and naturally variable-length patterns."
labels:
  - algorithm
---
## Numerosity reduction

As has been shown previously, neighboring subsequences extracted via a sliding window are often similar to each other. Combined with the smoothing properties of SAX, this similarity persists through discretization, resulting in long runs of consecutive SAX words that are identical. These runs later yield a large number of trivial matches, which significantly degrade the performance of algorithms built upon SAX. To address this, a numerosity reduction strategy is usually employed: if the same SAX word occurs more than once consecutively, we record only its first occurrence instead of placing every instance into the resulting sequence. Applied to

$$ S_{1}= aac_{1}\, aac_{2}\, abc_{3}\, abb_{4}\, acd_{5}\, aac_{6}\, aac_{7}\, aac_{8}\, abc_{9}\, \dots $$

this process yields

$$ S_{2} = \textit{aac}_{1}~ \textit{abc}_{3}~ \textit{abb}_{4}~ \textit{acd}_{5}~ \textit{aac}_{6}~ \textit{abc}_{9}~ \dots $$

In addition to speeding up processing and reducing space requirements, numerosity reduction provides an important feature: because the retained words are no longer evenly spaced in time, the distance between consecutive words varies — and this is precisely what enables the discovery of *variable-length* motifs and anomalies downstream.
