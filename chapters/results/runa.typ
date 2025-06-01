#import "@preview/glossarium:0.5.1": gls, glspl
#import "../../utils.typ": flex-caption, customRound

#let top = csv("../../results/runa_top.csv")
#let low = csv("../../results/runa_low.csv")

The spelling model was trained on the same dataset as Kári, but the only focus was on spelling errors. The model was trained for 58 epochs. The poor quality of the dataset does not seem like it has affected the model as badly as Kári, as the model is able to correct spelling errors reasonably well. The training of the model was stopped fairly early due to the results not being promising at the time, but after a lot of work on the testset, and rerunning the tests, it turns out that the testset was not testing what it was supposed to test, and the model is actually able to correct spelling errors reasonably well.
The error type ids that the model learned are now out of date, and this can be seen in the results, the hit rate on most error types is 0%, since the model is not used in production it is not a problem, as the model would need additional training regardless to be ready for production, and in the new training it would learn the new and correct error type ids.\ \
On @results.runa.top_f_score, the top performing error types, based on the $F_(0.25)$ score, are shown.
#figure(
  caption: flex-caption(
    [Rúna's top performing $F_(0.25)$ scores],
    [Rúna's top performing $F_(0.25)$ scores]
  ),
  table(
    columns: 9,
    fill: (_, y) => if calc.odd(y) { gray.lighten(90%) },
    stroke: none,
    table.hline(),
    table.header( [*ID*], [*Error Type*], [*Num Tests*], [*Correct*], [*Incorrect*], [*$F_(0.25)$*], [*Precision*], [*Recall*], [*Hit*]),
    table.hline(),
    ..top.flatten(),
    table.hline()
  )
) <results.runa.top_f_score>
Overall in the top cateories, the model performs really well, while the recall could certainly be improved, on around half of the error types, the precision is very high, so as far as preliminary results go, this is excellent.
Looking at where the model performs well, its clear that the model is able to correct the simple spelling errors, but in addition to that, it is also able to correct *Numerals - large numbers*.
At the bottom of @results.runa.top_f_score, is *Pronouns - reflexive*, which does not fit in with the spelling errors, but the error it was able correct was a missing d, which is a pattern for a spelling mistake, but in this case it results in going from an incorrect inflexion to a correct inflexion, so while the prediction is correct, it's not good that a grammar error is being corrected as a spelling error, as it will inform the user of a spelling error instead of the actual error.
For most other error types, the precision falls drastically, and the recall is very low, for the most part, the low recall is a good thing, since it is only supposed to correct spelling errors, but the low precision is a problem, and is the reason that the model was not used in production. To get the model to perform better, it needs more training, it makes too many mistakes, on errors that dont have anything to do with spelling, and it is incapable of correcting errors like #gls("ðb"), #gls("ðm") or even the relatively simple *Accent* errors. While the spelling model is not as bad as Kári, when it comes to introducing errors, it is still not good enough to be used in production, and it needs more training.
