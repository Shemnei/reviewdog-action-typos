#!/bin/sh
set -eou pipefail

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
# TODO: Check if expansion is applied
# INPUT_EXCLUDE="${INPUT_EXCLUDE:-}"
INPUT_CONFIG="${INPUT_CONFIG:-}"
INPUT_ISOLATED="${INPUT_ISOLATED:-}"
INPUT_WRITE_CHANGES="${INPUT_WRITE_CHANGES:-}"
INPUT_LOCALE="${INPUT_LOCALE:-}"
INPUT_DEBUG="${INPUT_DEBUG:-}"

# Logic
if [ -n "${GITHUB_WORKSPACE}" ] ; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
  git config --global --add safe.directory "${GITHUB_WORKSPACE}" || exit 1
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo '::group:: Setting up typos args ...'
ARGS="--force-exclude"

# Use a custom configuration file
if [ -n "${INPUT_CONFIG}" ]; then
  ARGS="${ARGS} --config ${INPUT_CONFIG}"
fi

while read -r exclude_glob; do
  if [ -n "${exclude_glob}" ]; then
    set -- --exclude="${exclude_glob}"
    ARGS="${ARGS} ${*}"
  fi
done <<EOF
${INPUT_EXCLUDE:-}
EOF

# Ignore implicit configuration files
if [ "${INPUT_ISOLATED}" = "true" ]; then
  ARGS="${ARGS} --isolated"
fi

if [ "${INPUT_WRITE_CHANGES}" = "true" ]; then
  ARGS="${ARGS} --write-changes"
fi

if [ -n "${INPUT_LOCALE}" ]; then
  ARGS="${ARGS} --locale ${INPUT_LOCALE}"
fi

if [ "${INPUT_DEBUG}" = "true" ]; then
  # Verbosity 4 seems to be the sweet spot?
  ARGS="${ARGS} -vvvv"
fi

while read -r file; do
  if [ -n "${file}" ]; then
    ARGS="${ARGS} ${file}"
  fi
done <<EOF
${INPUT_FILES}
EOF

echo '::endgroup::'

if [ "${INPUT_DEBUG}" = "true" ]; then
  echo '::group:: Debugging typos (config) ...'
  # shellcheck disable=SC2086
  typos ${ARGS} --dump-config -
  echo '::endgroup::'

  echo '::group:: Debugging typos (files) ...'
  # shellcheck disable=SC2086
  typos ${ARGS} --files
  echo '::endgroup::'
fi

if [ "${INPUT_REPORTER}" = "github-pr-review" ]; then
  echo '::group:: Running typos (suggestion) ...'

  # -reporter must be github-pr-review for the suggestion feature.
  # shellcheck disable=SC2086
  typos ${ARGS} --diff \
    | reviewdog \
    -name="typos (suggestion)" \
    -f=diff \
    -f.diff.strip=1 \
    -reporter="github-pr-review" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
    ${INPUT_REVIEWDOG_FLAGS}

  EXIT_CODE="${?}"

  echo '::endgroup::'
else
  echo '::group:: Running typos ...'

  # shellcheck disable=SC2086
  typos ${ARGS} --format brief \
    | reviewdog -efm="%f:%l:%c: %m" \
    -name="typos" \
    -reporter="${INPUT_REPORTER}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
    -level="${INPUT_LEVEL}" \
    ${INPUT_REVIEWDOG_FLAGS}

  EXIT_CODE="${?}"

  echo '::endgroup::'
fi

if [ "${EXIT_CODE}" -ne 0 ]; then
  exit $((EXIT_CODE))
fi
