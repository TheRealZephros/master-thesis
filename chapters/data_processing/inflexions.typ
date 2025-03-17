#import "../../utils.typ": flex-caption, customRound
#import "@preview/glossarium:0.5.1": gls, glspl
#import "@preview/lovelace:0.2.0": pseudocode, no-number, ind, ded,algorithm, data


#let inflexion_json = data(
  caption: flex-caption(
    [Inflexion data for the Faroese language.],
    [Inflexion data for Faroese]
  ),
  ```json
{
  "noun": {
      "10-mannafar": [
          {
              "gender": "Neut",
              "case": "Nom",
              "number": "Sing",
              "definiteness": "Ind",
              "word": "10-mannafar"
          },
          {
              "gender": "Neut",
              "case": "Nom",
              "number": "Sing",
              "definiteness": "Def",
              "word": "10-mannafari\u00f0"
          },
...
  
  ```
)