#import "../../format.typ": appendix
#import "@preview/glossarium:0.5.1": gls, glspl
#import "../../utils.typ": flex-caption
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
#include "kari.typ"
#pagebreak(weak: true)
#include "bara.typ"
#pagebreak(weak: true)

<final-page>