#import "@preview/glossarium:0.5.1": gls, glspl
#import "../../utils.typ": flex-caption, customRound

#import "graphs.typ": pretraining_graph, ex3_graph, ex3_bl_graph, ex4_graph, ex3_ol

#let spacy = json("../../results/spacy_morph_tag.json")
#let stanza = json("../../results/stanza-fo_performance.json")

= Results <Results.sec>
This chapter presents the results of the experiments conducted in this study. The results are organized into sections: Each section provides a detailed analysis of the performance of the models and the evaluation metrics used to assess their effectiveness.


== spaCy Pipeline <results_spacy.sec>
A spaCy pipeline was trained on the Faroese dataset using the following components: a #gls("POS") tagger, morphologizer, lemmatizer, and dependency parser. The performance of each component was evaluated using either accuracy or precision, recall, and F1 score, depending on what metric is relevant for the given component. The #gls("POS") tagger and morphologizer were trained on the same dataset, while the lemmatizer and dependency parser were each trained on separate datasets. Due to limited data, the same training set could not be used for all components, the amounts of data available for each component is mentioned in their section. The results of the experiments are presented in the following subsections.
To have a baseline, The Stanza models from stanford was used as a reference, since it also used data from #gls("UD"), although it only uses @farpahc. All metrics for Stanza are taken from the Stanza websites performance page @stanza_perf

=== #gls("POS") Tagger & Morphologizer <pos_morph.sec>



In @pos_morph_comp, due to confusuing naming conventions, the #gls("POS") tagger is referred to as "Tag" and the #gls("POS") refers to the morphologizers coarse grained #gls("POS").
#figure(
  caption: flex-caption(
      [#gls("POS") Tagger and #gls("MORPH") accuracy comparison between the spaCy and Stanza models],
      [#gls("POS") Tagger and #gls("MORPH") accuracy comparison]
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
) <pos_morph_comp>



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
An experiment was conducted to see what performance the lemmatizer and dependeny parcer could achieve on the very limited data. On @dep_parsers, the comparison between the lemmatizer and dependency parser performance metrics for the spaCy and Stanza models is shown
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
Looking at the results, it is clear that the lemmatizer and dependency parser performance metrics for the spaCy model are not as good as the Stanza model. With the accuracy of the lemmatizer being 81.22% around every fifth lemma is incorrect, making it unusable.  
Looking at the dependency parcer, the #gls("UAS") and #gls("LAS") scores are #customRound(spacy.at("dep_uas")*100, 2)% and #customRound(spacy.at("dep_las")*100, 2)% respectively. This means that the dependency parcer is not too far off the Stanza model, when it comes to detecting structural dependencies, performs very badly when predicting what grammatical roles the words play in the sentence. This result shows that the parser has a shallow understanding of the sentence structure. @dep_feats goes more into detail about the performance of the dependency parser.

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
) <dep_feats>
There are obviously some blank spots that the model has not learned at all, namely *nsubj:cop*, *fixed* and *discourse*.// TODO see if these appear in training data
Other features that stand out are *root* and *nmod*. The *root* label has a pretty high recall of 94.57%, but with a precision of only 14.01% it is clear that the model has a hard time predicting the root of the sentence. The *nmod* label has the opposite problem, with a precision of 100% and a recall of 4.82%, it is terrible at finding the nmod label, but when it does find it, it is correct. In general, the models performance is all over the place, and with the small sample size, it is hard to say if these metrics generalize to the real world. Given the poor performance and lack of data, the lemmatizer and dependency parser were scrapped and not used in the pipeline.


== mT5 Pretraining <results_pretraining.sec>
This section covers the experiments conducted to pretrain a mT5 model on faroese data.
The initial results of the training were not promising, as most of the training destabilized after a few epochs. To see if it was possible to pretrain a faroese mT5 model, attempts were made to pretrain a custom mT5 model on a Faroese dataset. The dataset was a collection of wikipedia articles, blog posts and the Faroese corpora on #link("https://huggingface.co/")[Hugging Face] and @mtd_res. 
#ex3_ol <ex3_ol>

An initial hypothesis was that the data was not cleaned enough for the model to learn from. This was possibly a part of the problem, and after more thorough cleaning, where all foreign characters were removed, and too short sentences were removed, as well as sentences that were too long. Additionally, common danish and english words, that do not appear in the faroese dictionary, were used to filter out sentences that were not in faroese. It was also at this point that there were some encoding errors in the data, which were fixed. After this, the training was restarted. and the result can be seen on @ex4_graph.
#ex4_graph <ex4_graph>
While the result is a bit better, it still destabilizes after 20,000 steps. At this point, the upsides and downsides of using a smaller model and bit linear were weighed. The smaller model would in theory be able to learn faster, but it seemed to be too small for the task, and while bitlinear stabilized the training, it was in the early stages of development, and had too many unknowns and could not be used in production, so in the end bitlinear was not used.
Another pretraining was conducted using the larger mT5-base model. The training used the same dataset as the previous experiment.
#pretraining_graph <pretraining_graph>
This time the training was stable and the model was able to learn from the data. The training was stopped after one epoch, which is 81203 steps, but a checkpoint was extracted after 20,000 steps to work on finetuning. The loss plot can be seen on @pretraining_graph.


== mT5 Grammar Model <results_grammar.sec>



=== Fine-tuning <results_grammar_fine.sec>


== mT5 Spelling Model <results_spelling.sec>


