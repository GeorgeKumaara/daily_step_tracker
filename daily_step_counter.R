install.packages("ggplot2") # Install ggplot2 for creating complex graphs. 
library("ggplot2") # Load the package ggplot2 into the workspace. 

fitness_data <- read.csv("Health_dashboard_input_test - Data.csv", header = TRUE) # Load the fitness data. 
fitness_targets <- read.csv("Health_dashboard_input_test - Targets.csv", header = TRUE) # Load the fitness targets. 
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
