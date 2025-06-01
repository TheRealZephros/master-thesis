#import "@preview/plotst:0.2.0": axis, plot, graph_plot, overlay
#import "../../utils.typ": flex-caption, customRound
#import "@preview/glossarium:0.5.1": gls, glspl


#let pretraining = csv("../../results/pretraining.csv", )
#let pretraining = pretraining.map(row => (int(row.first()),float(row.last())) )
#let x_axis = axis(min: 0, max: 81203, step: 10000, location: "bottom")
#let y_axis = axis(min: 3, max: 10, step: 1, location: "left", helper_lines: true,)
#let pretraining_plot = plot( data: pretraining, axes: (x_axis, y_axis))

#let ex3 = csv("../../results/ex3_data.csv", )
#let ex3 = ex3.map(row => (int(row.first()),float(row.last())) )
#let ex3_x_axis = axis(min: 0, max: 81200, step: 10000, location: "bottom")
#let ex3_y_axis = axis(min: 0, max: 50, step: 5, location: "left", helper_lines: true,)
#let ex3_plot = plot( data: ex3, axes: (ex3_x_axis, ex3_y_axis))

#let ex3_bl = csv("../../results/ex3_bl_data.csv", )
#let ex3_bl = ex3_bl.map(row => (int(row.first()),float(row.last())) )
#let ex3_bl_x_axis = axis(min: 0, max: 81200, step: 10000, location: "bottom")
#let ex3_bl_y_axis = axis(min: 0, max: 50, step: 5, location: "left", helper_lines: true,)
#let ex3_bl_plot = plot( data: ex3_bl, axes: (ex3_bl_x_axis, ex3_bl_y_axis))

#let ex4 = csv("../../results/ex4_data.csv", )
#let ex4 = ex4.map(row => (int(row.first()),float(row.last())) )
#let ex4_x_axis = axis(min: 0, max: 81200, step: 10000, location: "bottom")
#let ex4_y_axis = axis(min: 3, max: 6, step: 1, location: "left", helper_lines: true,)
#let ex4_plot = plot( data: ex4, axes: (ex4_x_axis, ex4_y_axis))


#let pretraining_graph = graph_plot(
  pretraining_plot, (100%, 30%),
  caption: flex-caption(
    [#gls("MT5")-base pre-training loss],
    [#gls("MT5")-base pre-training loss]
  ),
  stroke: blue,
)
#let ex3_graph = graph_plot(
  ex3_plot, (100%, 30%),
  caption: flex-caption(
    [smaller #gls("MT5") pre-training loss, Red is Bitlinear and Blue is the regular smaller #gls("MT5")],
    [#gls("MT5") pre-training performance metrics]
  ),
  stroke: blue,
)
#let ex3_bl_graph = graph_plot(
  ex3_bl_plot,(100%, 30%),
  caption: flex-caption(
    [smaller #gls("MT5") pre-training loss, Red is Bitlinear and Blue is the regular smaller #gls("MT5")],
    [smaller #gls("MT5") pre-training loss]
  ),
  stroke: red,
)
#let ex4_graph = graph_plot(
  ex4_plot, (100%, 30%),
  caption: flex-caption(
    [#gls("MT5") pre-training performance metrics],
    [#gls("MT5") pre-training performance metrics]
  ),
  stroke: green,
)

#let ex3_ol = overlay(
  (ex3_bl_graph, ex3_graph),
  (100%, 30%),
)
