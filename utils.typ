#let kbd = text => {
  box(
    fill: black.lighten(95%),
    stroke: (bottom: black.lighten(70%), top: black.lighten(80%), x: black.lighten(80%)),
    width: 1em,
    height: 1em,
    radius: 3pt,
    baseline: 2pt,
    outset: 0pt,
  )[#align(center)[#text]]
}

#let errHighlight(body) = {
  underline(stroke: 1.5pt + red, offset: 3pt)[#body]
}

#let changedErrHighlight(body) = {
  underline(stroke: (paint: red, thickness: 1.5pt, dash: "densely-dotted"), offset: 3pt)[#body]
}

#let punctHighlight(body) = {
  underline(stroke: 1.5pt + blue, offset: 3pt)[#body]
}

#let corrHighlight(body) = {
  underline(stroke: 1.5pt + green, offset: 3pt)[#body]
}

#let in-outline = state("in-outline", false)

#let flex-caption(long, short) = context if in-outline.get() { short  } else { long }

#let refHyp = (idx) => {
  let lab = "hyp-" + str(idx)
  [
    #link(label(lab))[*Hypothesis #idx*]
  ]
}

#let customRound(number, precision) = {
  assert(precision > 0)
  let s = str(calc.round(number, digits: precision))
  let tail = s.find(regex("\\..*"))
  let pad = if tail == none {
    s = s + "."
    precision
  } else {
    precision - tail.len() + 1
  }
  s + pad * "0"
}

#let formatScore(model, corpus, metric, group) = {
  if model.at(corpus).at(metric) < 0 {
    [-]
  } else {
    if calc.round(model.at(corpus).at(metric), digits: 4) == calc.round(calc.max(..group.map(data => data.at(corpus).at(metric))), digits: 4) {
      [*#customRound(model.at(corpus).at(metric) * 100, 2)*]
    } else {
     [#customRound(model.at(corpus).at(metric) * 100, 2)]
    }
  }
}