#import "@preview/glossarium:0.5.1": make-glossary, print-glossary, register-glossary
#import "utils.typ": in-outline, flex-caption
#import "@preview/lovelace:0.2.0": algorithm



#let small_title(content, outlined: true) = {
  align(center)[
    // #show heading.where(level: 1): set text(size: 0.85em)
    #show heading.where(level: 1): it => block[
      #set text(size: 0.85em)
      #it.body
    ]
    #heading(
      outlined: outlined,
      numbering: none,
      content,
      // text(0.85em,content),
    )
    #v(5mm)
  ]
}

#let project(
  title: "",
  subtitle: "",
  header_title: "",
  doc_type: "thesis",
  abstract: [],
  author: "",
  email: "",
  affiliation: "",
  address: "",
  department: "",
  major: "",
  year: "2025",
  date: "June 1, 2025",
  logo1: none,
  logo2: none,
  committee_members: (),
  declaration: "none",
  statement: "",
  acknowledgements: "",
  dedication: "",
  glossary: (),
  body,
) = {
  set page(
    paper: "a4",
    margin: 2.5cm,
    header-ascent: 0.4in,
    footer-descent: 0.3in,
  )
  
  // Set the document's basic properties.
  set document(author: author, title: title)
  // set text(font: "New Computer Modern", lang: "en")
  set text(
    size: 12pt,
    font: "New Computer Modern",
    stretch: 120%,
    lang: "en",
  )
  show math.equation: set text(weight: 400)
  set math.equation(numbering: "(1.1)")
  // Currently not directly supported by typst
  set math.equation(numbering: "(1)")
  set heading(numbering: "1.1")
  set par(justify: true)
  
   // Glossary
  show: make-glossary
  register-glossary(glossary)

  // show heading.where(level: 1): set text(size: 24pt)
  show heading.where(level: 2): set text(size: 18pt)
  show heading.where(level: 3): set text(size: 14pt)
  
  show outline.entry.where(level: 1): it => {
    v(16pt, weak: true)
    strong(it)
  }
  show outline.entry.where(level: 2): it => {
    it
  }
  show link: set text(fill: blue.darken(40%))
  show ref: it => {
    let eq = math.equation
    let hd = heading
    let el = it.element
    let fg = figure
    if el != none {
      if el.func() == eq {
        // Override equation references.
        // link(el.label)[#numbering(el.numbering, counter(eq).display())]
        link(el.label)[#numbering(el.numbering, ..counter(eq).at(el.location()))]
      } else if (el.func() == hd) {
        // Override heading references.
        let count = counter(heading).at(el.location())
        if count.len() == 1 or count.at(1) == 0 {
          link(el.label)[#text(fill: blue.darken(60%))[Chapter #count.at(0)]]
        } else {
          [#text(fill: blue.darken(60%))[#it]]
        }
      } else if el.func() == fg {
        // Override figure references.
        text(fill: blue.darken(60%))[#it]
      } else {
        // Other references as usual.
        it
      }
    } else {
      it
    }
  }

  show bibliography: set par(
    first-line-indent: 0in,
    hanging-indent: 0.2in
  )
  show cite: set text(fill: green.darken(40%))
  
  // Title page.
  // Logo1
  if logo1 != none {
    v(0.50fr)
    align(center, image(logo1, width: 50%))
    v(0.5fr)
    align(center)[
      #text(1.4em, weight: 550, doc_type)
    ]
    
    v(0.30fr)
  } else {
    v(0.50fr)
    
    align(center)[
      #text(2em, weight: 700, doc_type)
    ]
    
    v(0.50fr)
  }
  
  align(center)[
    #line(length: 100%)
    #v(1em, weak: true)
    #text(2em, weight: 700, title) \
    #text(1.5em, weight: 600, subtitle)
    #v(1em, weak: true)
    #line(length: 100%)
  ]
  
  v(0.5cm)
  align(center)[Author]
  v(0.5cm)
  
  // committee
  let commitee_body = ()
  for mitem in committee_members {
    let pos_printed = false
    for person in mitem.persons {
      if pos_printed {
        commitee_body.push("")
      } else {
        commitee_body.push(align(start + horizon, mitem.position + ": "))
      }
      pos_printed = true
      commitee_body.push([
        *#person.name* \
        #person.title, #person.department \ #person.affiliation
      ])
    }
    commitee_body.push(v(0.5cm))
    commitee_body.push(v(0.5cm))
  }
  
  // Author information.
  align(center)[
    *#text(size: 16pt)[#author]* \
    #if email != "" [#email \ ]
    
    #v(0.5cm)
    #grid(columns: 2, gutter: 3mm, ..commitee_body)
    // #v(0.5cm)
  ]
  
  // Department and location
  align(center)[
    #date
    ]
  v(0.5cm)
  
  align(center)[
    #department \
    #affiliation
  ]
  
  v(0.5cm)
  
  // logo2
  if logo2 != none {
    align(center, image(logo2, width: 50%))
  }
  
  v(0.5cm)
  
  align(center)[
    © #author #year
  ]
  
  pagebreak()
  set page(numbering: "i", number-align: center)
  
  if declaration != "none" {
    small_title([Author's Declaration])
    if declaration == "sole" [
      I hereby declare that I am the sole author of this thesis. This is a true copy
      of the thesis, including any required final revisions, as accepted by my
      examiners.
    ] else if declaration == "compiled" [
      This thesis consists of material all of which I authored or co-authored: see
      Statement of Contributions included in the thesis. This is a true copy of the
      thesis, including any required final revisions, as accepted by my examiners.
      
      I understand that my thesis may be made electronically available to the public.
    ] else [
      The author makes no declaration yet.
    ]
    pagebreak()
  }
  
  if statement != "" {
    small_title([Statement of Contributions])
    statement
    pagebreak()
  }
  
  // Abstract page.
  // v(1fr)
  small_title([Abstract])
  abstract
  // v(1.618fr)
  // pagebreak()
  
  // small_title([Acknowledgements])
  // acknowledgements
  
  pagebreak()
  
  if dedication != "" {
    small_title([Dedication])
    dedication
    pagebreak()
  }
  
  show heading.where(level: 1): it => [
    #set text(size: 24pt)
    #v(1.5in)
    #par(first-line-indent: 0pt)[#it.body]
    #v(1.5cm)
  ]
  
  // Table of contents.
  in-outline.update(true)
  heading("Table of Contents", numbering: none, outlined: false)
  outline(title: none, depth: 3, indent: true)
  pagebreak()
  
  heading("List of Figures", numbering: none)
  outline(
    title: none,
    depth: 3,
    indent: true,
    target: figure.where(kind: image),
  )
  pagebreak()
  
  heading("List of Tables", numbering: none)
  outline(
    title: none,
    depth: 3,
    indent: true,
    target: figure.where(kind: table),
  )
  pagebreak()
  
  heading("List of Snippets", numbering: none)
  outline(
    title: none,
    depth: 3,
    indent: true,
    target: figure.where(kind: "lovelace"),
  )
  in-outline.update(false)
  pagebreak()
  
  heading(outlined: true, numbering: none, text("Glossary"))
  print-glossary(glossary)
  pagebreak(weak: true)
  
  
  // Main body.
  set par(first-line-indent: 20pt)
  
  show heading.where(level: 1): it => [
    // #pagebreak(weak: true)
    #set text(size: 24pt)
    #v(1.5in)
    #block[
      #if it.numbering != none [
        Chapter #counter(heading).display()
        #v(0.5cm)
      ]
      #par(first-line-indent: 0pt)[#it.body]
    ]
    #v(1.5cm, weak: true)
  ]
  show heading.where(level: 2): it => [
    #set text(size: 18pt)
    #v(1cm, weak: true)
    #block[
      #if it.numbering != none [
        #counter(heading).display()
      ]
      #it.body
    ]
    #v(1cm, weak: true)
  ]
  show heading.where(level: 4): it => [
    #block[
      #it.body
    ]
  ]
  show heading.where(level: 2): set text(size: 18pt)
  show heading.where(level: 3): set text(size: 14pt)
  show figure: it => {
    v(3mm)
    align(center)[
      #block(spacing: 0mm)[
        #block(spacing: 0mm)[#it.body]
        #block(inset: (x: it.gap * 2, y: 0mm), spacing: it.gap)[#text(size: 0.9em)[#it.caption]]
      ]
    ]
    v(3mm)
  }
  
  body
}

#let appendix(body) = {
  set heading(numbering: (..x) => [#("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z").at(x.pos().at(1) - 1)])
  set figure(numbering: none)
  show heading.where(level: 1): it => [
    #set text(size: 24pt)
    #v(1in)
    #block[
      #if it.numbering != none [
        Appendix #counter(heading).display()
      ]
      #par(first-line-indent: 0pt)[#it.body]
    ]
    #v(1cm, weak: true)
  ]
  show heading.where(level: 2): it => [
    #set text(size: 24pt)
    #v(1in)
    #block[
      #if it.numbering != none [
        Appendix #counter(heading).display()
      ]
      #par(first-line-indent: 0pt)[#it.body]
    ]
    #v(1cm, weak: true)
  ]
  counter(heading).update(0)
  body
}
