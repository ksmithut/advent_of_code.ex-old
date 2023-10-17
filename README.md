# AdventOfCode

These are my solutions written in Elixir for [Advent of Code](https://adventofcode.com)

# Folder structure

```
.
├── input/            # You can .gitignore this if you'd like
│   └── {year}/       # Each year has its own folder for input
│       └── {day}.txt
├── lib/
│   ├── {year}/       # Each year has its own folder for solutions
│   │   └── {day}.ex
│   ├── mix/          # This folder contains the mix tasks for easy running
│   │   ├── aoc.ex
│   │   └── gen.ex
│   ├── advent_code_code.ex # This is the module to help run your code
│   └── template.eex  # This is the template used when you generate a new day's file
└── test/
    ├── advent_of_code_test.exs # doctests are set up here
    └── test_helper.exs
```

# Commands

Generate a new day file using `lib/template.eex` as a template.

```sh
mix gen --year 2015 --day 1
mix gen --day 1 # assumes current year if the current month is november or december
mix gen -y 2016 -d 2
```

Run a given day's function with the input from `input/{year}/{day}.txt`

```sh
mix aoc --year 2015 --day 1 --part 1
mix aoc --day 1 # assumes current year if the current month is november or december, and assumes part 1
mix aoc -y 2016 -d 1 -p 2
```
