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
    node [pin=true, shape=box, overlap=true, height=0.3, fontsize=8]
    edge [fontsize=8]

    // Visible nodes
    tag        [pos="-2.7,0.0!", label="Tag data"]
    corrupt    [pos="-1.0,0.0!"]
    distribute [pos="0.5,0.0!"]
    file [pos="0.0,-1.0!", label="Distribution file", shape=note]

    // Invisible node (to represent an external source)
    ext [pos="-4,0.0!" style=invis, width=0, height=0.3, label=""]
    // Invisible node (to represent an external sink)
    sink [pos="2,0.0!" style=invis, width=0, height=0.3, label=""]

    // Edges
    ext -> tag            [label="txt file"]
    tag -> corrupt        [label="DocBin"]
    corrupt -> distribute [label="Json"]
    distribute -> sink    [label="train/validation set"]
    file -> distribute    [label="error distribution"]
    } 
    ```,
  )
)