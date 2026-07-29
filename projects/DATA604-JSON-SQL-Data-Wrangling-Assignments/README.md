# JSON & SQL Data Wrangling Assignments

**Course:** DATA 604, University of Calgary
**Author:** Bhuvan Dubey

## Problem

Two individual assignments building core data-wrangling skills: parsing and
flattening nested, hierarchical JSON without relying on pandas, and using SQL
(via SQLAlchemy/SQLite) to explore, aggregate, and question a real municipal
open-data CSV.

## Approach

**Assignment 1 — JSON to CSV (`Assignment-1-JSON-To-CSV/`)**
- Read and inspected a nested `recipes.json` file (categories → books/blogs →
  recipes → ingredients/components) using only Python built-ins and the `json`
  module — no pandas.
- Searched the nested structure for recipes containing a target ingredient
  ("Black pepper"), traversing books, blogs, and nested recipe components.
- Identified the relational structure implied by the JSON (categories, books,
  blogs, recipes, ingredients) and reasoned about primary/foreign keys and
  which entities are hardest to flatten (recipes, since they appear under both
  books and blogs and can contain nested sub-recipes).
- Wrote the nested JSON out to five normalized CSVs (`categories`, `books`,
  `blogs`, `recipes`, `ingredients`) using only the `csv` and `json` modules.

**Assignment 2 — SQL exploration of a pets dataset (`Assignment-2-SQL-Pets-Dataset/`)**
- Loaded the City of Edmonton's Licensed Pets by Breed and Forward Sortation
  Area (FSA) dataset into SQLite via SQLAlchemy, then queried it entirely in
  SQL through `pandas.read_sql`.
- Warm-up queries: total records, known vs. unknown FSAs, top FSAs by dog
  count, and a discussion of why FSA-level data can't be resolved down to
  specific streets/addresses.
- Simple aggregation queries: top 5 FSAs by licensed dogs, number of distinct
  dog breeds, most-licensed cat breed, breed counts by area, and the overall
  cat-to-dog ratio.
- Self-directed analysis with two guiding questions — **(1)** which FSAs have
  the most diverse range of pet breeds, and **(2)** which FSAs are strongly
  cat- or dog-dominant — each answered with two supporting SQL queries
  (`GROUP BY`/`COUNT(DISTINCT ...)` for diversity; conditional `SUM(CASE ...)`
  aggregation for the cat/dog ratio by area).

## Key Results

- Recipes containing "Black pepper" were found across every level of the
  JSON's nesting (a top-level book recipe, a nested component recipe, and a
  blog recipe): Black Pepper Tofu, Chicken Stew, Homemade Chicken Broth, Beef
  Chili.
- FSA **T5T** has the most licensed dogs (4,537); FSA **T6L** has the greatest
  breed diversity for both dogs (170 breeds) and cats (43 breeds).
- Pet-ownership preference varies geographically: FSA **T5K** is the most
  cat-dominant area (cat-to-dog ratio of 1.33), while **T6R** (0.34) and
  **T5Y** (0.42) are strongly dog-dominant.

## Tech Stack

- **Python** (built-in `json`, `csv` modules only — Assignment 1)
- **SQL** via **SQLAlchemy** + **SQLite**, queried through `pandas.read_sql` (Assignment 2)
- Dataset: [Licensed Pets by Breed and Forward Sortation Area](https://data.edmonton.ca/Demographics/Licensed-Pets-by-Breed-and-Forward-Sortation-Area-/bqmh-j34s) (City of Edmonton, 2019)

## Files

- `Assignment-1-JSON-To-CSV/Assignment_1.ipynb` — notebook (self-contained,
  reads `recipes.json` from the same folder)
- `Assignment-1-JSON-To-CSV/recipes.json` — nested source JSON
- `Assignment-2-SQL-Pets-Dataset/Assignment_2.ipynb` — notebook (self-contained,
  reads the CSV from the same folder and builds a local `pets.db` SQLite file)
- `Assignment-2-SQL-Pets-Dataset/Licensed_Pets_by_Breed_and_Forward_Sortation_Area__FSA_.csv` — source data

## Note on a fix made before adding to this repo

In the submitted Assignment 1 notebook, the answers to Part B Questions 2 and 3
had been typed directly into **code** cells instead of markdown cells, which
throws a `SyntaxError` if the notebook is run top-to-bottom. Both cells were
converted to markdown here so the notebook executes cleanly end-to-end; no
answer text was changed.
