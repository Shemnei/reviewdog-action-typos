# Shemnei/reviewdog-action-typos

[![Test](https://github.com/Shemnei/reviewdog-action-typos/workflows/Test/badge.svg)](https://github.com/Shemnei/reviewdog-action-typos/actions?query=workflow%3ATest)
[![reviewdog](https://github.com/Shemnei/reviewdog-action-typos/workflows/reviewdog/badge.svg)](https://github.com/Shemnei/reviewdog-action-typos/actions?query=workflow%3Areviewdog)
[![depup](https://github.com/Shemnei/reviewdog-action-typos/workflows/depup/badge.svg)](https://github.com/Shemnei/reviewdog-action-typos/actions?query=workflow%3Adepup)
[![release](https://github.com/Shemnei/reviewdog-action-typos/workflows/release/badge.svg)](https://github.com/Shemnei/reviewdog-action-typos/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Shemnei/reviewdog-action-typos?logo=github&sort=semver)](https://github.com/Shemnei/reviewdog-action-typos/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

This repo contains a reviewdog action to run [typos](https://github.com/crate-ci/typos).

## Input

```yaml
inputs:
  github_token:
    description: 'GITHUB_TOKEN'
    default: '${{ github.token }}'
  workdir:
    description: 'Working directory relative to the root directory.'
    default: '.'
  ### Flags for reviewdog ###
  level:
    description: 'Report level for reviewdog [info,warning,error]'
    default: 'error'
  reporter:
    description: 'Reporter of reviewdog command [github-pr-check,github-check,github-pr-review].'
    default: 'github-pr-check'
  filter_mode:
    description: |
      Filtering mode for the reviewdog command [added,diff_context,file,nofilter].
      Default is added.
    default: 'added'
  fail_on_error:
    description: |
      Exit code for reviewdog when errors are found [true,false]
      Default is `false`.
    default: 'false'
  reviewdog_flags:
    description: 'Additional reviewdog flags'
    default: ''
  ### Flags for typos ###
  exclude:
    description: 'Files or patterns to exclude'
    required: false
  files:
    description: 'Files or patterns to check'
    required: false
  config:
    description: 'Use a custom config file'
    required: false
```

## Usage

```yaml
name: reviewdog
on: [pull_request]
jobs:
  typos:
    name: runner / typos
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: reviewdog/action-template@v1
        with:
          github_token: ${{ secrets.github_token }}
          # Change reviewdog reporter if you need [github-pr-check,github-check,github-pr-review].
          reporter: github-pr-review
          # Change reporter level if you need.
          # GitHub Status Check won't become failure with warning.
          level: warning
	  exclude: |
	    *.yaml
```

## Development

### Release

#### [haya14busa/action-bumpr](https://github.com/haya14busa/action-bumpr)

You can bump version on merging Pull Requests with specific labels (bump:major,bump:minor,bump:patch).
Pushing tag manually by yourself also work.

#### [haya14busa/action-update-semver](https://github.com/haya14busa/action-update-semver)

This action updates major/minor release tags on a tag push. e.g. Update v1 and v1.2 tag when released v1.2.3.
ref: https://help.github.com/en/articles/about-actions#versioning-your-action

### Lint - reviewdog integration

This reviewdog action template itself is integrated with reviewdog to run lints
which is useful for Docker container based actions.

![reviewdog integration](https://user-images.githubusercontent.com/3797062/72735107-7fbb9600-3bde-11ea-8087-12af76e7ee6f.png)

Supported linters:

- [reviewdog/action-shellcheck](https://github.com/reviewdog/action-shellcheck)
- [reviewdog/action-hadolint](https://github.com/reviewdog/action-hadolint)
- [reviewdog/action-misspell](https://github.com/reviewdog/action-misspell)

### Dependencies Update Automation

This repository uses [reviewdog/action-depup](https://github.com/reviewdog/action-depup) to update
reviewdog version.

[![reviewdog depup demo](https://user-images.githubusercontent.com/3797062/73154254-170e7500-411a-11ea-8211-912e9de7c936.png)](https://github.com/reviewdog/action-template/pull/6)
