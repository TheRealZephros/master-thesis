#import "@preview/glossarium:0.5.1": gls, glspl
#import "../../utils.typ": flex-caption, customRound

#let inflexions = csv("../../results/bara_inflexions.csv")
#let eth = csv("../../results/bara_ð.csv")

=== Bára <results_grammar__bara.sec>
Bára was the second model that was trained, the corpora used for training was significantly smaller than the one used for Kári. It consisted of 1.5M sentences. After it became apparent that Kári hit a plateau, it was decided to train a second model with a more selective dataset. Anything that had questionable quality was removed, this means anything like wikipedia and scraped blog posts from unknown sources. The dataset combination of the following:
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
At the time of writing, the model is still in the early stages of fine-tuning, so the results in this section are preliminary and will most likely change significantly in the future. The model has only trained for 47 epochs, compared to the 224 epochs that Kári has trained on a larger dataset, so the results are promising. The full table with results can be seen in @appendix.bara. \ \
The top performing error types, for Bára, based on the $F_(0.25)$ score, with a perfect score of 1 are the following:
- Spelling mistake - "hesa/hesi" with "hesu"
- Punctuation - exclamation mark
- Numeral - inflexions
- Confusing "tí" and "ta"	
- Rep "rsk" and "rk"	
- Confusing "loyvi" and "loyvt"
\ 
The model is able to correct these errors with a high precision and recall, which is promising for the future, but it should still be noted that some of the training sets are quite small, and it is being worked on to get more data for these error types, so the results are subject to change. \ \
Moving on to the more difficult error types to correct. The errors is something that the model is not very good at correcting.
#figure(
  caption: flex-caption(
    [Bára's performance on Eth errors],
    [Bára's performance on Eth errors]
  ),
  table(
    columns: 9,
    fill: (_, y) => if calc.odd(y) { gray.lighten(90%) },
    stroke: none,
    table.hline(),
    table.header( [*ID*], [*Error Type*], [*Num Tests*], [*Correct*], [*Incorrect*], [*$F_(0.25)$*], [*Precision*], [*Recall*], [*Hit*]),
    table.hline(),
    ..eth.flatten(),
    table.hline()
  )
) <results.bara.eth>
The model outperforms Kári on #gls("ðb"), with a higher precision and recall, but the model still struggles with #gls("ðm") and #gls("ðt"), both in terms of precision and recall, the hit rate on these two error types is also quite low, which is unfortunate, and needs improvement. 
When it comes to inflexion errors, it is also a mixed bag, the model performs well on some error types, but not so well on others as can be seen on @results.bara.inflexions.

#figure(
  caption: flex-caption(
    [Bára's inflexion errors],
    [Bára's inflexion errors]
  ),
  table(
    columns: 9,
    fill: (_, y) => if calc.odd(y) { gray.lighten(90%) },
    stroke: none,
    table.hline(),
    table.header( [*ID*], [*Error Type*], [*Num Tests*], [*Correct*], [*Incorrect*], [*$F_(0.25)$*], [*Precision*], [*Recall*], [*Hit*]),
    table.hline(),
    ..inflexions.flatten(),
    table.hline()
  )
) <results.bara.inflexions>
When it comes to *Adjectives* the model performs better than Kári, with a higher precision, but at the cost of a lower recall, while it would be nice to have a higher recall, the increased precision is more important. The same can be said for *Verbs*, the model has a higher precision, but a lower recall, not ideal, but an improvement. Unfortunately, for *Nouns* the model has a lower precision and recall, and the hit rate is low. Overall the inflexions have a low hit rate, which may mean that the model is still struggling with language understanding, and is not able to understand the context of the sentence well enough to give the correct error type. 