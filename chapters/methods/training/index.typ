#import "@preview/glossarium:0.5.1": gls, glspl
#import "../../../utils.typ": flex-caption, customRound

== Training <methods.training.sec>
This section describes the training process for the models used in this project. It includes details on the pretraining and fine-tuning of the mT5 model and the training of the spaCy pipeline components. All the #gls("MT5") models were trained on RTX A6000 GPUs with 48GB of memory, and the spaCy models were trained on a single GTX 2080 ti. // TODO double check the GPUS



#include "pretraining.typ"
#include "finetuning.typ"
#include "spacy.typ"