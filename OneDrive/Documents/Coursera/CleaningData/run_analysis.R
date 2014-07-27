# Set working directory 
setwd("C:/Users/Josh.Josh-PC/OneDrive/Documents/Coursera/CleaningData")


# Check to see if the file already exists first
if(!file.exists("./data")){dir.create("./data")}

# declare the URL of the file and the date
today = as.Date(Sys.time())
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# download the file
data <- download.file(fileUrl, destfile = "./data/dataset.zip")

# Unzip the files
unzip("./data/dataset.zip", overwrite = TRUE)

# Get the Features (column names)
features <- read.table("C:/Users/Josh.Josh-PC/OneDrive/Documents/Coursera/CleaningData/UCI HAR Dataset/features.txt")

# Get the activity Labels
activity_labels <- read.table("C:/Users/Josh.Josh-PC/OneDrive/Documents/Coursera/CleaningData/UCI HAR Dataset/activity_labels.txt")

# Get the X_test data and set the column names
X_test <- read.table("C:/Users/Josh.Josh-PC/OneDrive/Documents/Coursera/CleaningData/UCI HAR Dataset/test/X_test.txt")


# Get the Y_test data
Y_test <- read.table("C:/Users/Josh.Josh-PC/OneDrive/Documents/Coursera/CleaningData/UCI HAR Dataset/test/Y_test.txt")

# Get the Y_train data
Y_train <- read.table("C:/Users/Josh.Josh-PC/OneDrive/Documents/Coursera/CleaningData/UCI HAR Dataset/train/Y_train.txt")

# Replace the number values of Y_train with activity
Y_train <- replace(Y_train, Y_train == 1, "walking")
Y_train <- replace(Y_train, Y_train == 2, "walking upstairs")
Y_train <- replace(Y_train, Y_train == 3, "walking downstairs")
Y_train <- replace(Y_train, Y_train == 4, "sitting")
Y_train <- replace(Y_train, Y_train == 5, "standing")
Y_train <- replace(Y_train, Y_train == 6, "laying")

# Replace the number values of Y_test with activity
Y_test <- replace(Y_test, Y_test == 1, "walking")
Y_test <- replace(Y_test, Y_test == 2, "walking upstairs")
Y_test <- replace(Y_test, Y_test == 3, "walking downstairs")
Y_test <- replace(Y_test, Y_test == 4, "sitting")
Y_test <- replace(Y_test, Y_test == 5, "standing")
Y_test <- replace(Y_test, Y_test == 6, "laying")

# Get the X_train data 
X_train <- read.table("C:/Users/Josh.Josh-PC/OneDrive/Documents/Coursera/CleaningData/UCI HAR Dataset/train/X_train.txt")

# Get the Test Subjects
test_subjects <- read.table("C:/Users/Josh.Josh-PC/OneDrive/Documents/Coursera/CleaningData/UCI HAR Dataset/test/subject_test.txt")

# Get the Train Subjects
train_subjects <- read.table("C:/Users/Josh.Josh-PC/OneDrive/Documents/Coursera/CleaningData/UCI HAR Dataset/train/subject_train.txt")

# merge the training data
merged_train <- cbind(Y_train, X_train)

# merge the test data
merged_test <- cbind(Y_test, X_test)

#merge the test subjects and test data
merged_test2 <- cbind(test_subjects, merged_test)

# merge the training subjects and training set
merged_train2 <- cbind(train_subjects, merged_train)

# merge the test and train data sets
merged_all <- rbind(merged_train2, merged_test2)

# Create the column names and assign them to the final data set
names <- as.character(features$V2)
names <- sub("^t","Total",names)
names <- sub("^f","Frequency",names)
colnames(merged_all) <- c("subject", "treatment", names)

# find only columns with Mean and Std 
names2 <- colnames(merged_all)
feat <- grep("-mean|-std", names2)
feat2 <-names2[feat]
merged_subset <- merged_all[c(1,2,feat)]

# melt the data to eliminate multiple rows for the same subject/treatment
tidy_melted <- melt(merged_subset, id=c("subject", "treatment"), measure.vars=c(feat2))

# organize and average the data by subject and treatement
final_tidy <- dcast(tidy_melted, subject + treatment ~ variable, mean)

#view the final tidy dataset
View(final_tidy)

# print the tidy data to a data table (.csv)
write.csv(final_tidy, file = "final_tidy.csv", row.names = FALSE)