#let data = csv("../../results/runa.csv", )
== Kári <appendix.runa>
#show figure: set block(breakable: true)
#figure(
  table(
    columns: 9,
    fill: (_, y) => if calc.odd(y) { gray.lighten(90%) },
    stroke: none,
    table.hline(),
    table.header( [*ID*], [*Error Type*], [*Num Tests*], [*Correct*], [*Incorrect*], [*$F_(0.25)$*], [*Precision*], [*Recall*], [*Hit*]),
    table.hline(),
    ..data.flatten(),
    table.hline()
  )
) 