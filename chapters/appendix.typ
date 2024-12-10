#import "../format.typ": appendix
#import "@preview/glossarium:0.5.1": gls, glspl
#import "../utils.typ": flex-caption
#import "@preview/chic-hdr:0.3.0": *


#show: chic.with(
  even: (
    chic-header(
      right-side: emph[ *Faroese Language Models* ],
    ),
    chic-footer(
      center-side: context {
        [#counter(page).at(here()).first() of #(counter(page).at(query(<final-page>).first().location()).at(0))]
      },
    ),
    chic-separator(1pt),
    chic-offset(7pt),
    chic-height(1.5cm),
  ),
  odd: (
    chic-header(
      left-side: "APPENDICES",
    ),
    chic-footer(
      center-side: context {
        [#counter(page).at(here()).first() of #(counter(page).at(query(<final-page>).first().location()).at(0))]
      },
    ),
    chic-separator(1pt),
    chic-offset(7pt),
    chic-height(1.5cm),
  ),
)

#counter(heading).update(0)

#pagebreak(weak: true)

#heading("APPENDICES", numbering: none) <appendices>

#show: appendix

#pagebreak(weak: true)

// == Cognitive-M dataset distribution <specdata.app>
// To investigate whether the dataset distribution has an impact on the performance of the Cognitive-M model, a new dataset was created by randomly sampling lines from the Cognitive-L dataset until a dataset with the same number of lines as Cognitive-M was obtained, this new dataset and the resulting model will be referred to as Cognitive-M2. The figures #link(<disttrain.figapp>, text(fill: blue.darken(60%))[Figure C1]) and #link(<disteval.figapp>, text(fill: blue.darken(60%))[Figure C2]) show the training and evaluation results respectively of Cognitive-M2, and compare it with the original Cognitive-M model. By inspecting the graphs, it's clear that a much more performant Cognitive-M can be obtained by random sampling. All training metrics are improved, and the precision of the model is also greatly improved; the recall remains similar. This goes to show that the Cognitive-M model does _find_ about the same amount of spelling errors as Cognitive-M2, but it's making too many false positive predictions. To further highlight the differences between the two models, #link(<tag_comp_table_small.figapp>, text(fill: blue.darken(60%))[Figure C3]) shows a tabular view of the best and final epochs of the two models on the #smallcaps[GSpell] dataset.

// #figure(
//   caption: flex-caption(
//     [Table C3: Comparison of the precision, recall, and $bold(upright(F))_0.5$ score of the best and final epoch of Cognitive-M and Cognitve-M2 on the #smallcaps[GSpell] dataset. The *E* column signifies at which epoch the best results were achieved for each model. The final epoch is always the 10th epoch. Epochs are ranked in terms of their $bold(upright(F))_0.5$ score on #smallcaps[GSpell]. "Diff" is the #text(weight: "bold")[diff]erence between the best and final epoch in terms of $bold(upright(F))_0.5$ score.],
//     [Table C3: Tabular comparison of Cognitive-M and Cognitive-M2]
//   ),
//   tag_comp_table_small
// ) <tag_comp_table_small.figapp>

~

<final-page>