#import "@preview/glossarium:0.5.1": gls, glspl

= Materials <materials.sec>
This chapter describes the materials used in the study, including the datasets, tools, and resources that were essential for conducting the experiments and analyses. 

== spaCy <spacy.sec>
Spacy is an open-source software library for advanced #gls("NLP") in Python. It is designed specifically for production use and is widely used in industry. Spacy provides a wide range of features for processing text data, including tokenization, part-of-speech tagging, named entity recognition, and dependency parsing. It also includes pre-trained models for a variety of languages and domains, making it easy to get started with #gls("NLP") tasks. The relevant features of spaCy for this thesis are the #gls("POS") tagger and morphologizer and to a lesser degree the lemmatizer and dependency parsing capabilities.

== NanoT5 <nanot5.sec>
NanoT5 @nawrot 


== Language Resources From #gls("MTD") <mtd.sec>
#gls("MTD") Has released a number of resources for the Faroese language. A Github repository @fo_nlp_res contains a collection of datasets and models @mtd_res. \ \ 
A private corpus developed by Uni Johannesen was used as a testset to evaluate the performance of the grammar and spelling models. The corpus contains \~2700 sentences and consists of manually corrected and annotated essays from students. The essays were written in Faroese and contain a variety of errors, including spelling, grammar, and punctuation errors. The testset was originally developed for a thesis to evaluate a #gls("GPT")-4o model on how well it understands faroese grammar and correct errors. Additionally the data used in the study by @Næs on spelling errors in faroese students' essays, was also used in this study. A high quality corpus of faroese sentences, with x sentences was provided by #gls("MTD") for training. // TODO find out how big the corpus is.



== Faroe University Press Papers And Books <fro.sec>
#gls("FRO") has published a number of papers and books in the various fields. The file format of the papers and books is pdf, so some preprocessing is needed to get the text out of them. All publications can be found for free on their #link("https://ojs.setur.fo/index.php/index/index")[website]. The papers are from #gls("FRO"). #gls("FRO") is an annual journal with scientific articles from and about the Faroe Islands and Faroese issues. The journal spans all scientific fields with articles  in Faroese (mostly Humanities and Social Sciences) or English (Natural and Life Sciences). The books are from #gls("FROB"). #gls("FROB")  was established in 2005. It publishes works from all scientific fields in the Faroe Islands. Publications are in Faroese, English and Danish. For this study only the faroese publications have been used.

== Universal Dependencies <ud.sec>
The two Faroese #gls("UD") datasets used in this study are the @oft and @farpahc treebanks. Both datasets consist of manually annotated Faroese sentences. \ \
@oft is based on sentences from the Faroese Wikipedia. The entire Wikipedia was processed using @trond_tool, and sentences containing unknown words were removed. The remaining sentences were manually annotated for Universal Dependencies. Morphological and #gls("POS") tags were converted deterministically using a lookup table, and errors in the original morphology and disambiguation were corrected where found. As is typical for Wikipedia-based corpora, the dataset contains a high proportion of copular constructions and relatively few first- and second-person forms. Additionally, the quality of the original Wikipedia articles may vary, which can impact the consistency and reliability of the syntactic structures found in the data. \ \
@farpahc is a conversion of the @farpahc_og corpus to the Universal Dependencies scheme using @ud_converter. @farpahc_og is a 53,000-word corpus consisting of three texts from the 19th and 20th centuries, originally manually parsed according to the @ppche annotation scheme. Two of these parsed texts were automatically converted to the UD format, resulting in the 40,000-word @farpahc treebank. Due to the historical nature of the source material, the grammar and vocabulary may diverge significantly from contemporary Faroese, which could limit the dataset's applicability to modern language use. \ \
The files with #gls("POS") and #gls("MORPH") labels contain 6,652 Faroese sentences, totaling 9.3 MiB of data. The lemma-labeled files include 1,428 sentences (756 KiB), while the files annotated with dependency parser labels comprise 3,049 sentences, amounting to 2.8 MiB. \ \


== Bendingar.fo <bendingar.sec>
Bendingar.fo is a website, that hosts #gls("BEND") @bend_grunn. #gls("BEND") contains inflections, lemmas and morphological data for faroese words and names. Most words are taken from wordlists that were made for #gls("RÆTT") @rætt, that were taken from a faroese dictionary @fo_ordabók. The names are from the name list from #gls("MAL") @bend_grunn.

== #gls("NLLB") <nllb.sec>
The faroese dataset consists of multiple types of data primary #gls("BITEXT"), mined #gls("BITEXT") and monolingual Text. For faroese, the datasets consist of primary @nllb_fo_1 and mined bitext @nllb_fo_2. The primary #gls("BITEXT") corpora are publicly available parallel corpora from a variety of sources. The mined #gls("BITEXT") corpora are retrieved by large-scale #gls("BITEXT") mining. The mined data includes all the English-centric directions and a subset of non-English-centric directions. Only the faroese data is used in this study. 

