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
The unlabeled data was cleaned using a mix of heuristics. To remove a lot of the foreign sentences, a blacklist of foreign characters was used to filter out sentences that contained these characters. Additionally a list of common danish and english words were used to remove foreign sentences. To get rid of some metadata, words and abbreviations like *img src*, *aspx*, *pid*, *newsid*, *html*, *date* were used to remove the sentences they occur in. Due to encoding errors in the data, a lot of the data was wrongly converted to ascii, but a lot of it could be reverse engineered by manually inspecting the data, and from context, get a mapping from the wrong encoding to the correct faroese character. For example the character *ð* was written as *Ã°* and the character *á* was written as *Ã¡* and so on. The *ð* character is also sometimes written as *đ*, so to make the dataset more uniform, it is converted to *ð*, which is the only one of them that can be written with a faroese keyboard without modifiers. The data was also cleaned by removing any html tags, and any other non-faroese characters. Some of the data has really long sentences, some of them up to 800.000 characters long, so they were split on the period character, excluding periods from abbreviations. All duplicate sentences were removed from the dataset. The dataset was shuffled to make sure the model doesn't overfit on the order of the data.
The unlabeled dataset was saved as jsonl for pretraining of the mt5 model and as a txt file for further processing. Before initiating the corruption process, the input text is annotated with #gls("POS") and #gls("MORPH") tags using a SpaCy pipeline. The annotated text is stored in a #gls("DOC") object, which is subsequently encapsulated within a #gls("DOCB") container, serialized, and written to disk. By doing this before the corruption process, new errors can be added without having to annotate the text again, which ends up saving a lot of time. \ \ 

==== #gls("UD") Data <ud_data.sec>
The labeled data from the Faroese #gls("UD") repositories required minimal preprocessing. All annotated sentences were collected into a single #gls("JSON") file to facilitate easier inspection and further processing. Duplicate sentences were then removed from the dataset. This #gls("JSON") file was subsequently converted into the spaCy training format, a binary format consisting of a list of documents, where each document includes one or more labeled sentences. The dataset was then split into training and validation sets, using a 95/5 split.

==== Testset from #gls("MTD") <test_set.sec>
The original corpus is in xml format where each sentence is a separate xml tag and each word and punctuation is a tag in the sentence. If a word or punctuation is corrected, a revision tag replaces the error and contains the original and corrected text.
#errors_xml <private_corpus_xml>

For each error in a sentence a pair of incorrect and correct sentences are generated. The incorrect sentence contains the error and the correct sentence is the same as the incorrect sentence, but with the error corrected. @inc_corr_sentences shows the sentences that are generated from the sentence in @private_corpus_xml. \ \
#figure(
  caption: flex-caption(
    [Example of a sentence with an error and the corresponding correct sentence, Translation: "We went up the mountain tomorrow. We are going up the mountain tomorrow."],
    [Example of a sentence with an error and the corresponding correct sentence]
  ),
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
Since the original sentences were written by students, a single word would sometimes contain multiple errors, so by manually inspecting the data, the errors were split into multiple sentences once again. An example of this is the sentence "Teir ætlaðu sær til eina #errHighlight("ærda") bygd, men blivu næstan vilstir uppi á fjøllunum, tí mjørkin kom." Here the word "ærda" contains two spelling mistakes, the *æ* should be an *a* and the *d* should be an *ð*.
Another effect from the original sentences being written by students, is that they somtimes write very long running sentences, so the sentences were cut off in a way that preserved the meaning of the sentence and the context of the error, but removes the redundant parts of the sentence. An example of this, is the sentence: \ \
Vit hoyra í byrjanini í stuttsøguni, at Maria vaknar, og tað fyrsta, hon hugsar, er: "Hvar er telefonin?" #errHighlight("og") so brúkar hon heilar 36 min. á telefonini, áðrenn hon vakir mannin Súna og sigur: "Klokkan er farin av sjey, vit hava forsovið okkum, kom upp!" \ \
The error here is that *og* should be capitalized because of the preceding *?*, so it can be reduced to: \ \
Tað fyrsta, hon hugsar, er: "Hvar er telefonin?" #errHighlight("og") so brúkar hon heilar 36 min. á telefonini. \ \
This is done to make the sentences more concise and reduce the noise that comes from having overly long sentences.

=== Data Augmentation <data_augmentation.sec>
The data is augmented by taking correct text and corrupting it. Using a set of rules, the text is corrupted by changing words, adding or removing words, and changing the order of words. The goal of this process is to create a more diverse dataset that can help the model learn to generalize better. The corruption process is done in a way that preserves the meaning of the text, but introduces errors that are similar to those that might be made by a human writer.

==== Corruption Process <corruption_process.sec>
The first stage of the corruption process involves generating a #gls("JSON") file that enumerates all possible corruption types. Prior to applying these corruptions, a separate distribution file, also in #gls("JSON") format, is used to define the desired frequency of each error type within the dataset. This distribution file is then used to guide the application of corruptions to the text. Finally, the resulting corrupted dataset is shuffled to prevent the model from overfitting to any particular sequence or pattern in the data.
