# CLAUDE.md

## Project
Personal tracker app: Flutter, Android only, local SQLite (drift), no cloud.
The build checklist and decisions live in `docs/plan.html` (read it before starting a phase).

## Git workflow
- Never commit directly to `main`. Do every feature on its own branch (`feature/<short-name>`).
- When a feature is complete (`flutter analyze` clean and `flutter test` passing), merge it into `main`, then delete the feature branch.
- Steps: `git switch main && git merge --no-ff feature/<name> && git branch -d feature/<name>`.
- Only merge finished, verified work. Leave unfinished work on its branch.
- If the repo isn't initialised yet, `git init -b main` and make an initial commit on `main` first.

## Commands
- Generate drift code: `dart run build_runner build --delete-conflicting-outputs`
- Check: `flutter analyze` and `flutter test`
- Build: `flutter build apk --debug`

## Conventions
- State: `flutter_riverpod`. Routing: `go_router`. Database: `drift`.
- Feature-folder layout under `lib/features/<feature>/`; shared code in `lib/core/`.
- Keep pure logic (sleep duration, budget levels) in separate files so it is unit-testable.
- Money is stored as integer minor units (cents).
