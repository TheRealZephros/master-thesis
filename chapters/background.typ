#import "@preview/glossarium:0.5.1": gls, glspl


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

