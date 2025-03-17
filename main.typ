#import "format.typ": project
#import "glossaries.typ": glossary
#import "@preview/chic-hdr:0.3.0": *
#import "@preview/lovelace:0.2.0": setup-lovelace
#import "@preview/drafting:0.2.0": set-page-properties
#import "chapters/abstract.typ": abstract
#import "@preview/wordometer:0.1.4": word-count, total-characters, total-words

#show: project.with(
  title: "Foundational Language Models for Ultra-low Resource Languages ",
  subtitle: "The Case of Faroese",
  header_title: "asd",
  doc_type: "Master Thesis in Computer Science",
  author: "Rói Olsen",
  email: "rools20@student.sdu.dk",
  department: "Department of Mathematics and Computer Science",
  affiliation: "Faculty of Science, University of Southern Denmark, Campus Odense",
  major: "Computer Science",
  address: "Odense, Denmark",
  year: "2025",
  date: "June 1, 2025",
  committee_members: (
    (
      position: "Supervisor",
      persons: (
        (
          name: "Peter Schneider-Kamp",
          title: "Professor",
          department: "Dept. of Mathematics and Computer Science",
          affiliation: "University of Southern Denmark",
        ),
      ),
    ),
    (
      position: "External Supervisor",
      persons: (
        (
          name: "Henrik Hoffmann Nielsen",
          title: "R&D Responsible",
          department: "ODIN",
          affiliation: "Ordbogen A/S",
        ),
      ),
    ),
  ),
  abstract: abstract,
  // acknowledgements: "Hopefully, I will be able to thank everyone who made this possible.",
  glossary: glossary,
  logo1: "images/SDU_BLACK_RGB_png.png",
  logo2: "images/ordbogen_logo.png",
  declaration: "sole",
)

#show: setup-lovelace

#set page(numbering: "1")
#set page(footer: [])
#counter(page).update(1)

#show: word-count

#show: chic.with(
  even: (
    chic-header(
      right-side: emph[ *Faroese Language Models* ],
    ),
    chic-footer(
      center-side: context {
        [#counter(page).at(here()).first() of #(counter(page).at(query(<final-page>).first().location()).at(0))]
      },
      right-side: text(fill: red)[#total-words words | #total-characters chars],
    ),
    chic-separator(1pt),
    chic-offset(7pt),
    chic-height(1.5cm),
  ),
  odd: (
    chic-header(
      left-side: context {
        let loc = here()
        let headings = query(selector(heading.where(level: 1)).before(loc))
        let last-heading-on-page = query(
                heading.where(level: 1))
                .rev()
                .find(h => h.location().page() == loc.page())
        if last-heading-on-page != none {
          return last-heading-on-page.body
        }
        else if headings != () {
          return headings.last().body
        } else {
          return
        }
      },
    ),
    chic-footer(
      center-side: context {
        [#counter(page).at(here()).first() of #(counter(page).at(query(<final-page>).first().location()).at(0))]
      },
      right-side: text(fill: red)[#total-words words | #total-characters chars],
    ),
    chic-separator(1pt),
    chic-offset(7pt),
    chic-height(1.5cm),
  ),
)
#set-page-properties()
#counter(page).update(0)
#include "chapters/introduction.typ"
#include "chapters/background/background.typ"
#include "chapters/materials.typ"
// #include "chapters/methods/index.typ"
#include "chapters/data_processing/data_processing.typ"
// #include "chapters/design.typ"
#include "chapters/results.typ"
// #include "chapters/results2.typ"
#include "chapters/discussion.typ"
#include "chapters/conclusion.typ"
#include "chapters/outlook.typ"

#pagebreak(weak: true)
#bibliography("ref.yml", title: [References], style: "apa")

#pagebreak(weak: true)

#include "chapters/appendix.typ"