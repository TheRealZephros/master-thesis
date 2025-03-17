#import "@preview/diagraph:0.3.0": render, raw-render
#import "../../utils.typ": flex-caption, customRound
#import "@preview/glossarium:0.5.1": gls, glspl

#let keyboard_typo = figure(
  caption: flex-caption(
    [Possible typographical errors that can be made for G are marked with green and the red are too far away from the correct key to be considered a probable typo.],
    [Possible typographical errors that can be made for G]
  ),
  raw-render(
    engine: "fdp",
    ```
    digraph G {
      overlap=true
      node [pin=true, shape=box, overlap=true, width=0.4, height=0.4]
      R [pos="-0.55,0.45!", fontcolor=red]
      T [pos="-0.1,0.45!", fontcolor=green]
      Y [pos="0.35,0.45!", fontcolor=green]
      U [pos="0.80,0.45!", fontcolor=red]
      D [pos="-0.90,0.0!", fontcolor=red]
      F [pos="-0.45,0.0!", fontcolor=green]
      G [pos="0.0,0.0!"]
      H [pos="0.45,0.0!", fontcolor=green]
      J [pos="0.90,0.0!", fontcolor=red]
      C [pos="-0.70,-0.45!", fontcolor=red]
      V [pos="-0.25,-0.45!", fontcolor=green]
      B [pos="0.2,-0.45!", fontcolor=green]
      N [pos="0.65,-0.45!", fontcolor=red]
      }
    ```,
  )
)