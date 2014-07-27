## Coursera: Getting and Cleaning Data
### Codebook

The generated output is saved to the file tidy_data.csv. This file contains all rows merged from the test and training datasets.

The training and test data are transformed separately, combining the feature vector with the outcome variables and the subject identifiers (e.g. X_train.txt, Y_train.txt, subject_train.txt)
Then it merges the training and test data into a single, larger dataset.

The data is then subset to include only the mean and standard devation measurements from the original data. These columns have been identified by "-mean()" or "-std()" labels within the column name.

The analysis then takes the average value for each of the measurements by subject and activity.

The final output is the combined average values by subject-activity pair for every mean or std devation measurement in the original training and test data. Since we are required to get the average of each variable for each activity and each subject, and there are 6 activities in total and 30 subjects in total, we have 180 rows with all combinations for each of the 66 features.