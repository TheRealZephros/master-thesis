#import "@preview/glossarium:0.5.1": gls, glspl
#import "keyboard_typo.typ": keyboard_typo
#import "../../utils.typ": flex-caption, customRound


= Scientific Background <background.sec>
This chapter provides an overview of the background information necessary to understand the context of the study. It covers the key concepts and relevant research that have shaped the current state of the field.


== Transformers <background.transformers.sec>
Transformers are a class of deep learning models introduced by @Vaswani2017 that revolutionized #gls("NLP") and other sequential data tasks. Unlike #gls("RNN") and #gls("LSTM"), which process input sequentially, transformers leverage a self-attention mechanism that allows for parallelization and long-range dependency modeling. At the core of the transformer architecture is the self-attention mechanism, which enables the model to weigh the importance of different words in a sequence, regardless of their position. This is complemented by positional encodings, which provide information about word order, addressing the lack of inherent sequentiality in self-attention. The transformer is composed of stacked encoder and decoder layers, each containing multi-head self-attention and feedforward layers with residual connections and layer normalization. Self-attention will be covered in more detail in @background.self_attention.sec. \
Transformers have been the foundation for #gls("SOTA") #gls("NLP") models, including #gls("BERT"), #gls("MT5") and perhaps the best known transformer to the general public, #gls("GPT"). These architectures have been widely applied in text generation, translation, and classification tasks, as well as in domains such as computer vision, protein structure prediction, and reinforcement learning. The scalability and effectiveness of transformers have driven their adoption across various fields, making them a cornerstone of modern deep learning research. \ \
The original Transformer architecture proposed by @Vaswani2017 is built around an encoder-decoder structure: the encoder processes the input sequence, while the decoder generates the output. Both the encoder and decoder are composed of stacks of identical layers, six in the original model.
Each encoder layer consists of two main components: a multi-head self-attention mechanism and a #gls("FFN"), each followed by a residual connection and layer normalization. Before entering the encoder, input tokens are passed through an embedding layer and enriched with positional encodings to inject information about the sequence order.
Each decoder layer includes three subcomponents: a masked multi-head self-attention layer, to prevent attending to future tokens, a multi-head attention mechanism over the encoder outputs, and a #gls("FFN"). Like the encoder, each of these sublayers is followed by a residual connection and layer normalization.
A visual overview of this architecture is provided in the diagram at @og_transformer. \ 
#figure(
  caption: flex-caption(
  [The original transformer from "Attention Is All You Need". @Vaswani2017],
  [The original transformer from "Attention Is All You Need".]
  ),
  image("../../images/og-transformer-architecture.png", width: 60%, height: auto)
) <og_transformer>

=== Self-attention <background.self_attention.sec>
Self-attention is a mechanism that allows a model to weigh the importance of different words in a sequence when making predictions. It computes a weighted sum of the input representations, where the weights are determined by the similarity between the words. This enables the model to capture long-range dependencies and relationships between words, regardless of their position in the sequence. Self-attention is a key component of transformer architectures, enabling them to process sequences in parallel and learn contextual representations effectively.
Self-attention is a sequence to sequence process that takes sequence of vectors as input, these can be called $x_1,x_2...,x_t$, and outputs a sequence of vectors $y_1,y_2...,y_t$. The dimentionality of the input and output vectors is the same. To produce the output vector $y_i$, the self-attention operation computes a weighted sum of the input vectors, where the weights are determined by the similarity between the input vectors. The self-attention operation can be expressed mathematically as follows:
$ y_i = sum_(j) w_(i j)x_j $

Where j indexes over the input vectors, and the weights sum up to 1. $w_(i j)$ is a computed value, and not a parameter. The weights are computed using a similarity function, which measures the similarity between the input vectors. The most common similarity function used in self-attention is the dot product. which is computed as follows:
$ w'_(i j) = x_i^#sym.tack.b x_j $

The dot product gives a result that is in the range [$-infinity,infinity$]. So to normalize the weight, a softmax functioon is applied to the weights, which transforms the weights into a probability distribution. The softmax function is defined as follows:
$ w_(i j) = frac(exp w'_(i j), sum_j exp w'_(i j)) $

That is the basic self-attention operation, but it is not the only one. On @self_attention is an illustration of the self-attention mechanism. \
// TODO do a better job of crediting the image
#figure(
  caption: flex-caption(
    [Self-attention mechanism illustrated. Not including the softmax operation. Credit to #link("https://peterbloem.nl/blog/transformers")[Peter Bloem]],
    [Self-attention mechanism]
  ),
  image("../../images/self-attention.png", width: 80%, height: auto)
) <self_attention>

Modern transformers use a more complex version of self-attention. The input vector $x_i$ is used in 3 different ways it's compared to every other input vector to computeits own output $y_i$. It's also compared to every other input vector to compute the output of every other input vector $y_j$. And lastly it is also used as a part of the weighted sum to compute the output of each output vector, once the weights have been computed. These roles are called *query*, *key*, and *value*. 
To compute the query, key, and value vectors for a given input vector $x_i$, three separate linear transformations are applied using learned weight matrices $W_q$, $W_k$, $W_v$, each of size $k times k$. These matrices project the input into three different representations:
$ q_i = W_q x_i space.quad k_i = W_k x_i space.quad v_i = W_v x_i $
$ w'_(i j) = q_i^#sym.tack.b k_j $
$ w_(i j) = "softmax("w'_(i j)")" $
$ y_i = sum_j w_(i j) v_j $

The softmax function is sensitive to the scale of its input values. To address this, a scaling factor of $sqrt(k)$, where $k$ is the dimensionality of the key vectors, is introduced. This scaling helps stabilize gradients and improves convergence during training. The scaled dot-product attention is defined as:
$ w'_(i j) = frac(q_i^#sym.tack.b k_j, sqrt(k)) $
The rationale behind this scaling is rooted in how vector magnitudes behave in high-dimensional spaces. For example, a vector in $RR^k$ where every element is $c$ has a Euclidean length of $c sqrt(k)$ As a result, dot products tend to grow with $k$, potentially producing large values that cause the softmax to become sharply peaked, making it overly confident in just a few positions. Dividing by $sqrt(k)$ normalizes this effect, keeping the scale of the dot products consistent across different dimensions.

Another important aspect of self-attention is the use of multiple attention heads. Instead of computing a single set of attention weights, multiple sets are computed in parallel, each with its own learned weight matrices. This allows the model to capture different types of relationships and dependencies in the data. The way this is done is by splitting the input vector into $h$ different parts, where $h$ is the number of attention heads. Each part is then used to compute a separate set of query, key, and value vectors. The outputs from all attention heads are concatenated and passed through a final linear transformation to produce the final output. This multi-head attention mechanism allows the model to learn richer representations by attending to different parts of the input sequence simultaneously.
The multi-head attention mechanism can be expressed mathematically as follows: \
If you have:
- An input matrix $X in RR^(n times d_("model"))$, where $n$ is the number of tokens and $d_("model")$ is the dimension of each token vector.
- $h$ attention heads.
For each attention head $r$: \
+ Project the input into the query, key, and value vectors using separate learned weight matrices: \
  $ Q = X W_(q)^(r) space.quad K = X W_(k)^(r) space.quad V = X W_(v)^(r) $
  where $W_(q)^(r) "," W_(k)^(r) "," W_(v)^(r) in RR^(d_k times d_("model"))$ (often $d_k = d_("model")/h$). \ \
+ compute the scaled dot-product attention for each head: \
  $ "Attention"^(r) = "softmax"(frac(Q K^#sym.tack.b,sqrt(d_k) ) ) V $ \
+ Concatinate the outputs of all heads: \
  $ "Concat"("head"_1,..., "head"_h) $ \
+ Pass the result through a final linear projection: \
  $ "MultiHead"(Q,K,V) = "Concatinate"("head"_1,..., "head"_h) W_o $ 
  where $W_o$ is the Final projection matrix that maps concatenated head outputs back to $d_"model"$


=== #gls("T5") <background.t5.sec>
Building on the foundation laid by the original Transformer architecture introduced in “Attention Is All You Need”, the #gls("T5") model proposed by @Raffel2019 marks a major advancement in the unification and simplification of natural language processing tasks. It introduces a flexible and scalable framework that reframes all NLP problems within a single, consistent text-to-text format. In this setup, both inputs and outputs are treated as strings, regardless of the task. For instance, translation is approached as: \
"translate English to German: That is good #sym.arrow.r Das ist gut" \
This unified formulation eliminates the need for task-specific heads or output formats, streamlining architecture design and enabling more effective multitask and transfer learning.\
Beyond its task framing, #gls("T5") incorporates several architectural innovations. To improve generalization on sequences of varying length, it replaces absolute positional embeddings with relative positional bias, allowing the model to focus on the relative distances between tokens rather than fixed positions. In terms of normalization, it departs from the post-layer norm approach used in the original Transformer, opting instead for pre-layer normalization, which applies layer norm before the attention and feed-forward sub-layers—an adjustment that enhances training stability, especially in deeper variants. \
Dropout on attention weights, commonly used in earlier models, is also disabled here, as it was shown to negatively impact performance during large-scale pretraining. In the feed-forward layers, the standard #gls("RELU") activation is replaced with #gls("GELU"), offering smoother gradients and better performance in deeper networks. \
For tokenization, the model leverages a byte-level SentencePiece tokenizer, which avoids the issue of unknown tokens and supports improved handling of multilingual and non-standard text by operating directly on raw byte sequences. \
When it comes to pretraining, #gls("T5") introduces a distinct span-corruption objective. Unlike #gls("BERT")'s masked token prediction or #gls("GPT")'s autoregressive formulation, this approach involves masking out random spans of text and replacing them with sentinel tokens (e.g., \<extra_id_0\>), tasking the model with reconstructing the missing spans. This span-level corruption helps the model develop stronger contextual understanding and more flexible generative capabilities. \
Finally, the model family was released in multiple scales from #gls("T5")-Small to #gls("T5")-XXL and trained on the #gls("C4") dataset. Its design emphasizes scalability, demonstrating that performance improves predictably with increased model and data size, making it a cornerstone example of scaling laws in NLP.


=== #gls("MT5") <background.mt5.sec>
Building on the architecture and pretraining paradigm established by #gls("T5"), the #gls("MT5") model by @MT5 extends these principles to the multilingual domain. While it retains the same encoder-decoder structure and leverages the same self-attention mechanisms, mT5 is specifically designed to operate effectively across a wide range of languages. This shift from a monolingual to a multilingual setting introduces several key modifications aimed at improving cross-lingual generalization and reducing English-centric bias. By training from scratch on a large, diverse multilingual corpus and refining its tokenization and training strategies, #gls("MT5") adapts the #gls("T5") framework to meet the challenges of truly global #gls("NLP"). \
Instead of #gls("T5")'s original subword tokenizer, this model employs a SentencePiece unigram tokenizer trained on multilingual data spanning 101 languages. This change improves its ability to process non-English scripts more effectively.
Unlike #gls("T5"), which excludes padding tokens from loss computation, this approach calculates gradients over the entire sequence, including padding. This contributes to greater robustness across diverse languages.
Rather than building on an English-only pretrained model, it is trained from the ground up on the multilingual #gls("MC4") corpus. This avoids English-centric bias and enhances performance across a wide range of languages.
The model does not rely on language tags or specialized embeddings to indicate the input language. It learns to process text based solely on content, fostering more language-independent representations. While the underlying encoder-decoder and self-attention mechanisms mirror those of #gls("T5"), these targeted adjustments significantly improve its effectiveness in multilingual contexts.


== Evaluation Metrics <background.evaluation.sec>
This study uses the evaluation metrics *precision*, *recall*, *accuracy*, and the $upright(bold(F))_beta$ score. These are commonly applied in #gls("NLP") tasks to assess a model's ability to correctly identify relevant instances. Each prediction falls into one of four categories: #gls("TP"), #gls("FP"), #gls("TN"), and #gls("FN"). These values are used to compute the evaluation metrics. \ \
The intuition behind each metric is as follows: \
*Precision* When the model predicts a positive, how often is it correct? \
*Recall* When a positive instance exists, how often does the model correctly identify it? \
*Accuracy* The overall rate of correct predictions, considering both positive and negative classes. \
$upright(bold(F))_beta$ A single score that balances precision and recall. The weighting depends on the value of $beta$: \
$bold(beta) = 1$ precision and recall are weighted equally ($upright(bold(F))_1$ score). \
$bold(beta) < 1$ precision is weighted more heavily. \
$bold(beta) > 1$ recall is weighted more heavily.\ \
The formulae for the metrics are:
$
bold("Precision") = frac( gls("TP"), gls("TP") + gls("FP") )
$
$
bold("Recall") = frac( gls("TP"), gls("TP") + gls("FN") )
$
$
bold("Accuracy") = frac( #gls("TP") + gls("TN"), #[Total Predictions] ) = frac( gls("TP") + gls("TN"), gls("TP") + gls("FP") + gls("TN") + gls("FN") )
$
$
bold(upright(F)_(beta)) = (1 + beta^2) * frac( #[Precision] * #[Recall], (beta^2 * #[Precision]) + #[Recall] )
$

In addition to these metrics, hit, correct, and incorrect rates are also used. These are defined as follows: \
*Hit rate* The percentage of instances where the model correctly identifies the correct error type. \
*Correct rate* The percentage of instances where model correctly identifies the error and corrected it. \
*incorrect rate* The percentage of instances where the model made a prediction but it was not correct. \
These rates provide additional insights into the model's performance, particularly in terms of its ability to correctly identify and correct errors. The hit rate is especially important in tasks like #gls("GEC"), where the model needs to not only identify the error type but also apply the correct correction. The correct rate is a measure of how well the model performs overall, while the incorrect rate highlights areas where the model needs improvement. \


== Cross-entropy Loss <background.cross_entropy.sec>
Cross-entropy loss is one of the most used loss functions in #gls("NLP") tasks, especially in tasks such as #gls("POS") tagging, dependency parsing and #gls("GEC"). It measures the difference in two probability distributions: the #gls("GT") and the distribution predicted by the model. Formally, cross-entropy loss is defined as:
$ L = -sum y_i log(hat(y)_i) $ 
 The #gls("GT") is often represented as a one-hot encoded vector, this means that a vector of size $n$ is created, where $n$ is the number of classes or categories, and one element in the vector is set to be "hot", i.e., it is set to 1, while all the other elements are "cold", i.e., set to 0. So the cross-entropy loss can be simplified to:
 $ L = -log(hat(y)_k) $
Where $k$ is the index of the "hot" or correct element in the #gls("GT") vector. This formula penalizes the model more heavily for being confident in an incorrect prediction, as it will result in a lower probability for the correct class, leading to a higher loss, and it also encourages the model to be more confident in its correct predictions. \ 
In the context of sequence tagging and #gls("S2S") tasks—such as #gls("GEC"), cross-entropy loss is typically computed at each time step of the output sequence. The total loss is then the sum or average over all positions in the sequence. This makes cross-entropy especially suitable for token-level prediction tasks, where each token is assigned a categorical label, such as, a corrected word, a #gls("POS") tag, or an edit operation such as KEEP or REPLACE.
One of the key strengths of cross-entropy loss is its strong theoretical grounding in information theory. It measures the average number of bits needed to identify an event from a set of possibilities, given a predicted distribution. As such, minimizing cross-entropy is equivalent to maximizing the likelihood of the correct labels, which aligns naturally with the goal of most probabilistic classifiers and generative models. 
However, cross-entropy loss can be sensitive to class imbalance, which is often present in GEC datasets where most tokens are KEEP. To address this, some systems introduce weighting schemes or use label smoothing, a technique that prevents the model from becoming overconfident by softening the target distribution.
While cross-entropy loss is a widely used objective function for classification tasks, it is known to exhibit sensitivity to class imbalance. This issue becomes particularly pronounced in #gls("GEC"), where the distribution of labels is typically skewed. Most tokens are correct and thus labeled as KEEP, while comparatively few require insertion, deletion, or substitution. This imbalance can lead the model to be biased toward the majority class, reducing its sensitivity to actual errors.
To mitigate this issue, researchers have proposed modifying the loss function to account for the unequal distribution of labels. For instance, @Phan2020 show that cross-entropy loss, when applied in the context of object detection, underperforms for underrepresented classes due to its uniform treatment of class frequencies. They explore weighted variants such as Balanced Cross-Entropy and Focal Loss, which can be adapted to sequence tagging tasks like #gls("GEC") to emphasize the minority classes and enhance model robustness under imbalance.
Another challenge associated with cross-entropy loss is its tendency to make models overconfident in their predictions. This is particularly problematic in low-resource settings, where training data is limited and the model may overfit. A widely adopted solution is label smoothing, a regularization technique that softens the target probability distribution. Instead of assigning a probability of 1.0 to the correct label and 0.0 to all others, label smoothing assigns a slightly lower probability, such as 0.9, to the correct label and distributes the remainder uniformly across the others. This prevents the model from becoming overly confident and helps improve generalization.
@guo2024 provide both empirical and theoretical evidence for the effectiveness of label smoothing as a regularization method. Their work connects label smoothing with the Neural Collapse phenomenon and demonstrates that it accelerates convergence and improves model calibration in deep learning settings, supporting its relevance even in tasks beyond standard classification.

== Grammar Error Correction 
#gls("GEC") is the task of automatically detecting and correcting grammatical errors in written text. It is typically treated as a form of text-to-text transformation, where the goal is to convert grammatically incorrect input into a corrected version that adheres to the norms of the target language @Ng2014 @Bryant2017. #gls("GEC") systems are designed to address a wide range of error types, including but not limited to: \
- Morphological errors (e.g., incorrect verb conjugation or noun inflection)
- Syntactic errors (e.g., subject-verb disagreement, word order issues)
- Orthographic and spelling errors
- Punctuation errors
- Lexical choice errors \ 
The task was initially motivated by applications in second language learning and writing assistance @Leacock2014, but has since become relevant for broader NLP tasks, such as preprocessing noisy text in user-generated content or learner corpora for use in machine translation, summarization, and other downstream models.
Approaches to #gls("GEC") have evolved from rule-based @Chodorow2010 @Rozovskaya2010 and statistical methods @Brockett2006 to neural network-based models, especially those based on the Transformer architecture @Vaswani2017. In many modern systems, #gls("GEC") is framed as either a #gls("S2S") problem—similar to machine translation @Grundkiewicz2019 @Lichtarge2019, or as an edit-based classification task, where the model predicts a sequence of edits to transform the input into a correct output. The latter approach, exemplified by #gls("GECTOR") @Omelianchuk2020, has gained popularity due to its efficiency and strong performance on limited data.
The performance of #gls("GEC") systems depends heavily on the availability of annotated corpora such as #gls("NUCLE") @Dahlmeier2013 or Lang-8 @Mizumoto2011 , which are largely limited to high-resource languages like English. This poses a significant barrier for low- and ultra-low-resource languages, where high-quality error-annotated corpora are rare or nonexistent. To address this, researchers have explored cross-lingual transfer @Yamashita2020, data augmentation using synthetic errors @Xie2018, and multilingual pre-trained models like mBART @Liu2020 and #gls("MT5") @mt5.
For this study , the focus is on an edit-based approach to #gls("GEC"). This approach turns #gls("GEC") into a sequence tagging task.

=== Sequence Tagging <background.seq_tag.sec>
Sequence tagging is a common approach in #gls("NLP") tasks, where the goal is to assign labels to each element in a sequence. This can be applied to various tasks, such as part-of-speech tagging, named entity recognition, and grammatical error correction. In the context of #gls("GEC"), sequence tagging involves predicting a sequence of edits that transform the input into a grammatically correct output. This approach allows for efficient processing and can leverage existing pre-trained models to improve performance on low-resource languages.
Instead of rewriting the entire sentence, the model tags each token or span of tokens with a label. The labels will often fall into one of the following categories: \
- *$"KEEP"$*: The token is correct and should be kept as is. \
- *$"DELETE"$*: The token is incorrect and should be removed. \
- *$"REPLACE"_("token")$*: A token should be replaced with a the specified token. \
- *$"APPEND"_("token")$*: The specified token should be appended after this position. \

These edit tags are typically learned through supervised training on annotated datasets, where each token in an erroneous sentence is aligned with its corresponding edit in the corrected sentence. Models like #gls("GECTOR") take this approach, using a transformer-based architecture fine-tuned on grammatical error correction tasks. By treating GEC as a sequence tagging problem rather than a generation problem, these models can be both more efficient and more interpretable.
One major advantage of this approach is its ability to produce high-quality corrections with relatively small amounts of data, making it particularly well-suited for ultra-low-resource languages like Faroese. Additionally, the tagging process ensures a strong alignment with the original sentence, which helps preserve the writer's intent and style.
This is especially important in applications like writing assistance, where maintaining the original meaning while correcting errors is crucial.
The downside of this approach is that more complex errors, that require multiple edits or reordering of tokens, may be harder to capture. This means that problems like rephrasing or restructuring sentences may not be as effectively handled by a sequence tagging model. \

==== Part of Speech Tagging & Morphological Analysis <background.pos.sec>
#gls("POS") tagging and morphological tagging are foundational tasks in #gls("NLP"), providing structured linguistic annotations that support downstream applications such as syntactic parsing, named entity recognition, and grammatical error correction. For morphologically rich and ultra-low-resource languages like Faroese, accurate tagging is especially important, as key grammatical information is often expressed morphologically rather than through fixed word order @Nivre2020.
#gls("POS") tagging assigns each token in a sentence a label that indicates its syntactic category, such as NOUN, VERB, or ADJ. These categories define the functional role of the word in a sentence and are typically drawn from a tagset such as the Universal #gls("POS") tagset used in the #gls("UD") project @Petrov2012. These standardized tags help ensure consistency across languages, enabling cross-linguistic comparison and model transfer.
Morphological tagging provides a more fine-grained analysis by assigning grammatical features to tokens, including number, gender, case, tense, mood, definiteness, and others. Each token may receive multiple morphological labels, forming a detailed grammatical profile. Unlike #gls("POS") tagging, morphological tagging is thus a multi-label classification task, where each token may carry a set of attribute-value pairs, such as Tense=Past, Number=Plur, or Case=Acc @Silveira2014.
Both #gls("POS") and morphological tagging are commonly treated as sequence labeling problems. Given a sequence of words, the model must predict a sequence of corresponding labels. Neural approaches dominate current systems, using architectures such as #gls("CNN")s, #gls("RNN")s, or transformers to build contextualized token representations. These representations are then passed to task-specific classifiers. In spaCy, the tagger component predicts #gls("POS") tags, while the morphologizer predicts morphological features using multi-label classification.
The morphologizer component in spaCy learns from structured annotations and attempts to predict multiple features independently, although joint feature modeling is also possible. Morphological predictions can be enhanced by dictionaries, rule-based systems, or constraints derived from morphological paradigms @Tsarfaty2010.
In low-resource settings, where annotated corpora are scarce, transfer learning, cross-lingual projection, and data augmentation techniques have proven useful. Pretrained multilingual models, such as #gls("MBERT") or #gls("XLMR"), can transfer knowledge across languages with shared syntactic or morphological properties @Conneau2020. Additionally, rule-based systems or lookup tables, such as those derived from Wiktionary or finite-state transducers, can be used to bootstrap annotations or support training in the absence of large datasets.

=== Sequence-To-Sequence Grammatical Error Correction <background.seq2seq.sec>
#gls("S2S") models are a widely adopted approach in #gls("GEC"), offering an end-to-end architecture that transforms gramatically incorrect input text into grammatically correct output. These models, inspired by machine translation, use an encoder-decoder framework to learn how to map error-prone text to its corrected form, often incorporating attention mechanisms or transformer architectures to enhance performance.
The encoder processes the input sentence and encodes it into a latent representation, which the decoder then uses to generate a corrected sentence token by token. This design enables #gls("S2S") models to capture a broad range of grammatical corrections, including insertions, deletions, substitutions, and reordering.
Early work in this area, such as by @Yuan2016, showed that neural machine translation methods could be effectively adapted for grammatical error correction. The transition to attention-based and transformer-based models led to substantial improvements. For example, @Junczys-Dowmunt demonstrated that grammatical error correction could be framed as a low-resource translation task and achieved competitive results using the MarianNMT framework.
Pre-trained transformer models such as #gls("BERT"), #gls("T5"), and #gls("MBART") have further pushed the field forward. @Kaneko2020 demonstrated that encoder-decoder models can learn syntactic structures relevant to #gls("GEC"), while @Lichtarge2019 proposed synthetic data generation techniques that significantly reduced the reliance on annotated corpora.
One of the strengths of #gls("S2S") models is their flexibility. They are not restricted to a fixed set of edit operations, enabling them to produce fluent and coherent corrections. However, this comes with potential drawbacks: such models may overcorrect, changing tokens unnecessarily, or introduce semantic divergence by prioritizing fluency over fidelity to the original meaning @Grundkiewicz2019.
Despite these challenges, #gls("S2S") models continue to be central in #gls("SOTA") #gls("GEC") systems, especially when combined with multilingual pre-training and synthetic error generation methods such as those proposed by @Xie2018 and @Liu2020.


=== Dependency Parsing <background.dep.sec>
Dependency parsing is a fundamental task in #gls("NLP") that involves analyzing the grammatical structure of a sentence by establishing relationships between "head" words and their dependents. This syntactic representation results in a dependency tree, where nodes correspond to individual words and directed edges define grammatical relationships. Dependency parsing is particularly well-suited for morphologically rich and free word-order languages, as it emphasizes relations between words rather than phrase boundaries@Nivre2015.
Dependency parsing differs from constituency parsing in that it models binary relationships directly between words, offering a more compact and often more linguistically intuitive structure. Each word in the sentence (except the root) is linked to another word, its syntactic head, forming a tree rooted at the main verb or clause head. This structure aligns closely with how language is processed in many downstream applications @Jurafsky2021.
Various algorithms have been developed for dependency parsing:
- *Transition-Based Parsers* incrementally build dependency trees using a series of actions (such as shift,   left-arc, and right-arc). These parsers are fast and suitable for real-time applications, but may be limited in handling non-projective dependencies @Honnibal2020.
- *Graph-Based Parsers* consider all possible trees and select the one with the highest score. These parsers are generally more accurate and capable of handling non-projective dependencies but are computationally more expensive @Mcdonald2005.
- *Neural Network-Based Parsers* represent the current #gls("SOTA"), employing #gls("RNN")s, attention mechanisms, or transformer architectures. For instance, Dozat and Manning's biaffine parser significantly improved performance across multiple treebanks by incorporating attention-based scoring of arcs and labels @Dozat2017.
Dependency parsing has wide-reaching applications in modern #gls("NLP") systems:
- *Machine Translation* Parsing improves the alignment and generation quality by providing syntactic structure information for reordering and disambiguation @Jurafsky2021.
- *Information Extraction* Relationships between entities such as subjects and objects can be directly identified using dependency links.
- *Question Answering* Parsing enhances understanding of question structure and improves answer extraction.
- *Sentiment Analysis* Dependency paths help determine which adjectives or modifiers apply to which entities.
- *Selective Grammatical Corruption* Dependency parsing can be used to identify specific grammatical structures and use them to identify cases where a grammatical error can be introduced.
The use case for a dependency parcer in this study is the last one. The dependency parser will help to identify certain grammatical structures, so that that can be used to make sure that the required context for an error is present. For example, verb tense disagreement errors can be introcuded by detecting the dependencies in the sentence. A sentence like "She walked into the room and saw the mess." can be used to introduce a verb tense disagreement error by changing the verb "walked" to "walks", resulting in "She walks into the room and saw the mess." and to make this error, it is important to be sure that such a dependency structure is present, if a the tense in the sentence "She said that she was tired." is changed, it just changes the meaning slightly, but the sentence is still grammatically correct, so without a dependency parser, it is difficult to identify the correct cases to corrupt. 

== Spelling <bg_spelling.sec>
There are 2 categories of spelling errors, the first is a typographical error, the second is a cognitive error. Typographical errors are made my mistyping a word, while cognitive errors are made by a lack of understanding. A spelling error in the context of this study is an error that results in a word that is not in the faroese dictionary.

=== Typographical Errors <bg_typo_errors.sec>
Typographical errors can be split into 4 subcategories: \
*Transposition* errors can be made by transposing two adjacent characters in a word. \
*Substitution* errors can be made by substituting a character in a word. \ 
*Insertion* errors can be made by inserting a character into a word. \
*Omission* errors can be made by omitting a character in a word. \ \
Omission errors are the simplest to make, since they only require removing a character from the original word.
Transposition errors are also very simple to make, since they only require permutation of the original word, by swapping a pair of adjacent characters. Substitution and Insertion errors require a bit more thought. If characters are picked completely at random, most errors would not be realistic typos and it would result in most generated spelling errors being redundant. For a letter like *G* only 6/29 typos would be useful and a letter like *Q* would only have 3/29 useful errors. To make the errors more realistic, each character that is substituted or inserted is picked from adjacent characters on the keyboard. For example replacing a *G* with an *H* is a probable typo to make when writing on a keyboard, since the h key is right next to the *G* key. The same goes for inserting a character, if a character is inserted, it is picked from the adjacent characters on the keyboard. The keyboard layout used is the faroese keyboard layout, which is a modified version of the danish keyboard layout. The only relevant difference between the two layouts is that the faroese keyboard layout has the *Ð* character to the right of *Å*. The other difference is in punctuations and modifiers.

#keyboard_typo <keyboard_typo>

=== Cognitive Errors <bg_cog_errors.sec>
Theses errors are a bit more difficult to categorize than typographical errors, as the reason for the error is not always clear. Most spelling errors are phonetic spelling errors, where a word is spelled as it sounds, this can have many different causes. The most common phonetic errors are errors with *ð*. In most cases it is a silent letter, which often leads to it being omitted. When *ð* is pronounced it is often pronounced as a *v* which leads to a spelling error where *v* is written in place of a *ð*. A type of spelling errors that is both phonetic and because of an exception to a rule, is a vowel followed by a double consonant is short, and a long vowel is followed by a single consonant. This rule has some exceptions like in the words *skula* and *fram*, the first *u* in skula and the *a* in fram are short, but the words are spelled with a single consonant, which causes people to spell them like *skulla* and *framm*.
Dialects will also often lead to phonetic spelling errors. The faroese language has many dialects, and some of them have different pronunciations of the same word. The northern dialect, such as the one in Klaksvík, pronounces *á* as *a*, which leads to spelling errors where *á* is written as *a*. And someone with a southern dialect, might pronounce *p* more softly than someone with a northern dialect, which leads to spelling errors where *p* is written as *b*. 
