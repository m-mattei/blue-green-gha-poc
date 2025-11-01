# Blue/Green GitHub Actions PoC

This repository contains a tiny Java HTTP app and scripts to simulate a blue/green deployment locally. It is a proof-of-concept for the GitHub Actions workflows in `.github/workflows/` which are intentionally simple and call these scripts to demonstrate the steps.

How it proves the requirements:
- Deploy a new version to BLUE: run `scripts/run-instances.sh` with `BLUE_VERSION` set.
- Shift traffic: use `scripts/shift_traffic.sh PCT TOTAL` to simulate an ALB routing PCT% to blue and the rest to green.
- Finalize: stop the green instance with `scripts/stop-instances.sh` after verifying traffic.
- Distinguish deployments: each instance returns a JSON with `color`, `version`, `instanceId`, and `timestamp`.

Try it locally:
1. Build and start instances:

```bash
./scripts/run-instances.sh
```

2. Send 30% traffic to BLUE (100 requests):

```bash
./scripts/shift_traffic.sh 30 100
```

3. Stop instances:

```bash
./scripts/stop-instances.sh
```

Full scripted demo sequence (multiple shifts + finalize)

Locally:

```bash
./scripts/demo_sequence.sh 10 30 60
```

This will:
- start both instances
- set initial BLUE traffic to 0%
- perform three shifts (10%, 30%, 60%) writing logs to `logs/demo_shift_*.log`
- finalize by stopping instances and write `logs/demo_sequence_summary.txt`

On GitHub Actions: run the `Demo Sequence (Simulated)` workflow and provide a comma-separated list for `percentages`.
