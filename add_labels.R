# Add Labels to Dataset
library(haven)
library(readxl)

apply_labels <- function(data, surveycto_filepath){
  # Applies labels to dataset from SurveyCTO.  
  # INPUT
    # data: Dataset (dataframe)
    # surveycto_filepath: Filepath to surveycto .xlsx file
  
  survey_questions <- read_excel(surveycto_filepath,1)
  survey_choices <- read_excel(surveycto_filepath,2)
  
  # Prep Survey Questions
  survey_questions <- survey_questions[grepl("\\bselect_", survey_questions$type),]
  survey_questions$select_type <- survey_questions$type %>% str_replace_all(" .*","")
  survey_questions$type <- survey_questions$type %>% str_replace_all("select_one ", "") %>% str_replace_all("select_multiple ", "")
  survey_questions <- survey_questions %>%
    dplyr::select(type, name, select_type, label)
  
  # Prep Choices
  survey_choices$name <- survey_choices$name %>% as.character
  survey_choices <- survey_choices[!is.na(survey_choices$list_name),]
  
  for(var in names(data)){
    if(var %in% survey_questions$name){
      # Grab choices for that variable
      survey_choices_i <- survey_choices[survey_choices$list_name %in% survey_questions$type[survey_questions$name %in% var],]
      
      # If select one, make a factor variable, as one to one mapping for value to label
      if(survey_questions$select_type[survey_questions$name %in% var] == "select_one"){
        #data[[var]] <- factor(data[[var]],
        #                                      levels = as.numeric(survey_choices_i$name),
        #                                      labels = survey_choices_i$label)
        
        data[[var]] <- haven::labelled(data[[var]], 
                                                labels=eval(parse(text=paste0("c(", paste('"', survey_choices_i$label, '"' , "=", as.numeric(survey_choices_i$name) , collapse=", "), ")"))),
                                                label = survey_questions$label[survey_questions$name %in% var])
        
        
        # If select multiple, make string variable  
      } else{
        for(choice_i in 1:nrow(survey_choices_i)){
          data[[var]] <- data[[var]] %>% 
            str_replace_all(paste0("\\b", survey_choices_i$name[choice_i], "\\b"), survey_choices_i$label[choice_i])
        }
      }
      
    }
  }
  
  return(data)
}






