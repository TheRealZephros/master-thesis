#import "@preview/diagraph:0.3.0": render, raw-render
#import "../../../utils.typ": flex-caption, customRound
#import "@preview/glossarium:0.5.1": gls, glspl

#let corruption_process = figure(
  caption: flex-caption(
    [An overview of the corruption process used for data augmentation.],
    [Overview of the corruption process]
  ),
  raw-render(
    engine: "fdp",
    ```
    digraph G {
      overlap=true
      rankdir=LR
      node [pin=true, shape=box, overlap=true, height=0.4]
      doc [pos="-4,0.0!", label="Create Doc"]
      lemmas [pos="-3.0,0.5!"]
      inflexions [pos="-3.0,1.5!"]
      split_a [pos="-3.0,-1.0!"]
      split_n [pos="-3.0,-2.0!"]
      split_v [pos="-3.0,-3.0!"]
      corrupt [pos="-1.0,0.0!"]
      distribute [pos="1.0,0.0!"]
      doc -> corrupt
      lemmas -> corrupt
      inflexions -> corrupt
      split_a -> corrupt
      split_n -> corrupt
      split_v -> corrupt
      corrupt -> distribute
      }
    ```,
  )
)