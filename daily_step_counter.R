install.packages("ggplot2") # Install ggplot2 for creating complex graphs. 
library("ggplot2") # Load the package ggplot2 into the workspace. 

fitness_data <- read.csv("Health_dashboard_input - Data.csv", header = TRUE) # Load the fitness data. 
fitness_targets <- read.csv("Health_dashboard_input - Targets.csv", header = TRUE) # Load the fitness targets. 
# Ensure that both files are in the same directory as this R script. 
# The files in the code may have to be renamed depending on the file names. 

head(fitness_data)
head(fitness_targets)

fitness_data$Day <- as.Date(fitness_data$Day, format = "%d/%m/%Y") # This converts the variable into the date format. 
 
head(fitness_data_steps)

target_steps <- fitness_targets$Target_steps

steps_input <- data.frame(Day = fitness_data$Day, 
                          Steps = fitness_data$Steps,
                          target_steps = target_steps) # This creates a dataframe out of the input files that can be used to create the graph. 

head(steps_input)
nrow(steps_input)

step_chart <- ggplot(steps_input, aes(x = Day, y = Steps))+
  geom_point(aes(color = Steps > target_steps))+
  scale_color_manual(values = c("orange", "green"))+
  geom_hline(yintercept = target_steps, linetype = "dashed", color = "red", size = 0.5)+ # This line shows the target step count.
  theme(legend.position = "none")+
  scale_x_date(date_labels = "%B")

step_chart

ggsave(step_chart, file = "Daily_step_report.jpg")

############ 

# Now we are going to create a weekly exercise report. 

############ 

# Let's create a stacked bar chart showing the minutes of moderate and intense exercise per day. 

fitness_data <- read.csv("Health_dashboard_input - Data.csv")
head(fitness_data) 

install.packages("tidyverse")
library("tidyverse")

transformed_table <- fitness_data %>%       # This transforms the input data into a usable format. 
  pivot_longer(cols = starts_with("Mins"),
               names_to = "Exercise_Type",
               values_to = "Minutes") %>%
  mutate(Exercise_Type = gsub("Mins_", "", Exercise_Type))

head(transformed_table)

# The table categories are now Day, Steps, Exercise_Type and Minutes. 

exercise_graph <- ggplot(transformed_table, aes(fill = Exercise_Type, y = Minutes, x = Day))+ 
  geom_bar(position = "stack", stat = "identity")+
  scale_fill_discrete(labels = c("Intense exercise", "Moderate Exercise"), name = "Exercise type") # This creates a daily exercise report. 

exercise_graph

# ggsave(exercise_graph, file = "daily_exercise_graph.jpg")
# The above code creates a daily exercise graph. 
# The script itself will not produce this graph unless one removes the "#" symbol from "ggsave(daily_)...". 
# I omitted it as it is not as useful as a weekly report. If you would like to see this then remove the "#" symbol. 

############ 

# Now let's create a weekly exercise report. 

transformed_table <- transformed_table %>%
  mutate(Week = week(Day)) # This adds a column for the week. 
head(transformed_table)

weekly_report <- ggplot(transformed_table, aes(y = Minutes, x = Week, fill = Exercise_Type))+
  geom_bar(position = "stack", stat = "identity")+
  scale_fill_discrete(labels = c("Intense exercise", "Moderate Exercise"), name = "Exercise type")
weekly_report
ggsave(weekly_report, file = "Weekly_exercise_report.jpg")
