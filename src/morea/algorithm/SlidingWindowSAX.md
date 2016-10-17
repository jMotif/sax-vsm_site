---
title: "Time series discretization via sliding window"
published: true
morea_id: SlidingWindowSAX
morea_summary: "An overview of time series discretization via sliding window."
morea_type: reading
morea_sort_order: 1
morea_labels:
 - algorithm
---
## Definitions

#### Time series 
Time series \\(T = t_{1},\dots,t_{m}\\) is a set of scalar observations ordered by time. Since we focus on the detection of anomalous patterns, which are likely to be local features, we consider short subsections of time series called subsequences:

#### Subsequence
Subsequence \\(C\\) of time series \\(T\\) is a contiguous sampling \\(t_{p},\dots,t_{p+n-1}\\) of points of length \\(n << m\\) where \\(p\\) is an arbitrary position, such that \\( 1 \leq p \leq m - n + 1\\). Typically subsequences are extracted from a time series with the use of a sliding window:

#### Sliding window
Sliding window subsequence extraction: for a time series \\(T\\) of length \\(m\\), and a user-defined subsequence length \\(n\\), all possible subsequences of \\(T\\) can be found by sliding a window of size \\(n\\) across \\(T\\).

## Discretization via sliding window
While by discretizing the input time series as a whole (i.e., global discretization) we can discover repeated and rare patterns (i.e., frequent and rare letter correlations) we found that the subsequence-based technique is more precise and advantegeous in identification of a local phenomenon. Thus, we apply SAX to the input time series subsequences extracted via a sliding window. As discussed in other modules (<a href="morea/algorithm/znorm.html">Z normalization</a>, <a href="morea/algorithm/PAA.html">PAA</a>, and <a href="morea/algorithm/SAX.html">SAX</a>), for each of the sliding window-extracted subsequences SAX discretization performed by: (i) dividing _z_-normalized subsequence into \\(w\\) equal-sized segments, (ii) computing a mean value for each of the segments, and (iii) mapping it to symbols according to a pre-defined set of breakpoints dividing the distribution space into \\(\alpha\\) equiprobable regions, where \\(\alpha\\) is the alphabet size specified by the user. This _subsequence discretization_ process outputs an ordered set of SAX words, where each word corresponds to the leftmost point of the sliding window, and which we usually process with numerosity reduction at the next step.

As an example, consider the sequence \\(S_{1}\\) where each word (e.g. \((aac\\)) represents a subsequence extracted from the original time series via a sliding window and discretized with SAX (the subscript following each word denotes the starting position of the corresponding subsequence in the time series):

$$ S_{1}= aac_{1}\, aac_{2}\, abc_{3}\, abb_{4}\, acd_{5}\, aac_{6}\, aac_{7}\, aac_{8}\, abc_{9}\, \dots $$

Continue to the <a href="NumerosityReduction.html">SAX discretization numerosity reduction</a> module...