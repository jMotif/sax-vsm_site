---
title: "Time series discretization via sliding window"
weight: 4
pagekind: "reading"
summary: "How a sliding window turns one long time series into an ordered sequence of SAX words describing its local features."
labels:
  - algorithm
---
## Definitions

### Time series

A time series \(T = t_{1},\dots,t_{m}\) is a set of scalar observations ordered by time. Since we focus on the detection of patterns that are likely to be local features, we consider short subsections of the time series called subsequences:

### Subsequence

A subsequence \(C\) of time series \(T\) is a contiguous sampling \(t_{p},\dots,t_{p+n-1}\) of points of length \(n \ll m\), where \(p\) is an arbitrary position such that \( 1 \leq p \leq m - n + 1\). Typically subsequences are extracted from a time series with a sliding window:

### Sliding window

For a time series \(T\) of length \(m\) and a user-defined subsequence length \(n\), all \(m - n + 1\) subsequences of \(T\) can be found by sliding a window of size \(n\) across \(T\).

## Discretization via sliding window

Discretizing the input time series as a whole (i.e., global discretization) can reveal repeated and rare patterns, but we found the subsequence-based technique more precise and more effective at identifying local phenomena. Thus, we apply SAX to the subsequences extracted via a sliding window. As discussed in the previous modules ([z-normalization]({{< ref "/algorithm/znorm" >}}), [PAA]({{< ref "/algorithm/paa" >}}), and [SAX]({{< ref "/algorithm/sax" >}})), each windowed subsequence is discretized by (i) z-normalizing it, (ii) dividing it into \(w\) equal-sized segments and computing the mean value of each segment, and (iii) mapping each mean to a symbol according to the pre-defined set of breakpoints dividing the value space into \(a\) equiprobable regions, where \(a\) is the user-specified alphabet size. This *subsequence discretization* process outputs an ordered sequence of SAX words, where each word corresponds to the leftmost point of its sliding window. The sequence is usually processed with numerosity reduction at the next step.

As an example, consider the sequence \(S_{1}\), where each word (e.g. `aac`) represents one subsequence extracted via the sliding window and discretized with SAX (the subscript after each word denotes the starting position of the subsequence in the time series):

$$ S_{1}= aac_{1}\, aac_{2}\, abc_{3}\, abb_{4}\, acd_{5}\, aac_{6}\, aac_{7}\, aac_{8}\, abc_{9}\, \dots $$

Continue to the [numerosity reduction]({{< ref "/algorithm/numerosityreduction" >}}) module…
