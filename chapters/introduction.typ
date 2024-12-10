#import "@preview/glossarium:0.5.1": gls, glspl

#set page(numbering: "1")
#let data = json("../results/file.json")

= Introduction <introduction.sec>
#lorem(20)

```python

def hello_world():
    print("Hello, World!")

  
class MyClass:
    def __init__(self, name):
        self.name = name

    def greet(self):
        print(f"Hello, {self.name}!")


``` 

// #raw(data, lang: "json")


#table(
  columns: 3,
  table.header(..data.at(0).keys().map(k => [*#k*])),
  ..data.map(row => row.values().map(v => [#v])).flatten()
  
)

// == Reader's Guide
// Læses optimalt i two-spread

#pagebreak(weak: true)