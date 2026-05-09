// Package main is a one-shot generator that produces task.json stubs
// for unimplemented macbench tasks.
//
// Run from the macbench repo root:
//
//	go run ./cmd/gen-stubs
//
// For each entry in `stubs` below, creates tasks/<id>/task.json with
// status="stub" if the directory doesn't already have a task.json.
// Existing implemented tasks (with setup.sh / eval.sh) are not touched.
//
// Each stub has a real, specific prompt — not "TODO". The prompts are
// designed so a future implementer can write setup.sh + eval.sh
// without having to re-design the task. The runner skips stubs at
// run time (see runner.go IsStub()).
package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

type stub struct {
	ID         string
	Category   string
	Difficulty string
	Prompt     string
	TimeoutSec int
}

// taskJSON is the on-disk shape we write. Mirrors runner.Task's JSON
// fields exactly (we re-declare here to keep the generator standalone).
type taskJSON struct {
	ID         string `json:"id"`
	Category   string `json:"category"`
	Difficulty string `json:"difficulty"`
	Prompt     string `json:"prompt"`
	TimeoutSec int    `json:"timeout_sec,omitempty"`
	Status     string `json:"status,omitempty"`
}

func main() {
	root := "tasks"
	created, skipped := 0, 0
	for _, s := range stubs() {
		dir := filepath.Join(root, s.ID)
		jsonPath := filepath.Join(dir, "task.json")
		if _, err := os.Stat(jsonPath); err == nil {
			// Already exists (likely an implemented task). Don't clobber.
			skipped++
			continue
		}
		if err := os.MkdirAll(dir, 0o755); err != nil {
			fmt.Fprintf(os.Stderr, "mkdir %s: %v\n", dir, err)
			os.Exit(1)
		}
		raw, err := json.MarshalIndent(taskJSON{
			ID:         s.ID,
			Category:   s.Category,
			Difficulty: s.Difficulty,
			Prompt:     s.Prompt,
			TimeoutSec: s.TimeoutSec,
			Status:     "stub",
		}, "", "  ")
		if err != nil {
			fmt.Fprintf(os.Stderr, "marshal %s: %v\n", s.ID, err)
			os.Exit(1)
		}
		raw = append(raw, '\n')
		if err := os.WriteFile(jsonPath, raw, 0o644); err != nil {
			fmt.Fprintf(os.Stderr, "write %s: %v\n", jsonPath, err)
			os.Exit(1)
		}
		created++
	}
	fmt.Printf("created %d stubs, skipped %d (existing task.json)\n", created, skipped)
}
