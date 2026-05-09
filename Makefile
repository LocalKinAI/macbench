# macbench — Makefile.
#
# Configurable via env vars on the make command line:
#   AGENT       Path to your agent binary
#   AGENT_ARGS  Argument template (must contain "{prompt}")
#   TASKS       Comma-separated subset (e.g. 001,005,016)
#   TIMEOUT     Per-task timeout (e.g. 90s, 2m)
#   SKIP_WARMUP=1   Skip the warmup pre-step (useful for tight rerun loops)
#
# Examples:
#   make bench AGENT=./kinclaw AGENT_ARGS='-soul pilot.soul.md -exec {prompt}'
#   make bench AGENT=./agent.sh AGENT_ARGS='{prompt}' TASKS=001,005
#   make bench SKIP_WARMUP=1 ...   # second-pass run without re-resetting state

.PHONY: help build bench bench-record bench-fast warmup test clean

AGENT       ?=
AGENT_ARGS  ?= {prompt}

# Forward optional knobs to the runner only when set.
ARGS = $(if $(TASKS),-tasks $(TASKS)) $(if $(TIMEOUT),-timeout $(TIMEOUT))

help:                    ## Show this help
	@printf "\033[1mmacbench targets\033[0m\n\n"
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) \
	  | awk -F':.*?## ' '{printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'
	@printf "\nRequired env: AGENT (path to agent), AGENT_ARGS (must contain {prompt})\n"

build:                   ## Compile the runner (catches typos before a benchmark run)
	go build -o /dev/null .

bench: build             ## Reset env (warmup) + run all tasks against AGENT
	@if [ -z "$(AGENT)" ]; then \
	  echo "✗ AGENT is required, e.g. make bench AGENT=./kinclaw AGENT_ARGS='-exec {prompt}'"; \
	  exit 2; \
	fi
	@if [ -z "$$SKIP_WARMUP" ]; then \
	  echo "→ warming up (SKIP_WARMUP=1 to skip)…"; \
	  ./warmup.sh; \
	  echo ""; \
	  echo "→ starting bench…"; \
	fi
	go run . -agent "$(AGENT)" -agent-args "$(AGENT_ARGS)" $(ARGS)

bench-fast: build        ## bench without the warmup step (rerun-failed loop, dev iteration)
	@if [ -z "$(AGENT)" ]; then \
	  echo "✗ AGENT is required"; exit 2; \
	fi
	go run . -agent "$(AGENT)" -agent-args "$(AGENT_ARGS)" $(ARGS)

bench-record: build      ## Like bench, but record each task to mp4 via kinrec
	@if [ -z "$(AGENT)" ]; then \
	  echo "✗ AGENT is required, e.g. make bench-record AGENT=./kinclaw AGENT_ARGS='-exec {prompt}'"; \
	  exit 2; \
	fi
	@if [ -z "$$SKIP_WARMUP" ]; then ./warmup.sh; fi
	go run . -agent "$(AGENT)" -agent-args "$(AGENT_ARGS)" -record $(ARGS)

warmup:                  ## Reset env: kill apps, wipe sandbox, clean KinBench data, probe TCC
	@./warmup.sh

test:                    ## Lint + sanity-check that all 50 tasks load
	@go vet ./...
	@count=$$(find tasks -name task.json | wc -l | tr -d ' '); \
	  echo "tasks discovered: $$count"

clean:                   ## Remove built binary + clear results dir (keeps .gitignore)
	@rm -f macbench-runner
	@find results -mindepth 1 -maxdepth 1 ! -name '.gitignore' -exec rm -rf {} +
	@echo "→ cleaned"
