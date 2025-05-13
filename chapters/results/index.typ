#import "@preview/glossarium:0.5.1": gls, glspl
#import "../../utils.typ": flex-caption, customRound

#import "graphs.typ": pretraining_graph, ex3_graph, ex3_bl_graph, ex4_graph, ex3_bl_ex4_ol

#let spacy = json("../../results/spacy_morph_tag.json")
#let stanza = json("../../results/stanza-fo_performance.json")

= Results <Results.sec>
This chapter presents the results of the experiments conducted in this study. The results are organized into sections: Each section provides a detailed analysis of the performance of the models and the evaluation metrics used to assess their effectiveness.

== spaCy Pipeline <results_spacy.sec>
A spaCy pipeline was trained on the Faroese dataset using the following components: a #gls("POS") tagger, morphologizer, lemmatizer, and dependency parser. The performance of each component was evaluated using either accuracy or precision, recall, and F1 score, depending on what metric is relevant for the given component. The #gls("POS") tagger and morphologizer were trained on the same dataset, while the lemmatizer and dependency parser were each trained on separate datasets. Due to limited data, the same training set could not be used for all components, the amounts of data available for each component is mentioned in their section. The results of the experiments are presented in the following subsections. 

=== #gls("POS") Tagger & Morphologizer <pos_morph.sec>

In the table below, due to confusuing naming conventions, the #gls("POS") tagger is referred to as "Tag" and the #gls("POS") refers to the morphologizers coarse grained #gls("POS").
#grid(
  columns: 2,
  figure(
    caption: flex-caption(
      [#gls("POS") Tagger and #gls("MORPH") performance metrics comparison between the spaCy and Stanza models],
      [#gls("POS") Tagger and #gls("MORPH") performance metrics]
    ),
    table(
      columns: (auto, 1fr, 1fr, 1fr),
      stroke: none,
      table.hline(),
      table.header(
        table.cell(align: horizon)[*Model*],
        [*Tag*], [*#gls("POS")*], [*#gls("MORPH")*]
      ),
      table.hline(),
      [*spaCy*], [*#customRound(spacy.at("tag_acc", )*100, 2)*], [*#customRound(spacy.at("pos_acc")*100, 2)*], [*#customRound(spacy.at("morph_acc")*100, 2)*],
      [*Stanza*], [#customRound(stanza.at("XPOS"), 2)], [#customRound(stanza.at("UPOS"), 2)], [#customRound(stanza.at("UFeats"), 2)],
      table.hline()
    ),
  )
)<pos_morph_comp>


#figure(
  caption: flex-caption(
    [Morphologizer performance metrics per feature for the spaCy model],
    [Morphologizer performance metrics per feature]
  ),
  table(
    columns: (auto, 1fr, 1fr, 1fr),
    stroke: none,
    table.hline(),
    table.header( [*Feat*], [*Precision*], [*Recall*], [*F1*] ),
    table.hline(),
    ..spacy.at("morph_per_feat").keys().map( key => ( (key,) + spacy.at("morph_per_feat").at(key).values()).map(v => {
      if (type(v) == float) {
        customRound(v*100, 2)
     } else {
        [*#v*]
    }
    })).flatten(),
    table.hline()
  )
)<morph_feats>

=== Lemmatizer & Dependency Parser <lemma_dep.sec>


#figure(
  caption: flex-caption(
    [Dependency parser performance metrics for the spaCy model],
    [spaCy dependency parser performance metrics]
  ),
  table(
    columns: (auto, 1fr, 1fr, 1fr),
    stroke: none,
    table.hline(),
    table.header( [*Model*], [*Lemma*], [*UAS*], [*LAS*] ),
    table.hline(),
    [*spaCy*], [#customRound(spacy.at("lemma_acc")*100, 2)], [#customRound(spacy.at("dep_uas")*100, 2)], [#customRound(spacy.at("dep_las")*100, 2)],
    [*Stanza*], [*#customRound(stanza.at("Lemmas"), 2)*], [*#customRound(stanza.at("UAS"), 2)*], [*#customRound(stanza.at("LAS"), 2)*],
    table.hline()
  )
)<dep_parsers>

#figure(
  caption: flex-caption(
    [Dependency parser performance metrics per type for the spaCy model],
    [Dependency parser performance metrics per type]
  ),
  table(
      columns: (auto, 1fr, 1fr, 1fr),
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
)

== mT5-base pretraining 
During experimentation with a reduced-capacity mT5 model, it became evident that the model's representational capacity was insufficient for the target task. Bitlinear seemed to have a stabilizing effect on the training process, \ \
#ex3_bl_ex4_ol
#ex3_graph
#pretraining_graph


== mT5 Grammar Model <results_grammar.sec>





=== Fine-tuning <results_grammar_fine.sec>


== mT5 Spelling Model <results_spelling.sec>


