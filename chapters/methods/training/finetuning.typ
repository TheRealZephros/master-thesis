#import "@preview/glossarium:0.5.1": gls, glspl
#import "../../../utils.typ": flex-caption, customRound

=== Fine-tuning
The fine-tuning was done using Ordbogens framework for fine-tuning #gls("MT5") models, which is based on the Hugging Face Transformers library. The parameters used for the fine-tuning were the following:
- *Learning rate*: $1e^(-05)$
- *Optimizer*: AdamW
- *Dropout*: 0
- *Batch size*: 16
- *Accumulation*: 8
- *Warm-up steps*: 10000
- *Max sequence length*: 128
- *Max generation length*: 256

The training objective was to correct the errors in the text and to predict the correct error type of each correction. This was done with a #gls("S2S") approach, where the input is the text with errors and the output is the corrected text followed by the error types of each correction.