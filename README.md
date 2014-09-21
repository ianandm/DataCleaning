DataCleaning
============

The objective of this code is to generate a tidy data set from the Human Activity Recognition Using Smartphones Dataset. The data set generated from this exercise will bring in data from multiple data sets in a way that its easier to analyze and understand. Further analysis will be possible with greater ease on this data set. The mergeDataSet function merges the data set given as a part of UCI CHAR Dataset into one data set. This function also makes the column names of activity and subject descriptive.

mergeDataSet() function reads data from the various train and test data files from the UCI CHAR Data set into individial data tables and rbinds them to form 1 data set, which can then be taken up for Tidying. This function used a few other finction to produce the final tidy data set.

variableDS() function get the relevant columns for the mean and std measurements.

getVariableNames() for the columns chosen using the variableDS function, getVariableNames() assigns meaningful names to the columns and removes the cryptic names

getTidyData() function traverses through the rbinded data set generated in mergeDataSet() and returns a data set that is the average of the means and stds for each subject and activity.

getDataSub () function is used by the getTidyData() function to extract data with respect to the subjects one at a time.
