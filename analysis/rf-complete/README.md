# Random forest completion of missing data

The code in this subdirectory uses a random forest model to
approximate the missing data in the WACM PCA in 2006-2007 and the OVEC
PCA in 2017.  This completion is necessary so that the regional totals
will not be wildly different from other years during the years that
these two PCAs are missing.  

This calculation requires as input the file `temp_by_hr_pca.rds`,
which owing to its large size cannot be included in this repository.
It can be downloaded from the auxiliary data archive described in the
final report.

The other inputs for this calculation are derived from the `eiafcst`
python package's data preparation pipeline.  The pipeline is run once
without the completion data to produce the file
`elec-by-hour-2006-2017.rds`, which is used as input to this
calculation.  This code is run to produce the output
`random-forest-fill-values.csv`.  This output is placed in the
designated subdir of the `eiafcst` python package, and thereafter the
fill-in values will be included in rebuilds of the input data.

