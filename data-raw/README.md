# Raw data processing for the package

## Dataset outputs

This directory and its subdirs contain the code and data needed to
produce the data files used by the modeling functions in the package.
All of the outputs from these functions are saved as package data and
documented in the package documentation (accessed with
`help(dataset-name)` from within R).

Datasets included:  
* `region_hourly` : load and temperature by region and hour
* `residual_load` : residual load by region and hour
* `energy_weekly` : weekly petroleum and gas consumption
* `gdp_quarterly` : quarterly national GDP values

## Code and processing

### Petroleum, gas, and GDP data

Raw data for these variables, as produced by the `eiafcst` python
package, is stored in the `gdp` subdir.  The data is subdivided into
`dev`, `train`, and `test` subsets, but these distinctions are not
used in this package.  The data is converted from its original python
save format to csv by the code in `gdp/dev/fixdata.ipynb`.  Although this
code lives in the `dev` subdir, it processes all three datasets.  The
csv files are processed by the code in `gdp/procgdp.R` and saved in
the package datasets listed above.

### Electricity and temperature data

Electricity and temperature data are processed using the raw data in
`temperature_by_agg_region.csv.gz` and `load_by_agg_region.csv.gz`,
both of which are produced by the `eiafcst` python package.  These
data are read in and saved as package data.

