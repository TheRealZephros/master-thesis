#import "@preview/glossarium:0.5.1": gls, glspl

#set page(numbering: "1")
#let data = json("../results/file.json")

= Introduction <introduction.sec>
The development of large-scale language models has seen remarkable progress in recent years, but this progress has largely been concentrated in high-resource languages. Languages with limited digital presence, often referred to as ultra-low resource languages, remain underrepresented in #gls("NLP") research and tools. This thesis investigates the feasibility of developing foundational language models for such languages, with a focus on Faroese. Faroese, spoken by approximately 70,000 people, presents a number of challenges for #gls("NLP") due to the scarcity of annotated corpora, linguistic tools, and training data. The primary goal of this work is to assess what kinds of language models are realistically achievable for Faroese by surveying the available data and exploring suitable modeling approaches. \ \
Given the constraints of the available resources, this study focuses on developing a #gls("GEC") model for Faroese, a foundational component for many downstream NLP tasks. To support this goal, a spaCy pipeline will be developed using Faroese Universal Dependencies datasets. The aim is to train a #gls("POS") tagger, morphologizer, lemmatizer and a dependency parser to support grammatical analysis. This will provide essential linguistic annotations that can enhance the performance of a #gls("GEC") system. A spelling model will be explored as a complementary resource, aimed at addressing orthographic errors that often co-occur with grammatical mistakes. \ \ 
This thesis aims to contribute a practical perspective on the development of core language models in settings where data is scarce, providing insights into model performance, data requirements, and potential paths forward for #gls("NLP") in ultra-low resource language contexts.
#pagebreak(weak: true)


// #lorem(20)
// ```python
// def hello_world():
//     print("Hello, World!")
// class MyClass:
//     def __init__(self, name):
//         self.name = name

//     def greet(self):
//         print(f"Hello, {self.name}!")
// ``` 
// #raw(data, lang: "json")
// #table(
//   columns: 3,
//   table.header(..data.at(0).keys().map(k => [*#k*])),
//   ..data.map(row => row.values().map(v => [#v])).flatten()

// )
// == Reader's Guide
// Læses optimalt i two-spread