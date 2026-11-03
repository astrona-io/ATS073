# Quizzes

Each section has `sections/section-0X0/quiz.yaml`, registered in `astrona.yaml` as a
`type: quiz` entry with `pass_score: 70` after the capstone lab of the section. The last
entry of the course is `sections/final-domain-quiz.yaml`. The older `assessments/` folder is
retired and can be deleted.

Every file uses the question-bank format, schema version 1:

- `id`: stable bank or question identity; keep it when editing wording.
- `scope`: the section or the domain.
- `learning_objective`: the measurable outcome the question checks.
- `source_readings`: author traceability to the teaching part; not learner navigation.
- `prompt`: the question text.
- `options`: stable option IDs, answer text and per-option feedback.
- `correct_option`: the ID of the single correct option.
- `explanation`: feedback that reinforces the supported answer.

Questions are original single-choice items and start as `status: draft`. The files contain
answer keys and are public learning material, so they are not a secure examination bank.
Scores are not an official OTCA result.
