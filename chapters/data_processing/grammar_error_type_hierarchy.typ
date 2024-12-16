#import "@preview/diagraph:0.3.0": render, raw-render
#import "../../utils.typ": flex-caption, customRound
#import "@preview/glossarium:0.5.1": gls, glspl



#figure(
  caption: flex-caption(
    [A #gls("DAG") showing the error type hierarchy, where the blue nodes are the error types that are used in the errorification process. Each edge indicates that a child node has higher priority than its parent node.],
    [Error type hierarchy]
  ),
  raw-render(
    ```dot
    digraph G {
      rankdir=LR
      Grammar -> Inflexions
        Inflexions -> Adjectives
          Adjectives -> Missing_Ð
          Adjectives -> Added_Ð
        Inflexions -> Nouns
          Nouns -> Missing_Ð
          Nouns -> Added_Ð
        Inflexions -> Verbs
          Verbs -> Missing_Ð
          Verbs -> Added_Ð
      Grammar -> Pronouns
      Grammar -> Proper_Nouns
      Punctuation -> Other
        Other -> Apostrophe
        Other -> Hyphen
        Other -> Quotation_Mark
        Other -> Colon
        Other -> Semicolon
        Other -> Question_Mark
        Other -> Exclamation_Mark
      Punctuation -> Comma
        Comma -> Missing_Comma
        Comma -> Added_Comma
      Punctuation -> Period
        Period -> Missing_Space
        Period -> Ordinal_Number
      Spelling -> Capitalize
      Spelling -> Lowercase
      Spelling -> Numbers
        Numbers -> Split_Thousands
        Numbers -> Split_Over_100
        Numbers -> Under_100_Dont_Split 
      Added_Comma[fontcolor=blue]
      Added_Ð[fontcolor=blue]
      Adjectives[fontcolor=blue]
      Apostrophe[fontcolor=blue]
      Capitalize[fontcolor=blue]
      Colon[fontcolor=blue]
      Exclamation_Mark[fontcolor=blue]
      Hyphen[fontcolor=blue]
      Inflexions[fontcolor=blue]
      Lowercase[fontcolor=blue]
      Missing_Comma[fontcolor=blue]
      Missing_Ð[fontcolor=blue]
      Missing_Space[fontcolor=blue]
      Nouns[fontcolor=blue]
      Ordinal_Number[fontcolor=blue]
      Period[fontcolor=blue]
      Pronouns[fontcolor=blue]
      Proper_Nouns[fontcolor=blue]
      Question_Mark[fontcolor=blue]
      Quotation_Mark[fontcolor=blue]
      Semicolon[fontcolor=blue]
      Split_Over_100[fontcolor=blue]
      Split_Thousands[fontcolor=blue]
      Under_100_Dont_Split[fontcolor=blue]
      Verbs[fontcolor=blue]
      Word_Confusion[fontcolor=blue]
    }

    ```,
    width: 100%,
    height: 95%
  )
) <grammar_error_type_hierarchy>
