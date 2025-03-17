#import "../../utils.typ": flex-caption, customRound
#import "@preview/glossarium:0.5.1": gls, glspl
#import "@preview/lovelace:0.2.0": pseudocode, no-number, ind, ded,algorithm, data

#let errors_xml = data(
  caption: flex-caption(
    [An example of how a sentence in the private corpus is formatted (this is not a real sentence from the corpus)],
    [An example of how a sentence in the private corpus is formatted]
  ),
 ```xml
<s n=“1”>
    <w>Vit</w>
    <revision id=“15”>
        <original>
            <w>fóru</w>
        </original>
        <corrected>
            <w>fara</w>
        </corrected>
        <errors>
            <error xtype=“past4pres” eid=“0” />
        </errors>
    <revision id=“16”>
        <original>
            <w>niðaná</w>
        </original>
        <corrected>
            <w>niðan</w>
            <w>á</w>
        </corrected>
        <errors>
            <error xtype=“adv4adv-prep” eid=“0” />
        </errors>
    </revision>
    <w>fjallið</w>
    <c>.</c>
</s>
```
)