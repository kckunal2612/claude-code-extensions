#!/usr/bin/env bash
set -euo pipefail

find skills -path "*/SKILL.md" -print | sort
