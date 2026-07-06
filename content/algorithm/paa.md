---
title: "Piecewise Aggregate Approximation (PAA)"
weight: 2
pagekind: "reading"
summary: "Dimensionality reduction by frame averaging, and the lower-bounding PAA distance."
labels:
  - algorithm
---
PAA approximates a time series *X* of length *n* with a vector \( \bar{X}=(\bar{x}_{1},...,\bar{x}_{w}) \) of any arbitrary length \( w \leq n \), where each \( \bar{x}_{i} \) is calculated as follows:

$$ \bar{x}_{i} = \frac{w}{n} \sum_{j=n/w(i-1)+1}^{(n/w)i} x_{j} $$

This simply means that in order to reduce the dimensionality from *n* to *w*, we first divide the original time series into *w* equal-sized frames and then compute the mean value of each frame. The sequence assembled from these mean values is the PAA approximation (i.e., transform) of the original time series. (The PAA literature often denotes the reduced dimensionality by *M*; we use *w* throughout this site because, in the SAX context, it becomes the word size.) Computing the transform takes a single pass over the series. PAA is equipped with the distance measure

$$ D_{PAA}(\bar{X},\bar{Y}) \equiv \sqrt{\frac{n}{w}} \sqrt{ \sum_{i=1}^{w} \left( \bar{x}_{i}-\bar{y}_{i} \right)^{2} } $$

and, as shown by Yi &amp; Faloutsos and by Keogh et al., \(D_{PAA}\) lower-bounds the Euclidean distance,

$$ D_{PAA}(\bar{X},\bar{Y}) \leq D(X,Y) $$

which guarantees no false dismissals when searching over the PAA representation.

## Example

In this primer we use the following time series:

```r
series1 <- c(2.02, 2.33, 2.99, 6.85, 9.20, 8.80, 7.50, 6.00, 5.85, 3.85, 4.85, 3.85, 2.22, 1.45, 1.34)
```

![The raw 15-point example time series](paa_raw.png)

and the following R code:

```r
paa <- function(ts, paa_size){
  len = length(ts)
  if (len == paa_size) {
    ts
  }
  else {
    if (len %% paa_size == 0) {
      colMeans(matrix(ts, nrow=len %/% paa_size, byrow=F))
    }
    else {
      res = rep.int(0, paa_size)
      for (i in c(0:(len * paa_size - 1))) {
        idx = i %/% len + 1 # the frame
        pos = i %/% paa_size + 1 # the point
        res[idx] = res[idx] + ts[pos]
      }
      for (i in c(1:paa_size)) {
        res[i] = res[i] / len
      }
      res
    }
  }
}
```

whose application produces a seven-point piecewise aggregate approximation:

```r
s1_paa = paa(series1, 7)
(2.23, 5.62, 8.67, 6.36, 4.58, 3.33, 1.45)
```

![The series reduced to 7 PAA frames](paa7.png)

or a 9-point approximation, which is a bit trickier — 15 points do not divide evenly into 9 frames, so boundary points contribute fractionally to two neighboring frames:

```r
s1_paa = paa(series1, 9)
(2.14, 3.63, 8.26, 8.28, 6.27, 4.65, 4.45, 2.39, 1.38)
```

![The series reduced to 9 PAA frames](paa9.png)
