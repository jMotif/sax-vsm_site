---
title: "Time series classification"
weight: 4
summary: "Training and running the SAX-VSM classifier from the command line, and reading the patterns behind its decisions."
---
This module walks through classifying time series with the SAX-VSM Java implementation — from building the jar to interpreting *why* the classifier decided the way it did. All transcripts below were captured with `sax-vsm` 2.0.0.

## 1. Get the code

SAX-VSM ships on Maven Central as `net.seninp:sax-vsm:2.0.0`. For command-line use, build the self-contained jar from [the repository]({{< param github >}}):

```bash
$ git clone https://github.com/jMotif/sax-vsm_classic.git
$ cd sax-vsm_classic
$ mvn -P single -DskipTests package
...
[INFO] Building jar: target/sax-vsm-2.0.0-jar-with-dependencies.jar
```

## 2. Run the classifier

The class `net.seninp.jmotif.SAXVSMClassifier` trains on one file and evaluates on another. Data files follow the UCR format: one series per line, the class label first. The options are `-train`, `-test`, `-w`/`--window_size`, `-p`/`--word_size`, `-a`/`--alphabet_size`, `--strategy` (one of `NONE`, `EXACT`, `MINDIST`), and `--threshold`.

Here is a run on the classic [Gun/Point dataset](https://www.cs.ucr.edu/~eamonn/time_series_data/) (two classes: an actor draws a gun, or just points a finger; 50 training and 150 test series of length 150):

```text
$ java -cp "target/sax-vsm-2.0.0-jar-with-dependencies.jar" net.seninp.jmotif.SAXVSMClassifier \
    -train src/resources/data/Gun_Point/Gun_Point_TRAIN \
    -test src/resources/data/Gun_Point/Gun_Point_TEST \
    -w 33 -p 17 -a 15
... INFO net.seninp.jmotif.SAXVSMClassifier - trainData classes: 2, series length: 150
... INFO net.seninp.jmotif.SAXVSMClassifier -  training class: 1 series: 24
... INFO net.seninp.jmotif.SAXVSMClassifier -  training class: 2 series: 26
... INFO net.seninp.jmotif.SAXVSMClassifier - testData classes: 2, series length: 150
... INFO net.seninp.jmotif.SAXVSMClassifier -  test class: 1 series: 76
... INFO net.seninp.jmotif.SAXVSMClassifier -  test class: 2 series: 74
classification results: strategy EXACT, window 33, PAA 17, alphabet 15,  accuracy 0.98667,  error 0.01333
```

Two of the 150 test series are misclassified. On the three-class CBF benchmark the same command with `-w 60 -p 8 -a 6` classifies all 900 test series correctly (`accuracy 1.00, error 0.00`).

## 3. Find good parameters automatically

The discretization parameters matter, and guessing them is no fun. The jar's main class is a [DiRect (DIviding RECTangles)](https://link.springer.com/article/10.1007/BF00941892) sampler that searches the (window, PAA, alphabet) space against cross-validation error, so `java -jar` runs it directly:

```text
$ java -jar target/sax-vsm-2.0.0-jar-with-dependencies.jar \
    -train src/resources/data/Gun_Point/Gun_Point_TRAIN \
    -test src/resources/data/Gun_Point/Gun_Point_TEST \
    -wmin 10 -wmax 150 -pmin 5 -pmax 75 -amin 2 -amax 18 --hold_out 1 -i 3
...
min CV error 0.00 reached at [80, 40, 10], [33, 17, 15], will use Params [windowSize=33, paaSize=17,
  alphabetSize=15, nThreshold=0.01, nrStartegy=NONE, cvError=0.0]
error 0.06,    strategy MINDIST, window 33, PAA 17, alphabet 15, (CV error 0.02)
error 0.02667, strategy EXACT,   window 33, PAA 17, alphabet 10, (CV error 0.00)
error 0.01333, strategy NONE,    window 33, PAA 17, alphabet 15, (CV error 0.00)
all done in # 708 ms
```

Each evaluated point is logged as `@<error> <window> <paa> <alphabet>`; the run finishes with the best operating point per numerosity-reduction strategy. The `-w 33 -p 17 -a 15` setting used in section 2 is exactly what the sampler lands on.

## 4. See why: the class-characteristic patterns

Interpretability is the point of SAX-VSM: every tf·idf weight belongs to a SAX word, and every SAX word maps back to a shape in the signal. The class `net.seninp.jmotif.direct.SAXVSMPatternExplorer` prints the highest-weighted words per class, the series that contain them, and their locations (its positional arguments are train file, test file, window, PAA, alphabet, strategy):

```text
$ java -cp "target/sax-vsm-2.0.0-jar-with-dependencies.jar" net.seninp.jmotif.direct.SAXVSMPatternExplorer \
    src/resources/data/Gun_Point/Gun_Point_TRAIN src/resources/data/Gun_Point/Gun_Point_TEST 33 17 15 EXACT
Class key: 1
"mmmmmmlkigedcbbbb", 0.07139
"nnnnmljhfedcccccc", 0.06855
...
Class key: 2
"aaabcfiklllllllll", 0.07585
"cccccccdgjlmnnnnn", 0.06809
...
```

The top Class 1 (gun-draw) words are long descents — the hand returning the gun to the holster — while the top Class 2 (point) words are ascents from a flat start, the bare arm lifting. The classifier's decisions can be audited by locating these subsequences in the raw series; this is the property that separates SAX-VSM from black-box time series classifiers.

The weight vectors also power other analyses — see [pattern discovery]({{< ref "/patterns" >}}) for motif and discord mining with the same underlying SAX machinery.
