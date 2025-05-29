#import "@preview/glossarium:0.5.1": gls, glspl
#import "../../../utils.typ": flex-caption, customRound

=== Pre-training
The pre-training of the #gls("MT5") model was conducted using the Nano#gls("T5") framework @nawrot, a lightweight and flexible training infrastructure optimized for training #gls("T5")-based models at scale. The model was trained from scratch on Faroese using a span corruption objective, similar to that introduced in the original #gls("T5") model @T5, where spans of text are masked and the model is trained to generate the missing content. This objective allows the model to learn both syntactic and semantic representations in a self-supervised manner.\
Due to the lack of existing Faroese language models, the weights were randomly initialized. The training was carried out using the following hyperparameters:
- *Model*: #gls("MT5")-base
- *Precision*: bf16
- *Input length*: 512
- *Masked language modeling probability*: 0.15
- *mean noise span length*: 3.0
- *optimizer*: AdamW
- *learning rate schedule*: cosine decay
- *initial learning rate*: $1e^(-04)$
- *gradient clipping*: 1.0
- *warmup steps*: 1000
- *batch size*: 64
- *accumulation*: 4
- *total steps*: 81203

The training corpus consisted of approximately 5.2 million Faroese sentences, collected from various web and document sources. However, due to an oversight during preprocessing, duplicate sentences were not removed, which may have introduced mild data redundancy and impacted the model's exposure to diverse linguistic patterns. \
A 95/5 train/validation split was used, resulting in a validation set of roughly 270,000 sentences. The model was evaluated against this set at the end of training. In addition, a checkpoint was saved every 10,000 steps to allow for resumption or retrospective model analysis. \
This pre-training effort represents one of the first attempts to build a foundational language model specifically for Faroese, leveraging the generalization capacity of the #gls("T5") architecture in a low-resource setting.