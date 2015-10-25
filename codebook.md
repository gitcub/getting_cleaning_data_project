# Code Book

## Source Data
http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## R packages utilized
plyr

## Process
1. Read in data
The primary data sets include both test and trial data, scattered across multiple files.
  - The "X" files contain the data points
  - The "Y" files contain the activity ID
  - The "subject" files identifies the person being observed
Additionally, we are provided with a "features" and "activity_labels" files.
  - These files will help us create descriptive labels for the data.

2. Assign initial labels to files in order to begin cleanly aggregating data.

3. Merge the data sets.
This involved combining subject data, activity, and raw data for both test and training.
Then test and training data are combined into an aggregate table.

4. Subset the data to only include mean and standard deviation measurements.

5. Make column names descriptive and readable

6. Create tidy data
Aggregate the data based on mean.
Order the data based on subject and activity type.

7. Output the data to flat files.
