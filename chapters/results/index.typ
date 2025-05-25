#import "@preview/glossarium:0.5.1": gls, glspl
#import "../../utils.typ": flex-caption, customRound

#import "graphs.typ": pretraining_graph, ex3_graph, ex3_bl_graph, ex4_graph, ex3_ol

#let spacy = json("../../results/spacy_morph_tag.json")
#let stanza = json("../../results/stanza-fo_performance.json")

= Results <Results.sec>
This chapter presents the results of the experiments conducted in this study. The results are organized into sections: Each section provides a detailed analysis of the performance of the models and the evaluation metrics used to assess their effectiveness.


== spaCy Pipeline <results_spacy.sec>
A spaCy pipeline was trained on the Faroese dataset using the following components: a #gls("POS") tagger, morphologizer, lemmatizer, and dependency parser. The performance of each component was evaluated using either accuracy or precision, recall, and F1 score, depending on what metric is relevant for the given component. The #gls("POS") tagger and morphologizer were trained on the same dataset, while the lemmatizer and dependency parser were each trained on separate datasets. Due to limited data, the same training set could not be used for all components, the amounts of data available for each component is mentioned in their section. The results of the experiments are presented in the following subsections.
To have a baseline, The Stanza models from stanford was used as a reference, since it also used data from #gls("UD"), although it only uses @farpahc. All metrics for Stanza are taken from the Stanza websites performance page @stanza_perf.

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
From the results, it is clear that the spaCy pipeline performs better thatn the stanza model, when it comes to overall accuracy of the #gls("POS") tagger and morphologizer. On @morph_feats, a more detailed view of the performance of the morphologizer is shown. The table shows the precision, recall and F1 score for each feature.
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
Looking at the results, the morphologizer performs reasonably well, on most features, especially on *Mood*, *Definite*, *Tense* and *NameType*. The *Mood* and *NameType* features are not used for anything in the pipeline, as of now, but its still good to have them for future use. The *Definite* and *Tense* features are very important for making inflexion errors, so it is good that they are performing well. On the other hand, *Degree* is performing pretty poorly with a f1 score of  93.54%, which is unfortunate, since it is needed to make degree inflexion errors, this will be discussed further in @results_grammar.sec. Two other features with poor performance are *Abbr* and *Foreign*, thankfully these features are not very important, since foreign words are not of interest, and abbreviations are are not handled by the models. *Voice* has a low recall, but a high precision, but since *Voice*  is not used for any errors as of now, it is not a problem. The rest of the features have an acceptable performance. Overall the morphologizer performs well, for most of the features, that are important.

=== Lemmatizer & Dependency Parser <lemma_dep.sec>
An experiment was conducted to see what performance the lemmatizer and dependeny parcer could achieve on the very limited data. On @dep_parsers, the comparison between the lemmatizer and dependency parser performance metrics for the spaCy and Stanza models is shown.
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
Two #gls("MT5")-base models were trained for grammar correction. From a naming convention at Ordbogen, the models are named four letter names in the native language. The first model in named Kári(Kari internally because danes dont know how to pronounce or write accents), and the second model is named Bára(Bara internally for the same reason). The models were trained on different datasets and using different corruption methods. Further details about the datasets and corruption methods can be found in each of their sections, @results_grammar__kari.sec and @results_grammar__bara.sec. The models were trained using the same training parameters. // TODO add training parameters



=== Kári <results_grammar__kari.sec>
Kári was the first model trained, it was trained on 4.4M sentences, This dataset consisted of everything that was available at the time, this is everything on Hugging Face, #gls("MTD")s website and and github repository, #gls("NLLB"), Liebzig corpora and scraped articles from @faroe_uni_press. The dataset was cleaned as described in @data_cleaning.sec and split into 95% training and 5% validation, 5% of the training data was un-corrupted.
The full table with results can be seen in @appendix.kari. \ \



The biggest problem with Kári was that the dataset it was trained on was of too poor quality, and this put a limit on how well the model could learn. 
Another issue was the corruption method was too broad, and errors with genderand tense were made in cases where, from the context, its not possible to say if one is more grammatically correct than the other. An example of this is a sentence like "Hann er heima." (He is home.), an error could be introduced on "Hann" (He) where it's changed to "Hon" (She) or "er" (is) to "var" (was), errors like this will just confuse the model and encourage unnecessary correction, and this could be seen clearly through manual inspection when running the testset. Additionally the model would lowercase names, which causes problems in a lot of testsets, and makes it difficult to evaluate if the model is actually bad at the errortype being tested, or if its making wrong predictions because of the names being lowercased.

=== Bára <results_grammar__bara.sec>
Bára was the second model that was trained, the corpora used for training was significantly smaller than the one used for Kári. It consisted of 1.5M sentences. After it became apparent that Kári hit a plateau, it was decided to train a secon model with a more selective dataset. Anything that had questionable quality was removed, so anything like wikipedia and scraped blog posts from unknown sources. The dataset combination of the following:
- two private datasets from #gls("MTD")
- scraped papers from #gls("FRO") and #gls("FROB") @faroe_uni_press
- scraped articles from #link("https://www.foroyalandsstyri.fo/fo/kunning/tidindi")[Føroya Landssýri]
- #link("https://huggingface.co/datasets/barbaroo/Sprotin_parallel")[Sprotin parallel]
- #link("https://huggingface.co/datasets/barbaroo/Faroese_BLARK_small")[Faroese BLARK small]
- #link("https://github.com/giellalt/corpus-fao/blob/main/converted/blogs/birgir_kruse/birk_285637.txt.xml")[Blog posts by Birgir Kruse]
- #link("https://github.com/giellalt/corpus-fao/blob/main/converted/ficti/prose/brodrasamkoma.txt.xml")[Articles from Bróðrasamkoman]
- #link("https://github.com/giellalt/corpus-fao/blob/main/converted/ficti/prose/bok_ymisk.txt.xml")[A collection of books]
- #link("https://github.com/giellalt/corpus-fao/blob/main/converted/news/kvf/kvf_4773879.txt.xml")[Articles from Kringvarp Føroya]
\
In addition to the smaller dataset, Bára not finetuned from the pretrained #gls("MT5") model, from @results_pretraining.sec, but the pretrained model on #link("https://huggingface.co/google/mt5-base")[Hugging Face]. Since the pretrained model from @results_pretraining.sec was trained on an earlier version of the dataset Kári was trained on, and it was not good enough to be used for training, it was decided that it would be better to use the model on #link("https://huggingface.co/google/mt5-base")[Hugging Face]. 
Lastly, the corruption process was modified to be more selective when introducing errors, particularly when it comes to introducing gender errors and tense errors. This was one of the main problems with Kári, as the model ended up introducing a lot of errors by unnecessarily changing the gender and tense of words.



== mT5 Spelling Model <results_spelling.sec>


