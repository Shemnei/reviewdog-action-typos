#!/bin/sh
set -e

# Build in
GITHUB_WORKSPACE="${GITHUB_WORKSPACE:-}"

# Inputs
## Required (defaults set by `action.yml`)
INPUT_GITHUB_TOKEN="${INPUT_GITHUB_TOKEN:?No github token provided}"
INPUT_WORKDIR="${INPUT_WORKDIR:?No reviewdog relative working directory provided}"
INPUT_LEVEL="${INPUT_LEVEL:?No reviewdog level provided}"
INPUT_FILTER_MODE="${INPUT_FILTER_MODE:?No reviewdog filter mode provided}"
INPUT_REPORTER="${INPUT_REPORTER:?No reviewdog reporter provided}"
INPUT_FAIL_ON_ERROR="${INPUT_FAIL_ON_ERROR:?No reviewdog fail on error provided}"
## Optional
INPUT_REVIEWDOG_FLAGS="${INPUT_REVIEWDOG_FLAGS:-}"
INPUT_FILES="${INPUT_FILES:-}"
INPUT_CONFIG="${INPUT_CONFIG:-}"

# Logic
if [[ -n "${GITHUB_WORKSPACE}" ]] ; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
  git config --global --add safe.directory "${GITHUB_WORKSPACE}" || exit 1
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

# Only specific targets
TARGET="${INPUT_FILES:-"."}"
if [[ -z $(ls "${TARGET}" 2>/dev/null) ]]; then
    log "ERROR: Input files (${TARGET}) not found"
    exit 1
fi

ARGS="${TARGET}"

# Use a custom configuration file
if [[ -n "${INPUT_CONFIG}" ]]; then
    ARGS+=" --config ${INPUT_CONFIG}"
fi

typos ${ARGS} --format brief \
  | reviewdog -efm="%f:%l:%c: %m" \
      -name="linter-name (typos)" \
      -reporter="${INPUT_REPORTER}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}
