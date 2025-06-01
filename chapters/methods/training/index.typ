#import "@preview/glossarium:0.5.1": gls, glspl
#import "../../../utils.typ": flex-caption, customRound

== Training <methods.training.sec>
This section describes the training process for the models used in this project. It includes details on the pretraining and fine-tuning of the mT5 model and the training of the spaCy pipeline components. All the #gls("MT5") models were trained on Nvidia RTX A6000 GPUs with 48GB of memory, and the spaCy pipeline was trained on a single Nvidia Geforce RTX 2080 Ti with 11GB of memory.

#include "pretraining.typ"
#include "finetuning.typ"
#include "spacy.typ"