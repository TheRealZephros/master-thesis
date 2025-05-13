#import "@preview/glossarium:0.5.1": gls, glspl

= Materials <materials.sec>
This section describes the materials used in the study, including the datasets, tools, and resources that were essential for conducting the experiments and analyses. 

== spaCy <spacy.sec>
Spacy is an open-source software library for advanced #gls("NLP") in Python. It is designed specifically for production use and is widely used in industry. Spacy provides a wide range of features for processing text data, including tokenization, part-of-speech tagging, named entity recognition, and dependency parsing. It also includes pre-trained models for a variety of languages and domains, making it easy to get started with #gls("NLP") tasks. The relevant features of spaCy for this thesis are the #gls("POS") tagger and morphologizer and to a lesser degree the lemmatizer and dependency parsing capabilities.

== NanoT5 <nanot5.sec>
NanoT5 @nawrot 


== Language Resources From #gls("MTD") <mtd.sec>
#gls("MTD") Has released a number of resources for the Faroese language. A Github repository @fo_nlp_res contains a collection of datasets and models @mtd_res. \ \ 
A private corpus developed by Uni Johannesen was used as a testset to evaluate the performance of the grammar and spelling models. The corpus contains \~2700 sentences and consists of manually corrected and annotated essays from students. The essays were written in Faroese and contain a variety of errors, including spelling, grammar, and punctuation errors. Additionally the data used in the study by @Næs on spelling errors in faroese students' essays, was also used in this study.

== Faroe University Press Papers And Books <fro.sec>
#gls("FRO") has published a number of papers and books in the various fields. The file format of the papers and books is pdf, so some preprocessing is needed to get the text out of them. All publications can be found for free on their #link("https://ojs.setur.fo/index.php/index/index")[website]. The papers are from #gls("FRO"). #gls("FRO") is an annual journal with scientific articles from and about the Faroe Islands and Faroese issues. The journal spans all scientific fields with articles  in Faroese (mostly Humanities and Social Sciences) or English (Natural and Life Sciences). The books are from #gls("FROB"). #gls("FROB")  was established in 2005. It publishes works from all scientific fields in the Faroe Islands. Publications are in Faroese, English and Danish. For this study only the faroese publications have been used.

== Universal Dependencies <ud.sec>
#gls("UD") is a framework for cross-linguistic grammatical annotation designed to provide a consistent syntactic and morphological analysis across a wide variety of languages. It is based on a universal set of dependency relations and #gls("POS") tags, enabling multilingual parsing and linguistic comparison.
The UD framework represents syntactic structure using dependency trees, where words have labels that define their grammatical relationships. These annotations follow a principle of typological neutrality, ensuring that the framework remains applicable across languages with diverse syntactic structures.
The two faroese UD datasets used in this study are the @oft and @farpahc. Both datasets contain manually annotated sentences in Faroese. \ \
@oft is based on sentences from the Faroese Wikipedia. The whole Wikipedia was analysed using  @trond_tool. Sentences that contained unknown words were removed. The remaining sentences were manually annotated for Universal Dependencies and the morphology and #gls("POS") tags were converted deterministically using a lookup table. Errors in the original morphology and disambiguation were corrected where found.
The treebank contains a lot of copula sentences and very little first or second person, as can be expected from Wikipedia texts. \ \
@farpahc is a conversion of the @farpahc_og to the Universal Dependencies scheme using @ud_converter. @farpahc_og is a 53,000 word corpus which includes three texts from the 19th and 20th centuries. These texts were originally manually parsed according to the @ppche annotation scheme. Two of these parsed texts have been automatically converted to the Universal Dependencies scheme to create the 40,000 word @farpahc.

== Bendingar.fo <bendingar.sec>
Bendingar.fo is a website, that hosts #gls("BEND") @bend_grunn. #gls("BEND") contains inflections, lemmas and morphological data for faroese words and names. Most words are taken from wordlists that were made for #gls("RÆTT") @rætt, that were taken from a faroese dictionary @fo_ordabók. The names are from the name list from #gls("MAL") @bend_grunn.

== #gls("NLLB") <nllb.sec>
The faroese dataset consists of multiple types of data primary #gls("BITEXT"), mined #gls("BITEXT") and monolingual Text. For faroese, the datasets consist of primary @nllb_fo_1 and mined bitext @nllb_fo_2. The primary #gls("BITEXT") corpora are publicly available parallel corpora from a variety of sources. The mined #gls("BITEXT") corpora are retrieved by large-scale #gls("BITEXT") mining. The mined data includes all the English-centric directions and a subset of non-English-centric directions. Only the faroese data is used in this study. 

