#import "@preview/glossarium:0.5.1": gls, glspl
#import "keyboard_typo.typ": keyboard_typo



= Scientific Background <background.sec>
This section provides an overview of the background information necessary to understand the context of the study. It covers the key concepts and relevant research that have shaped the current state of the field.


== Transformers
Transformers are a class of deep learning models introduced by @Vaswani2017 that revolutionized #gls("NLP") and other sequential data tasks. Unlike #gls("RNN") and #gls("LSTM"), which process input sequentially, transformers leverage a self-attention mechanism that allows for parallelization and long-range dependency modeling.
At the core of the transformer architecture is the self-attention mechanism, which enables the model to weigh the importance of different words in a sequence, regardless of their position. This is complemented by positional encodings, which provide information about word order, addressing the lack of inherent sequentiality in self-attention. The transformer is composed of stacked encoder and decoder layers, each containing multi-head self-attention and feedforward layers with residual connections and layer normalization.
Transformers have been the foundation for state-of-the-art NLP models, including #gls("BERT"), #gls("MT5") and perhaps the best known transformer to the general public, #gls("GPT"). These architectures have been widely applied in text generation, translation, and classification tasks, as well as in domains such as computer vision, protein structure prediction, and reinforcement learning. The scalability and effectiveness of transformers have driven their adoption across various fields, making them a cornerstone of modern deep learning research.

=== Self-attention
@Vaswani2017

=== mT5
#gls("MT5") is a pre-trained language model developed by Google. It is based on the Transformer architecture and is designed for text-to-text transfer learning.

=== BERT
#gls("BERT") is a pre-trained language model developed by Google.


== Evaluation Metrics
This study uses the evaluation metrics *precision*, *recall*, *accuracy*, and the $upright(bold(F))_beta$ score. These are commonly applied in #gls("NLP") tasks to assess a model's ability to correctly identify relevant instances. Each prediction falls into one of four categories: #gls("TP"), #gls("FP"), #gls("TN"), and #gls("FN"). These values are used to compute the evaluation metrics. \ \
The intuition behind each metric is as follows: \
*Precision* — When the model predicts a positive, how often is it correct? \
*Recall* — When a positive instance exists, how often does the model correctly identify it? \
*Accuracy* — The overall rate of correct predictions, considering both positive and negative classes. \
$upright(bold(F))_beta$ — A single score that balances precision and recall. The weighting depends on the value of $beta$: \
$bold(beta) = 1$ precision and recall are weighted equally (F₁ score). \
$bold(beta) < 1$ precision is weighted more heavily. \
$bold(beta) > 1$ recall is weighted more heavily.\ \
The formulae for the metrics are:

$
#[Precision] = frac( gls("TP"), gls("TP") + gls("FP") )
$

$
#[Recall] = frac( gls("TP"), gls("TP") + gls("FN") )
$

$
#[Accuracy] = frac( #gls("TP") + gls("TN"), #[Total Predictions] ) = frac( gls("TP") + gls("TN"), gls("TP") + gls("FP") + gls("TN") + gls("FN") )
$

$
upright(F)_(beta) = (1 + beta^2) * frac( #[Precision] * #[Recall], (beta^2 * #[Precision]) + #[Recall] )
$

=== Grammar Correction


=== Spelling <bg_spelling.sec>
There are 2 categories of spelling errors, the first is a typographical error, the second is a cognitive error. Typographical errors are made my mistyping a word, while cognitive errors are made by a lack of understanding. A spelling error in the context of this study is an error that results in a word that is not in the faroese dictionary.

==== Typographical Errors <bg_typo_errors.sec>
Typographical errors can be split into 3 subcategories: \
*Transposition* errors can be made by transposing two adjacent characters in a word. \
*Substitution* errors can be made by substituting a character in a word. \ 
*Insertion* errors can be made by inserting a character into a word. \
*Omission* errors can be made by omitting a character in a word. \ \
Omission errors are the simplest to make, since they only require removing a character from the original word.
Transposition errors are also very simple to make, since they only require permutation of the original word, by swapping a pair of adjacent characters. Substitution and Insertion errors require a bit more thought. If characters are picked completely at random, most errors would not be realistic typos and it would result in most generated spelling errors being redundant. For a letter like *G* only 6/29 typos would be useful and a letter like *Q* would only have 3/29 useful errors. To make the errors more realistic, each character that is substituted or inserted is picked from adjacent characters on the keyboard. For example replacing a *G* with an *H* is a probable typo to make when writing on a keyboard, since the h key is right next to the *G* key. The same goes for inserting a character, if a character is inserted, it is picked from the adjacent characters on the keyboard. The keyboard layout used is the faroese keyboard layout, which is a modified version of the danish keyboard layout. The only relevant difference between the two layouts is that the faroese keyboard layout has the *Ð* character to the right of *Å*. The other difference is in punctuations and modifiers.

#keyboard_typo <keyboard_typo>

==== Cognitive Errors <bg_cog_errors.sec>
Theses errors are a bit more difficult to categorize than typographical errors, as the reason for the error is not always clear. Most spelling errors are phonetic spelling errors, where a word is spelled as it sounds, this can have many different causes. The most common phonetic errors are errors with *ð*. In most cases it is a silent letter, which often leads to it being omitted. When *ð* is pronounced it is often pronounced as a *v* which leads to a spelling error where *v* is written in place of a *ð*. A type of spelling errors that is both phonetic and because of an exception to a rule, is a vowel followed by a double consonant is short, and a long vowel is followed by a single consonant. This rule has some exceptions like in the words *skula* and *fram*, the first *u* in skula and the *a* in fram are short, but the words are spelled with a single consonant, which causes people to spell them like *skulla* and *framm*.
Dialects will also often lead to phonetic spelling errors. The faroese language has many dialects, and some of them have different pronunciations of the same word. The northern dialect, such as the one in Klaksvík, pronounces *á* as *a*, which leads to spelling errors where *á* is written as *a*. And someone with a southern dialect, might pronounce *p* more softly than someone with a northern dialect, which leads to spelling errors where *p* is written as *b*. 
