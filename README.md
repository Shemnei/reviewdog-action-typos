# Shemnei/reviewdog-action-typos

[![reviewdog](https://github.com/Shemnei/reviewdog-action-typos/workflows/reviewdog/badge.svg)](https://github.com/Shemnei/reviewdog-action-typos/actions?query=workflow%3Areviewdog)
[![depup](https://github.com/Shemnei/reviewdog-action-typos/workflows/depup/badge.svg)](https://github.com/Shemnei/reviewdog-action-typos/actions?query=workflow%3Adepup)
[![release](https://github.com/Shemnei/reviewdog-action-typos/workflows/release/badge.svg)](https://github.com/Shemnei/reviewdog-action-typos/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Shemnei/reviewdog-action-typos?logo=github&sort=semver)](https://github.com/Shemnei/reviewdog-action-typos/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

This action runs [typos](https://github.com/crate-ci/typos) with
[reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve
code review experience.

## Usage

```yaml
name: Reviewdog

on: [pull_request]

jobs:
  typos:
    name: runner / typos
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: Shemnei/reviewdog-action-typos@v0
        with:
          reporter: github-check
          level: error
          fail_on_error: true
```

## Input

For a complete list of accepted input values see [action.yaml](./action.yaml).

### `files`

Specify files to check.

__Default__: `.`

__Example__

```yaml
files: |
  ./testdir
  myfile.txt
```

### `exclude`

Specify glob patterns of files to ignore.

__NOTE__: This will also ignore any files explicitly defined with `files`.

__Default__: `<unset>`

__Example__

```yaml
exclude: |
  *.yaml
  *.json
```

### `config`

Explicitly set the configuration file to use. If not set, `typos` will figure out the correct config to use.

__Default__: `<unset>`

__Example__

```yaml
config: ./config/.typos.yaml
```

### `isolated`

Tells `typos` to ignore any implicitly defined configuration files (ignore config files not set by `config`).

__Default__: `false`

__Example__

```yaml
isolated: true
```

### `write_changes`

Tells `typos` to update __ALL__ found spell mistakes. This doesn't not commit or push anything to the branch. It only writes the changes locally to disk.

__NOTE__: This will update __ALL__ mistakes, not only files/changes from the current PR or commit (e.g. this acts like `reviewdog`s `-filter-mode=nofilter`).

__Default__: `false`

__Example__

```yaml
write_changes: true
```

### `locale`

Language locale to suggest corrections for. Possible values are `[en, en-us, en-gb, en-ca, en-au]`.

__Default__: `<unset>`

__Example__

```yaml
locale: en-gb
```

### `debug`

Runs the action in debug mode. This enables various outputs which might be useful for debugging like:

- Dump the used `typos` config
- Dump all files to be checked
- Enable `typos` verbose mode

__NOTE__: This is also enabled when an action is run with `Enable debug logging` active (Github UI).

__Default__: `<unset>`

__Example__

```yaml
debug: true
```

### Deprecated inputs

The original `typos` action also has the following inputs which are declared but not used at all (i might be missing something):

- `extend_identifiers`
- `extend_words`

To allow easy porting (copy-paste) and have feature parity the inputs where included but will print a deprecated warning on usage.

__NOTE__: The value of these inputs will be ignored and are not used.
