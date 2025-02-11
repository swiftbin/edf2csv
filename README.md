# edf2csv

A CLI tool to convert EDF files to CSV files

<!-- # Badges -->

[![Github issues](https://img.shields.io/github/issues/swiftbin/edf2csv)](https://github.com/swiftbin/edf2csv/issues)
[![Github forks](https://img.shields.io/github/forks/swiftbin/edf2csv)](https://github.com/swiftbin/edf2csv/network/members)
[![Github stars](https://img.shields.io/github/stars/swiftbin/edf2csv)](https://github.com/swiftbin/edf2csv/stargazers)
[![Github top language](https://img.shields.io/github/languages/top/swiftbin/edf2csv)](https://github.com/swiftbin/edf2csv/)

## Usage

```
OVERVIEW: Convert an EDF file to a CSV file.

USAGE: edf2csv <input-path> [--output <output>] [--aggregate <aggregate>] [--delimiter <delimiter>] [--no-header]

ARGUMENTS:
  <input-path>            Path to the input EDF file.

OPTIONS:
  -o, --output <output>   Path to the output CSV file.
  --aggregate <aggregate> Aggregation method: mean, mode, max, min. (default:
                          mean)
  --delimiter <delimiter> CSV delimiter character (default: ','). (default: ,)
  --no-header             Do not include a header row.
  --version               Show the version.
  -h, --help              Show help information.
```

## License

edf2bin is released under the MIT License. See [LICENSE](./LICENSE)
