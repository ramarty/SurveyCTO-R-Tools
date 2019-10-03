# SurveyCTO-R-Tools
Work with SurveyCTO Data in R

### Add Labels to Dataset from SurveyCTO
__apply_label__: Add labels to dataset from SurveyCTO. For select_one variables, converts the variable into a labelled class (from the haven package). For select_multiple variables, converts the variable into a string.

```
# Load function and necessary packages
source("https://raw.githubusercontent.com/ramarty/SurveyCTO-R-Tools/master/add_labels.R")
library(haven)
library(readxl)
library(dplyr)

data <- read.csv("~/Desktop/dataset.csv")
surveycto_filepath <- read_excel("surveyform.xlsx")

data_labelled <- apply_labels(data, surveycto_filepath)

# Convert variable to character
data_labelled$variable_str <- as_factor(data_labelled$variable, levels = "labels") %>% as.character

# Convert variable to numeric (back to original numeric values)
data_labelled$variable_num <- as_factor(data_labelled$variable, levels = "values") %>% as.character %>% as.numeric
```


