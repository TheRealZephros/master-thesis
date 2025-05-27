#import "@preview/glossarium:0.5.1": gls, glspl
#import "../../utils.typ": flex-caption, customRound
#let spacy = json("../../results/spacy_morph_tag.json")
#let stanza = json("../../results/stanza-fo_performance.json")


=== #gls("POS") Tagger & Morphologizer <pos_morph.sec>


The #gls("POS") tagger and morphologizer were trained on the same dataset, greater detail about the dataset can be seen in @ud.sec. 


On @pos_morph_comp, is a comparison of accuracy between the spaCy #gls("POS") tagger and morphologizer, trained for this thesis and the faroese Stanza model. 
For the sake of clarity, the metrics on @pos_morph_comp, will be explained: The "Tag" refers to the fine-grained #gls("POS") tag that is predicted by the #gls("POS") tagger, this is the attribute that can be accessed by a tokens tag attribute. The #gls("POS") refers to the coarse-grained #gls("POS") tag, that is predicted by the morphologizer. The #gls("MORPH") refers to the morphological features that are predicted by the morphologizer.
#figure( 
  caption: flex-caption(
      [#gls("POS") Tagger and #gls("MORPH") accuracy comparison between the spaCy and Stanza models],
      [#gls("POS") Tagger and #gls("MORPH") accuracy comparison]
    ),
  table(
    columns: (auto, 1fr, 1fr, 1fr),
    fill: (_, y) => if calc.odd(y) { gray.lighten(90%) },
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
While the results look good, after some manual inspection of some prediction, it is clear that the #gls("POS") tagger struggles with words like "skrivað"(written) if the context is "Bókin var skrivað í ár." (The book was written this year.), written is an adjective, but if the context is "Eg havi skrivað bókina í ár." (I have written the book this year.), then it is a verb. The model struggles to disambiguate these two cases, and it is not the only case where this happens, but it is the most common case. This is likely a problem with the training data, where there is not enough examples of the different contexts, and the model is not able to learn the difference.
Just looking at the results, the spaCy model outperforms the Stanza model, when it comes to overall accuracy of the #gls("POS") tagger and morphologizer, but with the limited data and both training sets having major limitations its not clear how their performance generalizes to unseen data. On @morph_feats, a more detailed view of the performance of the morphologizer is shown. The table shows the precision, recall and F1 score for each feature.
#figure(
  caption: flex-caption(
    [Morphologizer performance metrics per feature for the spaCy model],
    [Morphologizer performance metrics per feature]
  ),
  table(
    columns: (auto, 1fr, 1fr, 1fr),
    fill: (_, y) => if calc.odd(y) { gray.lighten(90%) },
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
Looking at the results, the morphologizer performs reasonably well, on most features, especially on *Mood*, *Definite*, *Tense* and *NameType*. The *Mood* and *NameType* features are not used for anything in the pipeline, as of now, but its still good to have them for future use. The *Definite* and *Tense* features are very important for making inflexion errors, so it is good that they are performing well. On the other hand, *Degree* is performing pretty poorly with a f1 score of  93.54%, which is unfortunate, since it is needed to make degree inflexion errors, this will be discussed further in @results_grammar.sec. Two other features with poor performance are *Abbr* and *Foreign*, thankfully these features are not very important, since foreign words are not of interest, and abbreviations are are not handled by the models. *Voice* has a low recall, but a high precision, but since *Voice*  is not used for any errors as of now, it is not a problem. The rest of the features have an acceptable performance. Overall the morphologizer performs well, for most of the features, that are important.