#import "@preview/glossarium:0.5.1": gls, glspl
#import "../../utils.typ": flex-caption, customRound
#let spacy = json("../../results/spacy_morph_tag.json")
#let stanza = json("../../results/stanza-fo_performance.json")


=== Lemmatizer & Dependency Parser <lemma_dep.sec>
An experiment was conducted to see what performance the lemmatizer and dependeny parcer could achieve on the very limited data. On @dep_parsers, the comparison between the lemmatizer and dependency parser performance metrics for the spaCy and Stanza models is shown.
#figure(
  caption: flex-caption(
    [Dependency parser performance metrics for the spaCy model],
    [spaCy dependency parser performance metrics]
  ),
  table(
    columns: (auto, 1fr, 1fr, 1fr),
    fill: (_, y) => if calc.odd(y) { gray.lighten(90%) },
    stroke: none,
    table.hline(),
    table.header( [*Model*], [*Lemma*], [*UAS*], [*LAS*] ),
    table.hline(),
    [*spaCy*], [#customRound(spacy.at("lemma_acc")*100, 2)], [#customRound(spacy.at("dep_uas")*100, 2)], [#customRound(spacy.at("dep_las")*100, 2)],
    [*Stanza*], [*#customRound(stanza.at("Lemmas"), 2)*], [*#customRound(stanza.at("UAS"), 2)*], [*#customRound(stanza.at("LAS"), 2)*],
    table.hline()
  )
)<dep_parsers>
Looking at the results, it is clear that the lemmatizer and dependency parser performance metrics for the spaCy model are not as good as the Stanza model. With the accuracy of the lemmatizer being 81.22% around every fifth lemma is incorrect, making it unusable.  
Looking at the dependency parcer, the #gls("UAS") and #gls("LAS") scores are #customRound(spacy.at("dep_uas")*100, 2)% and #customRound(spacy.at("dep_las")*100, 2)% respectively. This means that the dependency parcer is not too far off the Stanza model, when it comes to detecting structural dependencies, performs very badly when predicting what grammatical roles the words play in the sentence. This result shows that the parser has a shallow understanding of the sentence structure. @dep_feats goes more into detail about the performance of the dependency parser.

#figure(
  caption: flex-caption(
    [Dependency parser performance metrics per type for the spaCy model],
    [Dependency parser performance metrics per type]
  ),
  table(
      columns: (auto, 1fr, 1fr, 1fr),
      fill: (_, y) => if calc.odd(y) { gray.lighten(90%) },
      stroke: none,
      table.hline(),
      table.header( [*Feat*], ..spacy.at("dep_las_per_type").at("cc").keys().map(k => [*#k*])),
      table.hline(),
      [*sents*], [#customRound(spacy.at("sents_p")*100, 2)], [#customRound(spacy.at("sents_r")*100, 2)], [#customRound(spacy.at("sents_f")*100, 2)],
      ..spacy.at("dep_las_per_type").keys().map( key => ( (key,) + spacy.at("dep_las_per_type").at(key).values()).map(v => {
      if (type(v) == float) {
        customRound(v*100, 2)
     } else {
        [*#v*]
    }
    })).flatten(),
      table.hline()
  ) 
) <dep_feats>
There are obviously some blank spots that the model has not learned at all, namely *nsubj:cop*, *fixed* and *discourse*. The *fixed* label occurs twice in the data, *nsubj:cop* occurs four times and *discourse* occurs 23 times, so it is not surprising that the model has not learned these labels.
Other features that stand out are *root* and *nmod*. The *root* label has a pretty high recall of 94.57%, but with a precision of only 14.01% it is clear that the model has a hard time predicting the root of the sentence. The *nmod* label has the opposite problem, with a precision of 100% and a recall of 4.82%, it is terrible at finding the *nmod* label, but when it does find it, it is correct, the label only occurs 66 times in the data, so it also is no surprise that it struggles to find it. In general, the models performance is all over the place, and with the small sample size, it is hard to say if these metrics generalize to the real world. Given the poor performance and lack of data, the lemmatizer and dependency parser were scrapped and not used in the pipeline.