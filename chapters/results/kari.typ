#import "@preview/glossarium:0.5.1": gls, glspl
#import "../../utils.typ": flex-caption, customRound

#let top_f_score = csv("../../results/top_f_score.csv")
#let eth = csv("../../results/ð_errors.csv")
#let inflexions = csv("../../results/inflexions.csv")

=== Kári <results_grammar__kari.sec>
Kári was the first model trained, it was trained on 4.4M sentences, This dataset consisted of everything that was available at the time, this is everything on Hugging Face, #gls("MTD")s website and and github repository, #gls("NLLB"), Liebzig corpora and scraped articles from @faroe_uni_press. The dataset was cleaned as described in @data_cleaning.sec and split into 95% training and 5% validation. Out of the 95%, 5% of the training data was un-corrupted to teach the model to not always correct.
The full table with results can be seen in @appendix.kari. \ \
On @results.kári.top_f_score, the best performing error types, based on the $F_(0.25)$ score, are shown.
#figure(
  caption: flex-caption(
    [Kári's top performing $F_(0.25)$ scores],
    [Kári's top performing $F_(0.25)$ scores]
  ),
  table(
    columns: 9,
    fill: (_, y) => if calc.odd(y) { gray.lighten(90%) },
    stroke: none,
    table.hline(),
    table.header( [*ID*], [*Error Type*], [*Num Tests*], [*Correct*], [*Incorrect*], [*$F_(0.25)$*], [*Precision*], [*Recall*], [*Hit*]),
    table.hline(),
    ..top_f_score.flatten(),
    table.hline()
  )
) <results.kári.top_f_score>
When looking at the error types, where the model performed best, it's not as simple as the model performing best on the most common error types in the training data, but this is the case *Punctuation - exclaimation mark*, but not because exclamaition marks are all that common, but because an alternative correction for the errors is to use a comma instead of an exclaimation mark, and comma is one of the most represented error in the training data, this also means that the hit percentage for exclaimation marks is 0%. This highlights a significant problem with the testset, as the model is now getting max $F_(0.25)$ score for an error type that it didn't use at all, while it corrected the sentence in a correct manner, it gets scored as being good at exclaimation marks, which is not nessecarily the case, since the testset is not measuring it correctly in its current state. *Rep "rsk" and "rk"* is an example of the opposite, there are very few examples of this in the training data, with only 5800 examples, and additionally there is only one test sentence with the error type, so its hard to draw a conclusion about how this generalizes. *Numeral - inflexions* is another error type that has few test sentences, and the model has a high precision, but with so few sentences its not possible to say if this generalizes over a larger dataset. *Numerals - large numbers* has a perfect precision, but a low recall, this is because the model has learned to set the correct "thousand" separator, but has not learned to correct swapped separators and decimal points, but this is a minor error overall and being careful to not change numbers too aggressively is not nessecarily a bad thing and large numbers that also have decimals are not common in the dataset. The two spelling mistake error types, *gi omlyd* and *ki omlyd* are fairly simple, but there are not that many examples of them, so the the low recall on *gi omlyd* is not a surprise and the high precision is good for so few examples in the training data. The last top performing error type *Confusing - "í" and "ið"* is on of the most common errors that people make. From the results it can be seen that the model makes mistakes on the test set, but the errors are on different words than the ones that are relevant to the error type, so the model is not actually making mistakes on the error type, itself but wrongly predicting other words in the sentence, which is a recurring problem. \ \
Eth errors are the most common spelling / grammatical errors in faroese, and it is important that the model learns these. The errors are split into three types, swapped, missing, and added, they are called #gls("ðb"), #gls("ðm") and #gls("ðt") on @results.kári.eth. 

#figure(
  caption: flex-caption(
    [Kári's Eth errors],
    [Kári's Eth error]
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
) <results.kári.eth>
Unfortunately, the performance is not as good as it could be, with the model only finding 20% of the #gls("ðb") errors correcting them, the low precision comes from the model making mistakes on other words. In addition to this, the hit percentage is only 50%, which is not great, the model tagged one of the corrections as a #gls("ðt") error, but since there are only two cases where it corrected the error, its hard to say if the model will mix the errors in general or if it's a standalone case. The model performs better on the #gls("ðm") errors, with a precision of 0.83 and a recall of 45, this is a better result, but the model still misses half of the errors, which is not ideal and still makes too many errors, while it is one of the more complex errors, it is very common and well represented in the dataset. In addition to this, the hit percentage is 0%, this is due to an oversight and a bug in the corruption method, where the error type was not given priority over the inflexion types, so the model predicts inflexion errors instead of #gls("ðm"), while this is not a grammatical error as such, it is definetly preferable to have the correct error type attached, so the end user can get a better and more precise description of the error that they are making. But ultimately the hit rate is easily fixed by giving #gls("ðm") priority over inflexion errors, and then re-corrupting the dataset, and continuing training for a few epochs.
The last eth error, #gls("ðt"), also has a far too low recall and precision, but at least the model has a better hit rate of 84.4%, but by inspecting the predictions, the model made, it is making mistakes on other words, and the hit percentage is actually better than the results show. \ \
Inflexion errors are the second most common grammatical errors in faroese, so it is important that the model performs well on these. The main wordclasses that are relevant for this are *Adjectives*, *Nouns* and *Verbs*.  The results for the inflexion errors for the three main wordclasses can be seen on @results.kári.inflexions.
#figure(
  caption: flex-caption(
    [Kári's inflexion errors],
    [Kári's inflexion errors]
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
) <results.kári.inflexions>
Here it is quite clear that the model is underperforming, especially on *Nouns*, around a third of the predictions are wrong and on top of that, the recall is only 0.32. *Adjectives* and *Verbs* are performing better, when it comes to correctly predicting the errors, they still have lower precision, from wrong predictions on other words. The recall of *Verbs* is 0.63, which is not good, but its better than the other two wordclasses. A problem that stems from the #gls("POS") tagger, is that it tends to mistake the wordclasses of certain *Adjectives* for *Verbs*, this happens for words like "skivað"(written), when the word is tagged with the wrong wordclass, it will then have the wrong inflexion errors made, so it is likely that a better #gls("POS") tagger will improve performance on inflexions in general.
When it comes to punctuation, the models performance is absolutely abysmal. It is so bad that it ends up making significantly more mistakes than it corrects, in fact most of its "corrections" are wrong, and here the problem of too poor quality training data couldn't be more clear. Looking at the error type *Comma - missing* it was only able to correct 0.6% of the errors, and it introduced errors on 23% of the sentences. The amount of comma errors in the training data was around 10%, so the amount of data was clearly not the issue here, it is simply a matter of what it learned from the data is not correct. Because of the fact that comma errors perform so badly, it introduces a lot of errors on other tests, and is one of the major reasons why the model performs so poorly in terms of precision.
The biggest problem with Kári was that the dataset it was trained on was of too poor quality, and this put a limit on how well the model could learn. 
Another issue was the corruption method was too broad, and errors with gender and tense were made in cases where, from the context, its not possible to say if one is more grammatically correct than the other. An example of this is a sentence like "Hann er heima." (He is home.), an error could be introduced on "Hann" (He) where it's changed to "Hon" (She) or "er" (is) to "var" (was), errors like this will just confuse the model and encourage unnecessary correction, and this could be seen clearly through manual inspection when running the testset. Additionally the model would lowercase names, which causes problems in a lot of testsets, and makes it difficult to evaluate if the model is actually bad at the error type being tested, or if its making wrong predictions because of the names being lowercased. \ \