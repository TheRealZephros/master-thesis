#import "@preview/glossarium:0.5.1": gls, glspl

=== spaCy #gls("POS") Tagger and Morphologizer <spacy_pos.sec>
The #gls("POS") tagger and morphologizer were trained using a spaCy pipeline built around a transformer architecture, which served as a shared encoder for all downstream linguistic components. Specifically, the pipeline leveraged the #gls("MBERT")-cased model as a shared transformer backbone. This choice enabled the model to benefit from multilingual knowledge transfer while learning contextual embeddings adapted to Faroese through fine-tuning.
The training was carried out using the following hyperparameters:
- *Model*: #gls("MBERT")-cased
- *Optimizer*: AdamW
- *Weight decay*: 0.01
- *Gradient clipping*: 1.0
- *Initial learning rate*: $5e^{-05}$
- *Batch size*: 128
- *Accumulation*: 3
Due to the fixed-length limitations of #gls("BERT")-based models, input sequences longer than the model's maximum window size must be split into manageable chunks. In this configuration, strided spans were used to produce overlapping token windows. Each window covered 128 tokens, with a stride of 96—meaning that each new window started 96 tokens after the previous one. This overlap preserved context across chunks and mitigated edge effects that might reduce tagging accuracy near window boundaries.\
To aggregate the output of the transformer into a representation usable by downstream components, the pipeline employed a reduce_mean pooling strategy. This pooling method calculates the mean of all token embeddings in a given span, producing a single fixed-size vector that summarizes the semantic content of the span. \ 
The #gls("POS") tagger and morphologizer were trained jointly on top of the shared transformer encoder. Both components used the TransformerListener architecture to extract contextualized token features from the #gls("BERT") model. This setup enabled multi-task learning, where the transformer encoder was fine-tuned for multiple linguistic objectives simultaneously. This approach is especially beneficial in low-resource settings, as shared training can lead to improved generalization across tasks. \ 

Evaluation was performed every 200 training steps. To balance the evaluation between components, a weighted scoring system was used. Since the morphologizer includes two sub-components (#gls("POS") tags and morphological features), their weights were split evenly, resulting in the following evaluation weights:
- *Tag accuracy*: 0.5
- *POS accuracy*: 0.25
- *Morphology accuracy*: 0.25
Custom label sets were used for both the #gls("POS") tagger and the morphologizer. These labels were derived from the Faroese Universal Dependencies treebanks @farpahc @oft, ensuring alignment with standardized linguistic annotations.