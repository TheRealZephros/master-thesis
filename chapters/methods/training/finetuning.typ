#import "@preview/glossarium:0.5.1": gls, glspl
#import "../../../utils.typ": flex-caption, customRound

=== Fine-tuning
The fine-tuning process was conducted using Ordbogen's custom framework for training #gls("MT5") models, built on top of the Hugging Face Transformers library. This framework facilitated the integration of a sequence-to-sequence #gls("S2S") modeling approach, in which the model learns to generate corrected text from input sentences containing grammatical or spelling errors. \
The model was trained with the dual objective of both correcting errors in the input text and predicting the corresponding error types. This output format aligns with recent developments in explainable #gls("GEC") models, where corrections are annotated with specific categories for improved interpretability and evaluation. \ 
The following hyperparameters were used during fine-tuning:
- *Learning rate*: $1e^(-05)$
- *Optimizer*: AdamW
- *Dropout*: 0
- *Batch size*: 16
- *Accumulation*: 8
- *Warm-up steps*: 10000
- *Max sequence length*: 128
- *Max generation length*: 256

An example of the model's input-output format is shown in @finetuning.input_output:
#figure(
  caption: flex-caption(
    [Example of an input and output sentence. Translation: "We often forget to enjoy this beautiful time."],
    [Example of an input and output sentence]
  ),
  grid(
    columns: 1,
    gutter: 5pt,
    row-gutter: 10pt,
    grid.cell(
      text[Vit gloyma ofta at nýtur vøkru tíð.],
    ),
    grid.cell(
      text[$arrow.b.filled$],
    ),
    grid.cell(
      text[S Vit gloyma ofta at njóta hesa vøkru tíð. \$A 6 8|||1601|||njóta \$A 8 8|||1807|||hesa],
    ),
  )
) <finetuning.input_output>
In the example on @finetuning.input_output, the corrected sentence is annotated with error type identifiers. Here, *1601* corresponds to a *Verbs* error, and *1807* represents a *Subject - missing error*. This format not only guides the model in generating accurate corrections but also provides structured error annotations that can be evaluated independently or used in downstream applications, such as automated feedback tools for language learners.
By treating grammatical error correction as a conditional generation problem, this approach leverages the pre-trained capabilities of #gls("MT5") to adapt to Faroese.\ \
In order to monitor performance during training, the model was evaluated on a validation set at the end of each epoch. If the validation loss improved, a checkpoint of the model's weights was saved. This ensured that the best-performing model was always preserved, regardless of fluctuations in performance during subsequent epochs. In addition to these conditional checkpoints, complete model snapshots were saved every five epochs, regardless of validation loss. These periodic checkpoints were stored separately from the best-performing checkpoint to support retrospective analysis or to enable rollback to earlier stages of training if necessary. \ \
To safeguard against unexpected interruptions, the training framework was also configured to save a checkpoint in the event of a manual stop signal or system interruption. Furthermore, if an exception occurred during training—such as a CUDA out-of-memory error—a final “exit” checkpoint was saved automatically. This precaution allowed training to resume from the point of failure or to assist in debugging problematic behavior without losing significant training progress. \
This evaluation and checkpointing strategy contributed to the robustness of the fine-tuning process, providing multiple recovery options while also ensuring consistent tracking of the model's best performance.
