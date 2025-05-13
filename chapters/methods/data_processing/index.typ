#import "@preview/glossarium:0.5.1": gls, glspl
#import "../../../utils.typ": errHighlight, corrHighlight, flex-caption, customRound
#import "@preview/lovelace:0.2.0": pseudocode, no-number, ind, ded, algorithm, data
#import "errors_xml.typ": errors_xml
#import "inflexions.typ": inflexion_json
#import "lemmas.typ": lemmas
#import "corruption_process.typ": corruption_process


== Data Processing <DataProcessing.sec>
This chapter describes the data processing steps involved in preparing the data for training the models. The data processing pipeline includes data collection, cleaning, preprocessing, and augmentation. Each step is essential for ensuring the quality and integrity of the data used for training the models. The following sections provide a detailed overview of the data processing pipeline used in this study.

=== Data Collection <data_collection.sec>
All the training data was from various online repositories and websites.
The training data is comprised of Faroese text from various sources, including articles from wikipedia, news websites, and research papers, as well as social media posts, legal documents, posts from government institutions and books.
The data is available online and can be accessed through the respective websites.
The formats of the data vary depending on the source, and the data was collected in the form of text files, CSV, json, jsonl, html, xml and pdf, so some preprocessing is needed to get it in a uniform format.

=== Data Cleaning & Preprocessing <data_cleaning.sec>
The unlabeled data was cleaned using a mix of heuristics. To remove a lot of the foreign sentences, a blacklist of foreign characters was used to filter out sentences that contained these characters. Additionally a list of common danish and english words were used to remove foreign sentences. To get rid of some metadata, words and abbreviations like *img src*, *aspx*, *pid*, *newsid*, *html*, *date* were used to remove the sentences they occurr in. Due to encoding errors in the data, a lot of the data was wrongly converted to ascii, but a lot of it could be reverse engineered by manually inspecting the data, and from context, get a mapping from the wrong encoding to the correct faroese character. For example the character *ð* was written as *Ã°* and the character *á* was written as *Ã¡* and so on. The *ð* character is also sometimes written as *ᵭ* or *đ*, so to make the dataset more uniform, they are converted to *ð*, which is the only one of them that can be written with a faroese keyboard without modifiers. The data was also cleaned by removing any html tags, and any other non-faroese characters. Some of the data has really long sentences, some of them up to 800.000 characters long, so they were split on the period character, excluding periods from abbreviations. All duplicate sentences were removed from the dataset. The dataset was shuffled to make sure the model doesn't overfit on the order of the data.
The unlabeled dataset was saved as jsonl for pretraining of the mt5 model and as a txt file for further processing. The txt file was tokenized and saved as a doc in the spaCy format, by tokenizing the text, before corrupting it, a lot of time is saved in the corruption process. The corruption process will be covered in the data augmentation section.\ \

==== #gls("UD") Data <ud_data.sec>
The labeled data from the faroese #gls("UD") repositories required minimal processing, it was saved in a single json file for easier inspection. Then all duplicate sentences were removed from the dataset. The json file was the converted to the spaCy format, which is a binary format used to train spacy models. It consists of a list of docs, where each doc contains sentences that are labeled, depending on what model you train. In this case, there were a few different files, the majority of them only had #gls("POS") and morphologizer labels, but some of them also had dependency labels, and some of them had lemmatizer labels. The files with #gls("POS") and #gls("MORPH") labels, had 6652 labeled faroese sentences, which add up to 9.3 MiB of data. The files with lemma labels had 1428 sentences, which added up to 756 KiB of data. And lastly the files with dependency parser labels had 3049 sentences which added up to 2.8 MiB of data.
Each of the files was split into a training and a validation set, where 95% of the data was used for training and 5% was used for validation.
==== Private Corpus from #gls("MTD") <private_corpus.sec>
The original corpus is in xml format where each sentence is a separate xml tag and each word and punctuation is a tag in the sentence. If a word or punctuation is corrected, a revision tag replaces the error and contains the original and corrected text.
#errors_xml <private_corpus_xml>

For each error in a sentence a pair of incorrect and correct sentences are generated. The incorrect sentence contains the error and the correct sentence is the same as the incorrect sentence, but with the error corrected. #ref(<inc_corr_sentences>) shows the sentences that are generated from the sentence in #ref(<private_corpus_xml>). \ \
#figure(
  grid(
    columns: 1,
    gutter: 5pt,
    row-gutter: 10pt,
    grid.cell(
      text[Vit $vec(errHighlight("fóru"), corrHighlight("fara"))$ $vec( #errHighlight("niðaná"), corrHighlight("niðan á") )$ fjallið í morgin.],
    ),
    grid.cell(
      text[$arrow.b.filled$],
    ),
    grid.cell(
      text[Vit #errHighlight("fóru") niðan á fjallið í morgin. Vit #corrHighlight("fara") niðan á, fjallið í morgin.],
    ),
    grid.cell(
      text[Vit fara #errHighlight("niðaná") fjallið í morgin. Vit fara #corrHighlight("niðan á") fjallið í morgin.],
    ),
  )
) <inc_corr_sentences>

=== Data Augmentation <data_augmentation.sec>
The data is augmented by taking correct text and corrupting it. The corruption process is done by using a list of rules, that are applied to the correct sentence. The types of errors are ordered in a hierarchy, where a category can directly have errortypes or have subcategories. A subcategory has errors. The hierarchy is a way to organize the errors, so that the corruption process can be more precise where possible and in the cases where an error could belong to multiple error types, it is defined which error type has higher priority.

==== Corruption Process <corruption_process.sec>
Before the corruption process can begin, the text is tokenized and annotated with #gls("POS") and #gls("MORPH") tags and saved in a #gls("DOC"). The #gls("DOC") is then put in a #gls("DOCB") which is serialized and written to a file. The first step in the corruption is to generate a json file that contains every corruption that can be made. Before distributing the corruptions into a training set, a distribution file, which is a json file that specifies the proportion of each errortype to introduce into the dataset, is used. The json file is then loaded and the corruptions are applied, with the proportions specified in the distribution file, to the text. The corrupted dataset is then shuffled to make sure the model doesn't overfit on the order of the data.

#corruption_process


===== Grammar <corruption_grammar.sec>
A grammar error is an error that violates the rules of grammar. This means all the words in the sentence are spelled correctly, but the sentence is still grammatically incorrect. Generating grammar errors varies a lot in complexity, some are as simple as a missing comma, which just needs simple string matching and removing the comma. Others require multiple components, working together, to make. 

#inflexion_json <inflexion_data>
#lemmas <lemmas_data>

===== Spelling <corruption_spelling.sec>

