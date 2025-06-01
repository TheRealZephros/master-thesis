#import "@preview/glossarium:0.5.1": gls, glspl
#import "../../utils.typ": flex-caption, customRound

#import "graphs.typ": pretraining_graph, ex3_graph, ex3_bl_graph, ex4_graph, ex3_ol





= Results <Results.sec>
This chapter presents the results of the experiments conducted in this study. The results are organized into sections: Each section provides a detailed analysis of the performance of the models.

== spaCy Pipeline <results_spacy.sec>
A spaCy pipeline was trained on the Faroese dataset using the following components: a #gls("POS") tagger, morphologizer, lemmatizer, and dependency parser. The performance of each component was evaluated using either accuracy or precision, recall, and $F_(1)$ score, depending on what metric is relevant for the given component. The #gls("POS") tagger and morphologizer were trained on the same dataset, while the lemmatizer and dependency parser were each trained on separate datasets. Due to limited data, the same training set could not be used for all components, the amounts of data available for each component is mentioned in their section. The results of the experiments are presented in the following subsections.
To have a baseline, The Stanza model from stanford was used as a reference, since it also used data from #gls("UD"), although it only uses @farpahc. All metrics for Stanza are taken from the Stanza websites performance page @stanza_perf. The models are not using the same testset, so the results are not directly comparable, the comparisons are just to give an idea of how the models perform compared to each other.
#include "pos.typ"

#include "dep.typ"

== mT5 Pretraining <results_pretraining.sec>
This section covers the experiments conducted to pretrain a #gls("MT5") model on faroese data.
The initial results of the training were not promising, as most of the training destabilized after a few epochs. The dataset was a collection of wikipedia articles, blog posts and the Faroese corpora on #link("https://huggingface.co/")[Hugging Face] and @mtd_res. 
#ex3_ol <ex3_ol>
An initial hypothesis was that the data was not cleaned enough for the model to learn from, but looking at the graph for bitlinear, which didn't destabilize, it, This was possibly a part of the problem but not all of it. After more thorough cleaning, where all foreign characters were removed, and too short sentences were removed, as well as sentences that were too long. Additionally, common danish and english words, that do not appear in the faroese dictionary, were used to filter out sentences that were not in faroese. It was also at this point that there were some encoding errors in the data, which were fixed. After this, the training was restarted. and the result can be seen on @ex4_graph.
#ex4_graph <ex4_graph>
While the result is a bit better, it still destabilizes after 20,000 steps. At this point, the upsides and downsides of using a smaller model and bit linear were weighed. The smaller model would in theory be able to learn faster, but it seemed to be too small for the task, and while bitlinear stabilized the training, it was in the early stages of development, and had too many unknowns and could not be used in production, so in the end bitlinear was not used.
Another pretraining was conducted using the larger mT5-base model. The training used the same dataset as the previous experiment.
#pretraining_graph <pretraining_graph>
This time the training was stable and the model was able to learn from the data. The training was stopped after one epoch, which is 81203 steps, but a checkpoint was extracted after 20,000 steps to work on finetuning. The loss plot can be seen on @pretraining_graph.

== mT5 Grammar Models <results_grammar.sec>
Two #gls("MT5")-base models were trained for grammar correction. From a naming convention at Ordbogen, the models are named four letter names in the native language. The first model is named Kári (Kari internally because the danes on the team don't know how to pronounce accents), and the second model is named Bára (Bara internally for the same reason). The models were trained on different datasets and using different corruption methods. Further details about the datasets and corruption methods can be found in each of their sections, @results_grammar__kari.sec and @results_grammar__bara.sec. The models were trained using the same training parameters.
There are six error types that have testsets, but cant be made for now, because to make the errors in a manner that won't just introduce uncontrolled noise, a dependency parser is needed. These error types are *Verb Tense Inconsistent*, *Pronoun - Antecendent agreement*, *Verb - Subject agreement*, *Case - Verb*, *Case  - Preposition* and *Gender*.

#include "kari.typ"

#include "bara.typ"



== mT5 Spelling Model Rúna <results_spelling.sec>
#include "runa.typ"

