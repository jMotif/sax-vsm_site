---
title: "Z-normalization"
weight: 1
pagekind: "reading"
summary: "Why and how time series are standardized to zero mean and unit variance before discretization."
labels:
  - algorithm
---
**Z-normalization**, also known as "normalization to zero mean and unit of energy", was first mentioned by <a href="../../images/cp95.pdf">Goldin &amp; Kanellakis</a>. The procedure rescales the input vector so that the output has a mean of 0 and a standard deviation of 1:

$$x^{'}_{i}=\frac{x_{i}-\mu}{\sigma}, \text{ where } i \in \mathbb{N}$$

First, the time series mean is subtracted from each value; second, the difference is divided by the standard deviation. According to most of the recent work on _structural_ time series pattern mining, z-normalization is an essential preprocessing step: it lets a mining algorithm focus on structural similarities and dissimilarities rather than on amplitude-driven ones.

Note, however, that in some cases this preprocessing is not recommended, as it introduces biases. For example, if the signal variance is very small, z-normalization simply amplifies the noise to unit amplitude. In the extreme case of a constant time series, the standard deviation is zero and the transform is undefined — a division by zero. This is why practical implementations guard the division with a small threshold and skip the normalization when the variance falls below it.

## Example

The example below demonstrates the highly desirable property of z-normalization: whereas the raw time series look very different, their z-normalized versions are nearly identical.

### The raw time series

```r
series1 <- c(2.02, 2.33, 2.99, 6.85, 9.20, 8.80, 7.50, 6.00, 5.85, 3.85, 4.85, 3.85, 2.22, 1.45, 1.34)
series2 <- c(-0.12, -0.16, -0.13,  0.28,  0.37,  0.39,  0.18,  0.09,  0.15, -0.06,  0.06, -0.07, -0.13, -0.18, -0.26)
```

![Two raw time series of very different amplitudes](raw_data.png)

Z-normalization can be coded as a simple R function:

```r
znorm <- function(ts){
  ts.mean <- mean(ts)
  ts.dev <- sd(ts)
  (ts - ts.mean)/ts.dev
}

s1_znorm = znorm(series1)
s2_znorm = znorm(series2)
```

> **Note:** These R snippets use base R `sd()`, which divides by \(n-1\). The jMotif Java and R (`jmotif`) implementations use the **population** standard deviation (divide by \(n\), the Matrix Profile / MASS convention). For stack-identical numerics, use `sqrt(mean((ts - mean(ts))^2))` or the `jmotif` package instead of `sd()`.

### The time series after z-normalization

![The same two series after z-normalization, now almost overlapping](znormalized_data.png)
