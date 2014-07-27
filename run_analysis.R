setwd("E://Coursera//GettingAndCleaningData//data//UCI HAR Dataset")

feature_names = read.table('features.txt') # 561 obs of 2 variables
x_test = read.table('test/X_test.txt') # 2947 obs of 563 variables
y_test = scan('test/Y_test.txt')
test_subjects = scan('test/subject_test.txt')

if ( length(y_test) != length(test_subjects) || length(y_test) != dim(x_test)[1] ) {
  stop('dimensions of test data set inputs do not match')
}

x_train = read.table('train/X_train.txt') # 7352 obs of 563 variables
y_train = scan('train/Y_train.txt') # 7352 obs
train_subjects = scan('train/subject_train.txt') # 7352 obs

if ( length(y_train) != length(train_subjects) || length(y_train) != dim(x_train)[1] ) {
  stop('dimensions of training data set inputs do not match')
}

# Set column headers on training and test data to those supplied in the features.txt file
names(x_train) = feature_names$V2
names(x_test) = feature_names$V2

# Merge predictors and subject variable for each data set
x_train$subject = train_subjects
x_test$subject = test_subjects

# Merge predictors and outcome variable for each data set
x_train$activity = y_train
x_test$activity = y_test

# Merge data sets
data_set = rbind(x_train, x_test)


# Extract only the measurements on the mean and standard deviation observation.

mean_std_cols = grepl( '(-mean\\(\\)|-std\\(\\))', feature_names$V2 )
mean_std_cols = append(mean_std_cols, TRUE) # keep the subject and activity

means_and_stds = data_set[, mean_std_cols] # 10299 obsof 68 variables

# Use descriptive activity names within the data set

activity_labels = read.table('activity_labels.txt')
means_and_stds$activity_label = factor(means_and_stds$activity, levels=c(1,2,3,4,5,6), labels=activity_labels$V2)


tidy.frame = data.frame()

# remove duplicate rows and sort
subjects = sort( unique(means_and_stds$subject) )
activities = sort( unique(means_and_stds$activity) )

for (sub in subjects) {
  for (act in activities) {
    # subset by subject && activity
    subset = means_and_stds[ means_and_stds$subject==sub & means_and_stds$activity == act, ]
    # get the mean values for each subject-activity pair, then coerce as a data.frame
    by_subject_and_activity = as.data.frame( lapply( subset[,1:66], FUN=mean ) )
    # resupply subject, activity and activity label
    by_subject_and_activity$subject = sub
    by_subject_and_activity$activity = act
    by_subject_and_activity$activity_label = activity_labels[act,2]
    # build up a tidy dataset
    tidy.frame = rbind(tidy.frame, by_subject_and_activity)
  }
}

#
write.table( tidy.frame, file="tidy_data.csv" )