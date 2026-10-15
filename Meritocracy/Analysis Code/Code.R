library(dplyr)
library(ggplot2)
library(plyr)
library(texreg)
library(psych)
library(nnet)
library(tidyverse)
library(sandwich)
library(lmtest)
library(fixest)
library(multiwayvcov)
library(stargazer)


# Importing Data --------------------------------------------------------


dataAL <- read.csv("/Users/isabellebrocas/Desktop/JPE/data/dataAL.csv")
dataLL <- read.csv("/Users/isabellebrocas/Desktop/JPE/data/dataLL.csv")
dataME <- read.csv("/Users/isabellebrocas/Desktop/JPE/data/dataME.csv")
dataAG <- read.csv("/Users/isabellebrocas/Desktop/JPE/data/dataAG.csv")

dataLLsmall <- read.csv("/Users/isabellebrocas/Desktop/JPE/data/dataLLsmall.csv")
dataALsmall <- read.csv("/Users/isabellebrocas/Desktop/JPE/data/dataALsmall.csv")
dataMEsmall <- read.csv("/Users/isabellebrocas/Desktop/JPE/data/dataMEsmall.csv")

# Merging Data
dataBig <- bind_rows(dataAL, dataLL, dataME, dataAG)
dataSmall <- bind_rows(dataLLsmall, dataALsmall, dataMEsmall)



# Dropping Unnecessary Columns

drop <- c("Q1","Q2","Q3","Q4","Q5","Q6","Q7","Q8","Q9","Q10","Q11","Q12","Q13","Q14","Q15","Q16","Q17","Q18","Q19","Q20")
data = dataBig[,!(names(dataBig) %in% drop)]
data<-rbind(data,dataSmall)


# Cleanup and New Variables -----------------------------------------------

## Grade
data <- data %>%
  mutate(
    grade1 = case_when(
      grade == "1EPO" ~ "1",
      grade == "2EPO" ~ "2",
      grade == "3EPO" ~ "3",
      grade == "4EPO" ~ "4",
      grade == "5EPO" ~ "5",
      grade == "6EPO" ~ "6",
      grade == "1ESO" ~ "7",
      grade == "2ESO" ~ "8",
      grade == "3ESO" ~ "9",
      grade == "4ESO" ~ "10",
      grade == "1Bach" ~ "11",
      grade == "2Bach" ~ "12",
      TRUE ~ NA_character_
    )
  )

## Grade
data <- data %>%
  mutate(
    grade2 = case_when(
      grade == "1EPO" ~ "Early Elem.",
      grade == "2EPO" ~ "Early Elem.",
      grade == "3EPO" ~ "Early Elem.",
      grade == "4EPO" ~ "Late Elem.",
      grade == "5EPO" ~ "Late Elem.",
      grade == "6EPO" ~ "Late Elem.",
      grade == "1ESO" ~ "Early Middle",
      grade == "2ESO" ~ "Early Middle",
      grade == "3ESO" ~ "Late Middle",
      grade == "4ESO" ~ "Late Middle",
      grade == "1Bach" ~ "High School",
      grade == "2Bach" ~ "High School",
      TRUE ~ NA_character_
    )
  )


## STEM Topics
data <- data %>%
  mutate(
    Topic = case_when(
      prefTopic %in% c("Math", "Sciences & Technology") ~ "STEM",
      TRUE ~ "No STEM"
    ),
    BestTopic = case_when(
      bestAtTopic %in% c("Math", "Sciences & Technology") ~ "STEM",
      TRUE ~ "No STEM"
    )
  )

## Birth Month
month_mapping <- c(
  "Enero" = 12, "Febrero" = 11, "Marzo" = 10, "Abril" = 9,
  "Mayo" = 8, "Junio" = 7, "Julio" = 6, "Agosto" = 5,
  "Septiembre" = 4, "Octubre" = 3, "Noviembre" = 2, "Diciembre" = 1
)

data <- data %>%
  mutate(
    Month = month_mapping[birthMonth],
    Year = as.numeric(as.character(birthYear)),
    Age = (2022 - Year) * 12 + 3 + Month,
    AgeC = Age - mean(Age, na.rm = TRUE)
  )


data$AgeY<-data$Age/12

## Siblings
data <- data %>%
  mutate(Siblings = case_when(
    youngerSib == "Si" | olderSib == "Si" ~ "Yes",
    youngerSib == "No" & olderSib == "No" ~ "No"
  ))

## Task Feedback
data <- data %>%
  mutate(
    howWell2 = recode(howWell, "Mejor" = "Better", "Igual" = "Same", "Peor" = "Worse", "No lo se" = "Unknown"),
    howHard2 = recode(howHard, "Facil" = "Easy", "Regular" = "Medium", "Dificil" = "Hard", "No lo se" = "Unknown")
  )

## Gender Cleanup
data <- data %>%
  filter(gender %in% c("M", "F")) %>%
  mutate(gender = factor(gender))

## Pay Calculation
data <- data %>%
  mutate(
    PayWinner1 = ifelse(StartAlloc == 31, ToWinner1 + 3, ifelse(StartAlloc == 62, ToWinner1 + 6, NA)),
    PayWinner2 = ifelse(StartAlloc == 31, ToWinner2 + 3, ifelse(StartAlloc == 62, ToWinner2 + 6, NA))
  )


## Pay Loser
data <- data %>%
  mutate(
    PayLoser1 = ifelse(StartAlloc == 31, 8-PayWinner1, ifelse(StartAlloc == 62, 8-PayWinner1, NA)),
    PayLoser2 = ifelse(StartAlloc == 31, 8-PayWinner2, ifelse(StartAlloc == 62, 8-PayWinner2, NA))
  )




## 
data$Treatment <- factor(data$Treatment)



data$ToWinner1Type[data$StartAlloc==31 & data$ToWinner1==2]<-"1-Soc"
data$ToWinner1Type[data$StartAlloc==31 & data$ToWinner1==3]<-"2-Rep"
data$ToWinner1Type[data$StartAlloc==31 & data$ToWinner1==1]<-"3-Comm"

data$ToWinner1Type[data$StartAlloc==62 & data$ToWinner1==-2]<-"3-Comm"
data$ToWinner1Type[data$StartAlloc==62 & data$ToWinner1==0]<-"2-Rep"
data$ToWinner1Type[data$StartAlloc==62 & data$ToWinner1==-1]<-"1-Soc"


data$ToWinner2Type[data$StartAlloc==31 & data$ToWinner2==2]<-"1-Soc"
data$ToWinner2Type[data$StartAlloc==31 & data$ToWinner2==3]<-"2-Rep"
data$ToWinner2Type[data$StartAlloc==31 & data$ToWinner2==1]<-"3-Comm"

data$ToWinner2Type[data$StartAlloc==62 & data$ToWinner2==-2]<-"3-Comm"
data$ToWinner2Type[data$StartAlloc==62 & data$ToWinner2==0]<-"2-Rep"
data$ToWinner2Type[data$StartAlloc==62 & data$ToWinner2==-1]<-"1-Soc"

data$howHard5[data$howHard=="Facil"]<-"Easy"
data$howHard5[data$howHard=="Regular"]<-"Medium"
data$howHard5[data$howHard=="Dificil"]<-"Difficult"
data$howHard5[data$howHard=="No lo se"]<-"Medium"

data$howWell5[data$howWell=="Mejor"]<-"Better"
data$howWell5[data$howWell=="Igual"]<-"Same"
data$howWell5[data$howWell=="Peor"]<-"Worse"
data$howWell5[data$howWell=="No lo se"]<-"Same"

data$ChangeW<-data$ToWinner2-data$ToWinner1
data$ChangeP<-ifelse(data$ChangeW !=0,1,0)
data$BigE<-data$BigPic1
data$BigA<-data$BigPic2
data$BigC<-6-data$BigPic3
data$BigN<-data$BigPic4
data$BigO<-6-data$BigPic5

data$Cond <- NA_character_
data$Cond[data$StartAlloc=="62" & data$Treatment=="questions"]<-"Talent62"
data$Cond[data$StartAlloc=="62" & data$Treatment=="luck"]<-"Luck62"
data$Cond[data$StartAlloc=="62" & data$Treatment=="sliders"]<-"Effort62"

data$Cond[data$StartAlloc=="31" & data$Treatment=="questions"]<-"Talent31"
data$Cond[data$StartAlloc=="31" & data$Treatment=="luck"]<-"Luck31"
data$Cond[data$StartAlloc=="31" & data$Treatment=="sliders"]<-"Effort31"


# To export for validation ---------------------------------------------------------------


keep1<-c("Campus","SessionCode","ClientID","BigPic1","BigPic2","BigPic3","BigPic4","BigPic5","gender","grade","scoreTom")

keep2<-c("Campus","SessionCode","ClientID","BigPic1","BigPic2","BigPic3","BigPic4","BigPic5","Q1","Q2","Q3","Q4","Q5","Q6","Q7","Q8","Q9","Q10","Q11","Q12","Q13","Q14","Q15","Q16","Q17","Q18","Q19","Q20","gender","grade","scoreTom")

keep3<-c("Campus","SessionCode","ClientID","Age")


dataPersoBig<-dataBig[keep2]
dataPersoSmall<-dataSmall[keep1]
dataAge<-data[keep3]


################################### SECTION 2 ---------------------------------------------------------------

nrow(data)
table(data$grade1,data$Treatment,data$StartAlloc)


################################### SECTION 4 ---------------------------------------------------------------





####### Table 2 -----------------------------------------------------------------

# Samples 
# Initial allocation: drop addition rows with no recorded initial choice.
# Final allocation:   drop addition rows with no recorded final choice.
df1 <- subset(data, Age < 225 & (StartAlloc == 62 | (StartAlloc == 31 & ToWinner1 != 0)))
df2 <- subset(data, Age < 225 & (StartAlloc == 62 | (StartAlloc == 31 & ToWinner2 != 0)))

# Models 
rhs <- c(
  "Age + Treatment + as.factor(StartAlloc) + gender + Siblings + Topic",
  "Age + Treatment * as.factor(StartAlloc) + gender + Siblings + Topic",
  "Age + I(Age^2) + Treatment + as.factor(StartAlloc) + gender + Siblings + Topic",
  "Age + I(Age^2) + Treatment * as.factor(StartAlloc) + gender + Siblings + Topic"
)
fit <- function(r, lhs, d) {
  feols(as.formula(paste(lhs, "~", r, "| Campus")), data = d, vcov = ~ SessionCode)
}
initial <- lapply(rhs, fit, lhs = "8 - PayWinner1", d = df1)
final   <- lapply(rhs, fit, lhs = "8 - PayWinner2", d = df2)

# Row labels, in the order of the table 
labels <- c(
  "^Age$"                                              = "\\textit{Age}",
  "Age\\^2"                                            = "\\textit{Age}$^2$",
  "^Treatmentquestions$"                               = "\\textit{talent}",
  "^Treatmentsliders$"                                 = "\\textit{effort}",
  "^as\\.factor\\(StartAlloc\\)62$"                    = "\\textit{redist.}",
  "^gender"                                            = "\\textit{Male}",
  "^Siblings"                                          = "\\textit{Siblings}",
  "^Topic"                                             = "\\textit{STEM}",
  "^Treatmentquestions:as\\.factor\\(StartAlloc\\)62$" = "\\textit{redist.}$\\times$\\textit{talent}",
  "^Treatmentsliders:as\\.factor\\(StartAlloc\\)62$"   = "\\textit{redist.}$\\times$\\textit{effort}"
)

# fixest -> texreg, with the session-clustered standard errors 
to_texreg <- function(m) {
  ct  <- coeftable(m)
  old <- rownames(ct)
  new <- old
  for (p in names(labels)) new[grepl(p, old)] <- labels[[p]]
  createTexreg(
    coef.names  = new,
    coef        = unname(ct[, "Estimate"]),
    se          = unname(ct[, "Std. Error"]),
    pvalues     = unname(ct[, "Pr(>|t|)"]),
    gof.names   = c("Num. obs.", "R$^2$", "Adj. R$^2$"),
    gof         = c(nobs(m), unname(r2(m, "r2")), unname(r2(m, "ar2"))),
    gof.decimal = c(FALSE, TRUE, TRUE)
  )
}
models <- lapply(c(initial, final), to_texreg)

# Note 
n_campus <- length(unique(df1$Campus))
s1 <- length(unique(df1$SessionCode))
s2 <- length(unique(df2$SessionCode))
sessions <- if (s1 == s2) paste0(s1, " sessions") else
  paste0(s1, " sessions initial, ", s2, " final")
note <- paste0("\\item %stars. Campus FE (", n_campus, " campuses). ",
               "SE clustered at the session level (", sessions, ").")

# Table 
tab <- texreg(
  models,
  custom.model.names = c(rep("Initial", 4), rep("Final", 4)),
  custom.coef.map    = as.list(setNames(unname(labels), unname(labels))),
  stars              = c(0.01, 0.05, 0.1),
  digits             = 3,
  booktabs           = TRUE,
  dcolumn            = FALSE,
  use.packages       = FALSE,
  threeparttable     = TRUE,
  fontsize           = "footnotesize",
  float.pos          = "htpb",
  caption            = "Main treatment effects in the \\textit{initial} and \\textit{final} allocation to the loser.",
  caption.above      = FALSE,
  label              = "regtreatmentBeforeAfter",
  custom.note        = note
)
tab <- sub("\\tiny{", "\\footnotesize{", tab, fixed = TRUE)            # note in the size of the table
tab <- sub("\\begin{tabular}",                                         # tighter columns, as in Table 1
           "\\setlength{\\tabcolsep}{.62\\tabcolsep}\n\\begin{tabular}", tab, fixed = TRUE)
writeLines(tab, "../Paper/Figs/Table2.tex")









####### Figure 4-------

# Before Graph Redistribution-addition ------------------------------------

graph <- ddply(data,c("StartAlloc"),summarise,
               mean = round(mean(8-PayWinner1,na.rm=TRUE),digit=2),
               se = sd(8-PayWinner1, na.rm = TRUE) / sqrt(sum(!is.na(8-PayWinner1))))  # Standard Error)

graph$StartAlloc <- factor(graph$StartAlloc, levels = c("62", "31"))

g <- ggplot(graph, aes(y = as.numeric(mean), x = StartAlloc)) + 
  geom_bar(width = 0.4, stat = "identity", position = "dodge", fill = "lightblue") +
  coord_cartesian(ylim = c(2, 4)) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2, color = "black") + 
  ggtitle(expression(" ")) + 
  xlab("") + ylab("Mean Payment to Loser") + 
  theme_bw() + 
  theme(
    axis.text = element_text(size = 20),
    axis.title = element_text(size = 20, face = "bold")
  ) +
  scale_x_discrete(labels = c("31" = "Addition", "62" = "Redistribution")) +
  geom_segment(aes(x = 1, xend = 2, y = max(mean + se) + 0.05, yend = max(mean + se) + 0.05), 
               color = "black", size = 0.5) +
  geom_text(aes(x = 1.5, y = max(mean + se) + 0.1, label = "***"), 
            size = 5, color = "black") 

g

dev.copy(pdf,"../Paper/Figs/payments1.pdf")
dev.off()






t.test(subset(data,StartAlloc==31 & ToWinner1!=0)$PayWinner1,subset(data,StartAlloc==62)$PayWinner1)







# Before Graph Conditions ------------------------------------

graph <- ddply(data,c("Treatment"),summarise,
               mean = round(mean(8-PayWinner1,na.rm=TRUE),digit=2),
               se = sd(8-PayWinner1, na.rm = TRUE) / sqrt(sum(!is.na(8-PayWinner1))))  # Standard Error)

graph$Treatment <- factor(graph$Treatment, levels = c("luck", "sliders","questions"))

g <- ggplot(graph, aes(y = as.numeric(mean), x = as.factor(Treatment))) + 
  geom_bar(width = 0.4, stat = "identity", position = "dodge", fill = "lightblue") + 
  coord_cartesian(ylim = c(2, 4)) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2, color = "black") + 
  ggtitle(expression(" ")) + 
  xlab("") + ylab("Mean Payment to Loser") + 
  theme_bw() + 
  theme(
    axis.text = element_text(size = 20),
    axis.title = element_text(size = 20, face = "bold"))+
  theme(axis.ticks.x = element_blank()) + 
  scale_x_discrete(labels = c("luck" = "Luck", "sliders" = "Effort", "questions" = "Talent")) +
  geom_segment(aes(x = 1, xend = 2, y = max(graph$mean + graph$se) + 0.05, yend = max(graph$mean + graph$se) + 0.05),
               color = "black", size = 0.5) +  # Line connecting bars
  geom_text(aes(x = 1.5, y = max(graph$mean + graph$se) + 0.1, label = "*"), 
            size = 5, color = "black")+  # Add significance stars above the line
  geom_segment(aes(x = 1, xend = 3, y = max(graph$mean + graph$se) + 0.15, yend = max(graph$mean + graph$se) + 0.15),
               color = "black", size = 0.5) +  # Line connecting bars
  geom_text(aes(x = 2, y = max(graph$mean + graph$se) + 0.2, label = "*"), 
            size = 5, color = "black")  # Add significance stars above the line

g

t.test(subset(data,Treatment=="luck")$PayWinner1,subset(data,Treatment=="questions")$PayWinner1)
t.test(subset(data,Treatment=="sliders")$PayWinner1,subset(data,Treatment=="questions")$PayWinner1)
t.test(subset(data,Treatment=="luck")$PayWinner1,subset(data,Treatment=="sliders")$PayWinner1)


dev.copy(pdf,"../Paper/Figs/paymentsCond1.pdf")
dev.off()

# After Graph Redistribution-addition ------------------------------------

graph <- ddply(data,c("StartAlloc"),summarise,
               mean = round(mean(8-PayWinner2,na.rm=TRUE),digit=2),
               se = sd(8-PayWinner2, na.rm = TRUE) / sqrt(sum(!is.na(8-PayWinner2))))  # Standard Error)

graph$StartAlloc <- factor(graph$StartAlloc, levels = c("62", "31"))

g <- ggplot(graph, aes(y = as.numeric(mean), x = as.factor(StartAlloc))) + 
  geom_bar(width = 0.4, stat = "identity", position = "dodge", fill = "lightblue") + 
  coord_cartesian(ylim = c(2, 4)) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2, color = "black") + 
  ggtitle(expression(" ")) + 
  xlab("") + ylab("Mean Payment to Loser") + 
  theme_bw() + 
  theme(
    axis.text = element_text(size = 20),
    axis.title = element_text(size = 20, face = "bold"))+
  theme(axis.ticks.x = element_blank()) + 
  scale_x_discrete(labels = c("31" = "Addition", "62" = "Redistribution")) +
  geom_segment(aes(x = 1, xend = 2, y = max(graph$mean + graph$se) + 0.05, yend = max(graph$mean + graph$se) + 0.05),
               color = "black", size = 0.5) +  # Line connecting bars
  geom_text(aes(x = 1.5, y = max(graph$mean + graph$se) + 0.1, label = "***"), 
            size = 5, color = "black")  # Add significance stars above the line

g



dev.copy(pdf,"../Paper/Figs/payments.pdf")
dev.off()



t.test(subset(data,StartAlloc==31)$PayWinner2,subset(data,StartAlloc==62)$PayWinner2)



# After Graph Conditions ------------------------------------

graph <- ddply(data,c("Treatment"),summarise,
               mean = round(mean(8-PayWinner2,na.rm=TRUE),digit=2),
               se = sd(8-PayWinner2, na.rm = TRUE) / sqrt(sum(!is.na(8-PayWinner2))))  # Standard Error)

graph$Treatment <- factor(graph$Treatment, levels = c("luck", "sliders","questions"))

g <- ggplot(graph, aes(y = as.numeric(mean), x = as.factor(Treatment))) + 
  geom_bar(width = 0.4, stat = "identity", position = "dodge", fill = "lightblue") + 
  coord_cartesian(ylim = c(2, 4)) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2, color = "black") + 
  ggtitle(expression(" ")) + 
  xlab("") + ylab("Mean Payment to Loser") + 
  theme_bw() + 
  theme(
    axis.text = element_text(size = 20),
    axis.title = element_text(size = 20, face = "bold"))+
  theme(axis.ticks.x = element_blank()) + 
  scale_x_discrete(labels = c("luck" = "Luck", "sliders" = "Effort", "questions" = "Talent")) +
  geom_segment(aes(x = 2, xend = 3, y = max(graph$mean + graph$se) + 0.05, yend = max(graph$mean + graph$se) + 0.05),
               color = "black", size = 0.5) +  # Line connecting bars
  geom_text(aes(x = 2.5, y = max(graph$mean + graph$se) + 0.1, label = "***"), 
            size = 5, color = "black")+  # Add significance stars above the line
  geom_segment(aes(x = 1, xend = 3, y = max(graph$mean + graph$se) + 0.15, yend = max(graph$mean + graph$se) + 0.15),
               color = "black", size = 0.5) +  # Line connecting bars
  geom_text(aes(x = 2, y = max(graph$mean + graph$se) + 0.2, label = "***"), 
            size = 5, color = "black")  # Add significance stars above the line

g

t.test(subset(data,Treatment=="luck")$PayWinner2,subset(data,Treatment=="questions")$PayWinner2)
t.test(subset(data,Treatment=="sliders")$PayWinner2,subset(data,Treatment=="questions")$PayWinner2)
t.test(subset(data,Treatment=="luck")$PayWinner2,subset(data,Treatment=="sliders")$PayWinner2)


dev.copy(pdf,"../Paper/Figs/paymentsCond.pdf")
dev.off()














####### Tables 3 and 4---------
library(fixest)
library(texreg)

# Row labels, in the order of the table. Later patterns override earlier ones.
labels <- c(
  "^Age$"                                              = "\\textit{Age}",
  "^(I\\()+Age\\^2\\)+$"                               = "\\textit{Age}$^2$",
  "^Treatmentquestions$"                               = "\\textit{talent}",
  "^Treatmentsliders$"                                 = "\\textit{effort}",
  "^gender"                                            = "\\textit{Male}",
  "^Siblings"                                          = "\\textit{Siblings}",
  "^Topic"                                             = "\\textit{STEM}",
  "^as\\.factor\\(StartAlloc\\)62$"                    = "\\textit{redist.}",
  "^Age:as\\.factor\\(StartAlloc\\)62$|^as\\.factor\\(StartAlloc\\)62:Age$" =
    "\\textit{Age}$\\times$\\textit{redist.}",
  "StartAlloc.*Age\\^2|Age\\^2.*StartAlloc"            = "\\textit{Age}$^2\\times$\\textit{redist.}"
)

# fixest -> texreg, with the session-clustered standard errors
to_texreg <- function(m, d) {
  ct  <- coeftable(m)
  old <- rownames(ct)
  new <- old
  for (p in names(labels)) new[grepl(p, old)] <- labels[[p]]
  createTexreg(
    coef.names  = new,
    coef        = unname(ct[, "Estimate"]),
    se          = unname(ct[, "Std. Error"]),
    pvalues     = unname(ct[, "Pr(>|t|)"]),
    gof.names   = c("Num. obs.", "Num. groups FE", "Num. clusters SE", "R$^2$", "Adj. R$^2$"),
    gof         = c(nobs(m),
                    unname(m$fixef_sizes[1]),
                    length(unique(d$SessionCode[obs(m)])),
                    unname(r2(m, "r2")), unname(r2(m, "ar2"))),
    gof.decimal = c(FALSE, FALSE, FALSE, TRUE, TRUE)
  )
}

# One table: redistribution (linear, quadratic), addition (linear, quadratic),
# pooled with age-by-redistribution interactions (linear, quadratic).
# decision = 1 for the initial allocation, 2 for the final allocation.
age_table <- function(decision, file, caption, label) {
  lhs <- paste0("8 - PayWinner", decision)
  rec <- data[[paste0("ToWinner", decision)]] != 0        # choice recorded (addition)
  d62  <- data[data$Age < 225 & data$StartAlloc == 62, ]
  d31  <- data[data$Age < 225 & data$StartAlloc == 31 & rec, ]
  dall <- rbind(d62, d31)
  
  ctrl <- "Treatment + gender + Siblings + Topic"
  fit <- function(rhs, d) {
    feols(as.formula(paste(lhs, "~", rhs, "+", ctrl, "| Campus")), data = d, vcov = ~ SessionCode)
  }
  specs <- list(
    list("Age",                                                             d62),
    list("Age + I(Age^2)",                                                  d62),
    list("Age",                                                             d31),
    list("Age + I(Age^2)",                                                  d31),
    list("Age * as.factor(StartAlloc)",                                     dall),
    list("Age * as.factor(StartAlloc) + I(Age^2) * as.factor(StartAlloc)",  dall)
  )
  fits   <- lapply(specs, function(s) fit(s[[1]], s[[2]]))
  models <- Map(function(m, s) to_texreg(m, s[[2]]), fits, specs)
  
  tab <- texreg(
    models,
    custom.model.names = c("Redistribution", "Redistribution", "Addition", "Addition", "All", "All"),
    custom.coef.map    = as.list(setNames(unname(labels), unname(labels))),
    stars              = c(0.01, 0.05, 0.1),
    digits             = 3,
    booktabs           = TRUE,
    dcolumn            = FALSE,
    use.packages       = FALSE,
    fontsize           = "footnotesize",
    float.pos          = "htpb",
    caption            = caption,
    caption.above      = FALSE,
    label              = label
  )
  tab <- sub("\\tiny{", "\\footnotesize{", tab, fixed = TRUE)   # note in the size of the table
  writeLines(tab, file)
  invisible(fits)
}

fits3 <- age_table(1, "../Paper/Figs/Table3.tex",
                   "\\textit{Initial} allocation to the loser by treatments and age",
                   "table-age-initial")
fits4 <- age_table(2, "../Paper/Figs/Table4.tex",
                   "\\textit{Final} allocation to the loser by treatments and age",
                   "table-age-final")




####### Figures 5 and 6 -------


# Quadratic best fit of the allocation to the loser on age, by winner selection
# method, on the samples of Tables 3 and 4.
# env = 62 (redistribution) or 31 (addition); addition drops unrecorded choices.
# decision = 1 (initial allocation, Figure 5) or 2 (final allocation, Figure 6).
# legend_size and axis_size reproduce the font sizes of each figure.
age_curve <- function(env, file, decision = 1, legend_size = 20, axis_size = 20) {
  pay <- data[[paste0("PayWinner", decision)]]
  rec <- data[[paste0("ToWinner", decision)]] != 0
  d <- if (env == 62) data[data$Age < 225 & data$StartAlloc == 62, ] else
    data[data$Age < 225 & data$StartAlloc == 31 & rec, ]
  d$loser <- 8 - pay[as.integer(rownames(d))]
  fit <- lm(loser ~ Age + I(Age^2) + Treatment, data = d)
  
  out <- d %>% select(X, Age, Treatment)
  out$predic <- predict(fit, type = "response")
  colnames(out) <- c("X", "age", "Treatment", "predic")
  out <- out %>%
    mutate(
      Treatment1 = recode(Treatment,
                          "sliders"   = "Effort",
                          "luck"      = "Luck",
                          "questions" = "Talent"),
      Treatment1 = factor(Treatment1, levels = c("Luck", "Talent", "Effort")),
      age2 = age / 12
    ) %>%
    filter(age2 > 6)
  
  g <- ggplot(out, aes(x = as.numeric(as.character(age2)), y = predic, color = Treatment1)) +
    ylim(2, 4) +
    geom_point(size = 1) +
    geom_smooth(se = FALSE, method = "loess") +
    xlab("Age") +
    ylab("Total amount for loser") +
    theme_bw() +
    ggtitle(" ") +
    scale_color_manual(values = c("Luck" = "grey",
                                  "Effort" = "dodgerblue",
                                  "Talent" = "gold"), name = " ") +
    theme(
      legend.title = element_text(size = 15),
      legend.text  = element_text(size = legend_size),
      axis.text    = element_text(size = axis_size),
      axis.title   = element_text(size = 20, face = "bold")
    ) +
    scale_x_continuous(breaks = c(6, 9, 12, 15, 18))
  print(g)
  ggsave(file, g, width = 7, height = 7)
  invisible(fit)
}

fit62 <- age_curve(62, "../Paper/Figs/redistribution1.pdf")   # Figure 5a
fit31 <- age_curve(31, "../Paper/Figs/addition1.pdf")         # Figure 5b
fit62f <- age_curve(62, "../Paper/Figs/redistribution.pdf", decision = 2, legend_size = 12, axis_size = 15)   # Figure 6a
fit31f <- age_curve(31, "../Paper/Figs/addition.pdf",       decision = 2, legend_size = 12, axis_size = 15)   # Figure 6b




####### Table 5 ----
library(nnet)
library(sandwich)
library(multiwayvcov)

# sandwich methods for multinom objects, defined only if the installed
# sandwich lacks them (needed by vcovCL on the multinomial models).
if (is.null(getS3method("estfun", "multinom", optional = TRUE))) {
  estfun.multinom <- function(x, ...) {
    X <- model.matrix(terms(x), x$model)
    Y <- model.response(x$model)
    P <- fitted(x)
    Y <- sapply(colnames(P), function(k) as.numeric(Y == k))
    cls <- rownames(coef(x))                       # non-baseline classes
    S <- do.call(cbind, lapply(cls, function(k) (Y[, k] - P[, k]) * X))
    colnames(S) <- as.vector(t(outer(cls, colnames(X), paste, sep = ":")))
    S
  }
  bread.multinom <- function(x, ...) nrow(x$model) * vcov(x)
}

# Settings 
age_unit     <- "years"                      # "years" in every column, or "months"
# in the Poisson columns as in the original code
cluster_vars <- c("SessionCode", "Campus")   # two-way clustering; c("SessionCode") for session only

# Samples 
prep <- function(d) {
  d$howHard5[d$howHard5 %in% c("", NA)] <- NA           # blanks are missing answers
  d$howWell5[d$howWell5 %in% c("", NA)] <- NA
  d$Treatment  <- relevel(factor(d$Treatment), ref = "sliders")
  d$howHard5   <- relevel(factor(d$howHard5),  ref = "Medium")
  d$howWell5   <- relevel(factor(d$howWell5),  ref = "Same")
  d$ChangeWabs <- abs(d$ChangeW)
  d$AgeY       <- d$Age / 12
  droplevels(d)
}
base62 <- with(data, Age < 225 & Treatment != "luck" & StartAlloc == 62)
base31 <- with(data, Age < 225 & Treatment != "luck" & StartAlloc == 31 &
                 ToWinner1 != 0 & ToWinner2 != 0)
sample_of <- function(base, type) prep(data[base & data$ToWinner1Type == type, ])

ctrl   <- "gender + Siblings + Topic + Treatment + howHard5 + howWell5"
rhs_m  <- paste("Age + I(Age^2) +", ctrl)      # months
rhs_y  <- paste("AgeY + I(AgeY^2) +", ctrl)    # years
rhs_p  <- if (age_unit == "years") rhs_y else rhs_m   # Poisson columns

# Poisson column: coefficients, two-way clustered SE (session, campus) 
pois_col <- function(d, lhs) {
  m <- glm(as.formula(paste(lhs, "~", rhs_p)), family = poisson, data = d)
  V <- cluster.vcov(m, as.matrix(d[, cluster_vars]))
  list(b = coef(m), se = sqrt(diag(V)), n = nobs(m), aic = AIC(m), years = age_unit == "years")
}

# Multinomial: two columns (-1 and +1 against no change), same clustering 
mnl_cols <- function(d) {
  d$ChangeW <- relevel(factor(d$ChangeW), ref = "0")
  f  <- as.formula(paste("ChangeW ~", rhs_y))
  m  <- multinom(f, data = d, trace = FALSE, model = TRUE, Hess = TRUE)
  mf <- model.frame(f, d)
  cl <- d[rownames(mf), cluster_vars, drop = FALSE]
  V  <- vcovCL(m, cluster = cl, type = "HC1")
  B  <- coef(m)
  nm <- as.vector(t(outer(rownames(B), colnames(B), paste, sep = ":")))
  b  <- setNames(as.vector(t(B)), nm)[colnames(V)]
  se <- sqrt(diag(V))[names(b)]
  lapply(c("-1", "1"), function(k) {
    idx <- startsWith(names(b), paste0(k, ":"))
    keep <- sub("^-?1:", "", names(b)[idx])
    list(b = setNames(b[idx], keep), se = setNames(se[idx], keep),
         n = nrow(mf), aic = AIC(m), years = TRUE)
  })
}

cols_for <- function(base) {
  c(list(pois_col(sample_of(base, "2-Rep"),  "ChangeWabs")),   # Merit.
    mnl_cols(sample_of(base, "1-Soc")),                        # Equit. (-1), (+1)
    list(pois_col(sample_of(base, "3-Comm"), "ChangeW")))      # Comp.
}
cols <- c(cols_for(base62), cols_for(base31))

# LaTeX 
# Rows: a regular expression for the coefficient name, and the label printed.
# Patterns rather than exact names, so that Siblings, Topic and howHard5 can be
# factors with any level labels (e.g. SiblingsYes, howHard5Difficult).
rows <- c("^AgeY?$"                 = "\\textit{Age}",
          "^I\\(AgeY?\\^2\\)$"      = "\\textit{Age}$^2$",
          "^gender"                 = "\\textit{Male}",
          "^Siblings"               = "\\textit{Siblings}",
          "^Topic"                  = "\\textit{STEM}",
          "^Treatmentquestions$"    = "\\textit{Talent}",
          "^howWell5Better$"        = "\\textit{Better}",
          "^howWell5Worse$"         = "\\textit{Worse}",
          "^howHard5(?!Easy$)."     = "\\textit{Hard}",
          "^howHard5Easy$"          = "\\textit{Easy}",
          "^\\(Intercept\\)$"       = "Constant")
term_of <- function(col, key) {       # the coefficient name behind each row
  hit <- grep(key, names(col$b), perl = TRUE, value = TRUE)
  if (length(hit) > 1) stop("row pattern '", key, "' matches several coefficients: ", paste(hit, collapse = ", "))
  if (length(hit) == 0) NA_character_ else hit
}
stars <- function(p) ifelse(p < 0.01, "^{***}", ifelse(p < 0.05, "^{**}", ifelse(p < 0.1, "^{*}", "")))
fmt   <- function(x, dg) formatC(x, format = "f", digits = dg)

cell <- function(col, key) {
  tm <- term_of(col, key)
  if (is.na(tm)) return(c("", ""))
  b <- col$b[[tm]]; se <- col$se[[tm]]
  p  <- 2 * pnorm(-abs(b / se))
  dg <- if (grepl("2", key) && !col$years) 5 else 3        # Age^2 in months needs 5 decimals
  c(paste0("$", fmt(b, dg), stars(p), "$"), paste0("($", fmt(se, dg), "$)"))
}

lines <- c(
  "\\begin{table}[htpb]",
  "\\centering",
  "\\footnotesize",
  "\\setlength{\\tabcolsep}{5pt}",
  "\\begin{tabular}{l cccc | cccc}",
  "\\toprule",
  " & \\multicolumn{4}{c}{\\textit{redistribution}} & \\multicolumn{4}{c}{\\textit{addition}} \\\\",
  "\\cmidrule(lr){2-5} \\cmidrule(lr){6-9}",
  paste(" &", paste(rep(c("Merit.", "\\shortstack{Equit.\\\\($-1$)}", "\\shortstack{Equit.\\\\($+1$)}", "Comp."), 2), collapse = " & "), "\\\\"),
  "\\midrule"
)
for (key in names(rows)) {
  cells <- sapply(cols, cell, key = key)
  lines <- c(lines,
             paste(rows[[key]], "&", paste(cells[1, ], collapse = " & "), "\\\\"),
             paste("           &", paste(cells[2, ], collapse = " & "), "\\\\"))
}
lines <- c(lines,
           "\\midrule",
           paste("Obs. &", paste(sapply(cols, `[[`, "n"), collapse = " & "), "\\\\"),
           paste("AIC  &", paste(sapply(cols, function(x) round(x$aic)), collapse = " & "), "\\\\"),
           "\\bottomrule",
           paste0("\\multicolumn{9}{l}{\\footnotesize $^{***}p<0.01$; $^{**}p<0.05$; $^{*}p<0.1$. ",
                  if (age_unit == "years") "Age in years. " else
                    "Age in months in the Poisson columns and in years in the multinomial columns. ",
                  "SE clustered by ", paste(tolower(sub("Code", "", cluster_vars)), collapse = " and "), ".}"),
           "\\end{tabular}",
           "\\caption{Poisson and multinomial regressions of change in allocation to winner as a function of initial choice (meritocratic, equitable, compensatory) by treatment.}",
           "\\label{fig-change-all}",
           "\\end{table}"
)
writeLines(lines, "../Paper/Figs/Table5.tex")



####### Figure 7 ----

# Big 5 --------------------------------------------------------------

data_Big <- subset(data, !(BigE == 0 | BigN == 0 | BigA == 0 | BigO == 6 | BigC == 6))

Perso1 <- ddply(data_Big,c("grade1"),summarise,
                mean = mean(na.omit(BigE)),
                Trait="Extraversion")
Perso1<-na.omit(Perso1)

Perso2 <- ddply(data_Big,c("grade1"),summarise,
                mean = mean(na.omit(BigA)),
                Trait="Agreeableness")
Perso2<-na.omit(Perso2)

Perso3 <- ddply(data_Big,c("grade1"),summarise,
                mean = mean(na.omit(BigC)),
                Trait="Conscientiousness")
Perso3<-na.omit(Perso3)

Perso4 <- ddply(data_Big,c("grade1"),summarise,
                mean = mean(na.omit(BigN)),
                Trait="Neuroticism")
Perso<-na.omit(Perso4)

Perso5 <- ddply(data_Big,c("grade1"),summarise,
                mean = mean(na.omit(BigO)),
                Trait="Openness")
Perso<-na.omit(Perso5)

Perso<-rbind(Perso1,Perso2,Perso3,Perso4,Perso5)
colnames(Perso)<-c("Grade","mean","Trait")

Perso$Grade<-factor(Perso$Grade, levels=c("1","2","3","4","5","6","7","8","9","10","11","12"))
levels(Perso$Grade)<-c("1","2","3","4","5","6","7","8","9","10","11","12")

graph<-ggplot(data=Perso, aes(x=Grade, y=mean, colour = factor(Trait))) +
  geom_point(show.legend = FALSE)+facet_grid(cols = vars(Trait))+
  theme(aspect.ratio=2)+
  xlab("Grade")+ylab("mean score")+theme(axis.text=element_text(size=6),axis.title=element_text(size=10,face="bold"))

graph


dev.copy(pdf,"../Paper/Figs/fig-big5-score.pdf")
dev.off()


#  DeRMET ------------------------------------------------------------



data$scoreTom2[data$scoreTom<=5]<-"0-5"
data$scoreTom2[data$scoreTom==6]<-"6"
data$scoreTom2[data$scoreTom==7]<-"7"
data$scoreTom2[data$scoreTom==8]<-"8"
data$scoreTom2[data$scoreTom==9]<-"9"
data$scoreTom2[data$scoreTom==10]<-"10"
data$scoreTom2[data$scoreTom==11]<-"11"
data$scoreTom2[data$scoreTom==12]<-"12"
data$scoreTom2[data$scoreTom==13]<-"13"
data$scoreTom2[data$scoreTom==14]<-"14"
data$scoreTom2[data$scoreTom==15]<-"15"
data$scoreTom2[data$scoreTom==16]<-"16"

table<-as.data.frame(prop.table(table(data$scoreTom2,data$grade1),2))


colnames(table)<-c("Score","Grade","Percentage")

table$Grade<-factor(table$Grade, levels=c("1","2","3","4","5","6","7","8","9","10","11","12"))
levels(table$Grade)<-c("1","2","3","4","5","6","7","8","9","10","11","12")

table$Score<-factor(table$Score, levels=c("0-5","6","7","8","9","10","11","12","13","14","15","16"))
levels(table$Score)<-c("0-5","6","7","8","9","10","11","12","13","14","15","16")
table$Percentage<-table$Percentage*100


ToM <- ddply(data,c("grade1"),summarise,
             mean = mean(na.omit(scoreTom)))
ToM<-na.omit(ToM)
ToM$grade1<-factor(ToM$grade1, levels=c("1","2","3","4","5","6","7","8","9","10","11","12"))
levels(ToM$grade1)<-c("1","2","3","4","5","6","7","8","9","10","11","12")









g<-ggplot(table, aes(y=Percentage, x=as.factor(Grade), fill=as.factor(Score)))+
  geom_bar(width=0.6,stat="identity",color = "black")+ggtitle(label=" ", subtitle= "  ")+
  labs(fill="Correct ToM")+ylab("Percentage")+xlab("Grade")+
  theme_minimal()+theme(axis.ticks.x=element_blank())+scale_fill_manual(values=c("#9E0142","#D53E4F","#F46D43","#FDAE61","#FEE08B","#FFFFBF","#E6F598","#ABDDA4","#66C2A5","#3288BD","#2166AC","#5E4FA2"),name="Correct")+
  theme(plot.title = element_text(size = 25, face = "bold"),plot.subtitle = element_text(size = 25, face = "bold"),legend.title=element_text(size=20),legend.text=element_text(size=20))+
  theme(axis.text=element_text(size=15),axis.title=element_text(size=20,face="bold"))
g

g+annotate(geom = "text", x = 1, y = 102, label = round(subset(ToM,grade1==1)$mean,1), hjust = "center",size=3)+
  annotate(geom = "text", x = 2, y = 102, label = round(subset(ToM,grade1==2)$mean,1), hjust = "center",size=3)+
  annotate(geom = "text", x = 3, y = 102, label = round(subset(ToM,grade1==3)$mean,1), hjust = "center",size=3)+
  annotate(geom = "text", x = 4, y = 102, label = round(subset(ToM,grade1==4)$mean,1), hjust = "center",size=3)+
  annotate(geom = "text", x = 5, y = 102, label = round(subset(ToM,grade1==5)$mean,1), hjust = "center",size=3)+
  annotate(geom = "text", x = 6, y = 102, label = round(subset(ToM,grade1==6)$mean,1), hjust = "center",size=3)+
  annotate(geom = "text", x = 7, y = 102, label = round(subset(ToM,grade1==7)$mean,1), hjust = "center",size=3)+
  annotate(geom = "text", x = 8, y = 102, label = round(subset(ToM,grade1==8)$mean,1), hjust = "center",size=3)+
  annotate(geom = "text", x = 9, y = 102, label = round(subset(ToM,grade1==9)$mean,1), hjust = "center",size=3)+
  annotate(geom = "text", x = 10, y = 102, label = round(subset(ToM,grade1==10)$mean,1), hjust = "center",size=3)+
  annotate(geom = "text", x = 11, y = 102, label = round(subset(ToM,grade1==11)$mean,1), hjust = "center",size=3)+
  annotate(geom = "text", x = 12, y = 102, label = round(subset(ToM,grade1==12)$mean,1), hjust = "center",size=3)


dev.copy(pdf,"../Paper/Figs/fig-tom-dist.pdf")
dev.off()



####### Table 6 ----

library(nnet)
library(sandwich)

# sandwich methods for multinom objects, defined only if the installed
# sandwich lacks them (needed by vcovCL on multinomial models).
if (is.null(getS3method("estfun", "multinom", optional = TRUE))) {
  estfun.multinom <- function(x, ...) {
    X <- model.matrix(terms(x), x$model)
    Y <- model.response(x$model)
    P <- fitted(x)
    Y <- sapply(colnames(P), function(k) as.numeric(Y == k))
    cls <- rownames(coef(x))
    S <- do.call(cbind, lapply(cls, function(k) (Y[, k] - P[, k]) * X))
    colnames(S) <- as.vector(t(outer(cls, colnames(X), paste, sep = ":")))
    S
  }
  bread.multinom <- function(x, ...) nrow(x$model) * vcov(x)
}

# Settings 
cluster_vars <- c("SessionCode", "Campus")   # c("SessionCode") for session only
resid_rhs    <- "AgeY"                       # scores are residualised on this

# Sample: data_Big, age cutoff, both choices recorded 
d <- data_Big
d$AgeY <- d$Age / 12
d <- d[d$Age < 225 & (d$StartAlloc == 62 | (d$ToWinner1 != 0 & d$ToWinner2 != 0)), ]

# Trait residuals 
traits <- c(DeRMET = "scoreTom", Extraversion = "BigE", Agreeableness = "BigA",
            Conscientiousness = "BigC", Neuroticism = "BigN", Openness = "BigO")
for (t in names(traits)) {
  d[[paste0(t, "_r")]] <- resid(lm(as.formula(paste(traits[[t]], "~", resid_rhs)), data = d, na.action = na.exclude))
}

# Choice categories: (6,2) Merit, (5,3) Equit (reference), (4,4) Comp 
choice <- function(start, tw) {
  ifelse(start == 62,
         c("0" = "Merit", "-1" = "Equit", "-2" = "Comp")[as.character(tw)],
         c("3" = "Merit",  "2" = "Equit",  "1" = "Comp")[as.character(tw)])
}
d$choice1 <- relevel(factor(choice(d$StartAlloc, d$ToWinner1)), ref = "Equit")
d$choice2 <- relevel(factor(choice(d$StartAlloc, d$ToWinner2)), ref = "Equit")
d$redistribution <- as.numeric(d$StartAlloc == 62)
d$Treatment <- relevel(factor(d$Treatment), ref = "sliders")   # effort is the reference

rhs <- paste("AgeY + I(AgeY^2) + gender + Siblings + Topic +",
             paste(paste0(names(traits), "_r"), collapse = " + "),
             "+ redistribution + Treatment")

# Multinomial logit with clustered SE; returns the Merit and Comp columns 
mnl_cols <- function(lhs) {
  f  <- as.formula(paste(lhs, "~", rhs))
  m  <- multinom(f, data = d, trace = FALSE, model = TRUE, Hess = TRUE, maxit = 500)
  mf <- model.frame(f, d)
  cl <- d[rownames(mf), cluster_vars, drop = FALSE]
  V  <- vcovCL(m, cluster = cl, type = "HC1")
  B  <- coef(m)
  nm <- as.vector(t(outer(rownames(B), colnames(B), paste, sep = ":")))
  b  <- setNames(as.vector(t(B)), nm)[colnames(V)]
  se <- sqrt(diag(V))[names(b)]
  lapply(c("Merit", "Comp"), function(k) {
    idx  <- startsWith(names(b), paste0(k, ":"))
    keep <- sub("^[^:]+:", "", names(b)[idx])
    list(b = setNames(b[idx], keep), se = setNames(se[idx], keep), n = nrow(mf), aic = AIC(m))
  })
}
cols <- c(mnl_cols("choice1"), mnl_cols("choice2"))

# LaTeX 
rows <- c("^AgeY$"                 = "\\textit{Age}",
          "^I\\(AgeY\\^2\\)$"      = "\\textit{Age}$^2$",
          "^gender"                = "\\textit{Male}",
          "^Siblings"              = "\\textit{Siblings}",
          "^Topic"                 = "\\textit{STEM}",
          "^DeRMET_r$"             = "DeRMET (resid)",
          "^Extraversion_r$"       = "Extraversion (resid)",
          "^Agreeableness_r$"      = "Agreeableness (resid)",
          "^Conscientiousness_r$"  = "Conscientiousness (resid)",
          "^Neuroticism_r$"        = "Neuroticism (resid)",
          "^Openness_r$"           = "Openness (resid)",
          "^redistribution$"       = "\\textit{redistribution}",
          "^Treatmentluck$"        = "\\textit{luck}",
          "^Treatmentquestions$"   = "\\textit{talent}",
          "^\\(Intercept\\)$"      = "Constant")
term_of <- function(col, key) {
  hit <- grep(key, names(col$b), perl = TRUE, value = TRUE)
  if (length(hit) > 1) stop("row pattern '", key, "' matches several coefficients: ", paste(hit, collapse = ", "))
  if (length(hit) == 0) NA_character_ else hit
}
stars <- function(p) ifelse(p < 0.01, "^{***}", ifelse(p < 0.05, "^{**}", ifelse(p < 0.1, "^{*}", "")))
fmt   <- function(x, dg = 3) formatC(x, format = "f", digits = dg)
cell  <- function(col, key) {
  tm <- term_of(col, key)
  if (is.na(tm)) return(c("", ""))
  b <- col$b[[tm]]; se <- col$se[[tm]]; p <- 2 * pnorm(-abs(b / se))
  c(paste0("$", fmt(b), stars(p), "$"), paste0("($", fmt(se), "$)"))
}

lines <- c(
  "\\begin{table}[htpb]",
  "\\centering",
  "\\footnotesize",
  "\\begin{threeparttable}",
  "\\begin{tabular}{l cc cc}",
  "\\toprule",
  " & \\multicolumn{2}{c}{Initial choice} & \\multicolumn{2}{c}{Final choice} \\\\",
  "\\cmidrule(lr){2-3} \\cmidrule(lr){4-5}",
  " & Merit. & Comp. & Merit. & Comp. \\\\",
  "\\midrule"
)
for (key in names(rows)) {
  cells <- sapply(cols, cell, key = key)
  lines <- c(lines,
             paste(rows[[key]], "&", paste(cells[1, ], collapse = " & "), "\\\\"),
             paste("           &", paste(cells[2, ], collapse = " & "), "\\\\"))
}
lines <- c(lines,
           "\\midrule",
           paste("Obs. &", paste(sapply(cols, `[[`, "n"), collapse = " & "), "\\\\"),
           paste("AIC  &", paste(sapply(cols, function(x) formatC(round(x$aic), format = "d", big.mark = ",")), collapse = " & "), "\\\\"),
           "\\bottomrule",
           "\\end{tabular}",
           "\\begin{tablenotes}[flushleft]\\footnotesize",
           paste0("\\item $^{***}p<0.01$; $^{**}p<0.05$; $^{*}p<0.1$. ",
                  "Reference categories: equitable choice, effort, addition. Age in years. ",
                  "SE clustered by ", paste(tolower(sub("Code", "", cluster_vars)), collapse = " and "), "."),
           "\\end{tablenotes}",
           "\\end{threeparttable}",
           "\\caption{Multinomial regressions of meritocratic and compensatory initial and final choices: the effect of emotional intelligence and personality}",
           "\\label{table-ToMandBig5}",
           "\\end{table}"
)
writeLines(lines, "../Paper/Figs/table6.tex")




######## Appendix B1-----

library(dplyr)
library(tidyr)
library(xtable)

desired_order <- c("Early Elem.", "Late Elem.", "Early Middle", "Late Middle","High School")  # Modify accordingly
data$grade2 <- factor(data$grade2, levels = desired_order)


# Compute categorical summaries (extract only the required categories)
categorical_summary <- function(df, variable, grade_column, target_category,variable_label) {
  tab <- round(prop.table(table(df[[variable]], df[[grade_column]]), 2) * 100,2)
  tab <- as.data.frame.matrix(tab)
  
  if (target_category %in% rownames(tab)) {
    selected_row <- tab[target_category, , drop = FALSE]  # Select only the row of interest
  } else {
    selected_row <- data.frame(matrix(0, nrow = 1, ncol = ncol(tab)))  # Fill with zeros if missing
    colnames(selected_row) <- colnames(tab)
  }
  
  # Convert to data frame and ensure `Variable` is the first column
  selected_row <- as.data.frame(selected_row)
  selected_row$Variable <- variable_label  # Assign readable variable name
  selected_row <- selected_row %>%
    relocate(Variable, .before = everything())  # Move `Variable` to the first column
  
  return(selected_row)
}

# Compute percentage of Males, Siblings = Yes, and STEM (Math or Science)
gender_summary <- categorical_summary(data, "gender", "grade2", "M","% Male")
siblings_summary <- categorical_summary(data, "Siblings", "grade2", "Yes","% Siblings")
topic_summary <- categorical_summary(data, "Topic", "grade2", "STEM","% STEM")


# Compute mean and SD for continuous variables
numerical_summary_base <- function(df, variable, grade_column, variable_label) {
  agg_result <- aggregate(df[[variable]], by = list(df[[grade_column]]), 
                          FUN = function(x) c(mean = mean(x, na.rm = TRUE), sd = sd(x, na.rm = TRUE)))
  
  # Convert the matrix in the second column to separate columns
  summary_df <- data.frame(agg_result[[1]], agg_result[[2]])
  
  # Rename columns
  colnames(summary_df) <- c(grade_column, "mean", "sd")
  
  # Format as "mean (sd)"
  summary_df <- summary_df %>%
    mutate(stat = paste0(round(mean, 2), " (", round(sd, 2), ")")) %>%
    select(-mean, -sd)  # Drop the separate mean and SD columns
  
  # Reshape to wide format
  summary_df <- summary_df %>%
    pivot_wider(names_from = grade_column, values_from = stat)
  
  # Convert to a proper data frame to avoid tibble issues
  summary_df <- as.data.frame(summary_df)
  
  # Add the Variable column explicitly as the first column
  summary_df <- summary_df %>%
    mutate(Variable = variable_label) %>%
    relocate(Variable)
  
  return(summary_df)
}

test<-subset(data,(StartAlloc=="62")|(StartAlloc=="31"& ToWinner2 !=0 & ToWinner1 !=0))

# Compute numerical summaries with custom variable names
to_loser1_summary <- numerical_summary_base(test, "PayWinner1", "grade2", "Pay Winner Before")
to_loser2_summary <- numerical_summary_base(test, "PayWinner2", "grade2", "Pay Winner After")
score_tom_summary <- numerical_summary_base(data, "scoreTom", "grade2", "ScoreTom")
big1_summary <- numerical_summary_base(data_Big, "BigE", "grade2", "Extraversion")
big2_summary <- numerical_summary_base(data_Big, "BigA", "grade2", "Agreeableness")
big3_summary <- numerical_summary_base(data_Big, "BigC", "grade2", "Conscientiousness")
big4_summary <- numerical_summary_base(data_Big, "BigN", "grade2", "Neuroticism")
big5_summary <- numerical_summary_base(data_Big, "BigO", "grade2", "Openness")

# Combine all summaries into one table
final_tableCat <- bind_rows(
  gender_summary, siblings_summary, topic_summary)

final_tableCont<-bind_rows(
  to_loser1_summary, to_loser2_summary, score_tom_summary,
  big1_summary, big2_summary, big3_summary, big4_summary, big5_summary
)

final_table<-rbind(final_tableCat,final_tableCont)

# Convert back to a data frame to ensure no issues
final_table <- as.data.frame(final_table)

# Remove row names (index column) without affecting `Variable`
rownames(final_table) <- NULL  # This removes the printed index column

# Rename "Variable" as row names for readability
rownames(final_table) <- final_table$Variable
final_table <- final_table[, -1]  # Remove "Variable" column

# Export as LaTeX
latex_table <- xtable(final_table, caption = "Summary Statistics by Age Group - mean (standard deviation)", label = "tab:summary")
print(latex_table, type = "latex", file = "../Paper/Figs/summary_table.tex", include.rownames = TRUE)




######## Appendix B2-----
library(fixest)
library(texreg)

# Samples 
df1 <- subset(data, Age < 225 & (StartAlloc == 62 | (StartAlloc == 31 & ToWinner1 != 0)))
df2 <- subset(data, Age < 225 & (StartAlloc == 62 | (StartAlloc == 31 & ToWinner2 != 0)))
df1$redist <- as.numeric(df1$StartAlloc == 62)
df2$redist <- as.numeric(df2$StartAlloc == 62)

# Models 
# (1) treatment-by-gender interactions; (2) full treatment-by-environment-by-gender interactions
rhs <- c(
  "Age + I(Age^2) + Treatment * gender + redist + Siblings + Topic",
  "Age + I(Age^2) + Treatment * redist * gender + Siblings + Topic"
)
fit <- function(r, lhs, d) {
  feols(as.formula(paste(lhs, "~", r, "| Campus")), data = d, vcov = ~ SessionCode)
}
initial <- lapply(rhs, fit, lhs = "8 - PayWinner1", d = df1)
final   <- lapply(rhs, fit, lhs = "8 - PayWinner2", d = df2)

# Row labels, in the order of the table 
labels <- c(
  "^Age$"                              = "\\textit{Age}",
  "^(I\\()+Age\\^2\\)+$"               = "\\textit{Age}$^2$",
  "^Treatmentquestions$"               = "\\textit{Talent}",
  "^Treatmentsliders$"                 = "\\textit{Effort}",
  "^redist$"                           = "\\textit{Redistribution}",
  "^gender"                            = "\\textit{Male}",
  "^Siblings"                          = "\\textit{Siblings}",
  "^Topic"                             = "\\textit{STEM}",
  "^Treatmentquestions:redist$"        = "\\textit{Redistribution}$\\times$\\textit{Talent}",
  "^Treatmentsliders:redist$"          = "\\textit{Redistribution}$\\times$\\textit{Effort}",
  "^Treatmentquestions:gender"         = "\\textit{Talent}$\\times$\\textit{Male}",
  "^Treatmentsliders:gender"           = "\\textit{Effort}$\\times$\\textit{Male}",
  "^redist:gender"                     = "\\textit{Redistribution}$\\times$\\textit{Male}",
  "^Treatmentquestions:redist:gender"  = "\\textit{Talent}$\\times$\\textit{Redistribution}$\\times$\\textit{Male}",
  "^Treatmentsliders:redist:gender"    = "\\textit{Effort}$\\times$\\textit{Redistribution}$\\times$\\textit{Male}"
)

# fixest -> texreg, with the session-clustered standard errors 
to_texreg <- function(m) {
  ct  <- coeftable(m)
  old <- rownames(ct)
  new <- old
  for (p in names(labels)) new[grepl(p, old)] <- labels[[p]]
  if (any(duplicated(new))) stop("two coefficients received the same label: ", paste(old[duplicated(new) | duplicated(new, fromLast = TRUE)], collapse = ", "))
  createTexreg(
    coef.names  = new,
    coef        = unname(ct[, "Estimate"]),
    se          = unname(ct[, "Std. Error"]),
    pvalues     = unname(ct[, "Pr(>|t|)"]),
    gof.names   = c("Num. obs.", "R$^2$", "Adj. R$^2$"),
    gof         = c(nobs(m), unname(r2(m, "r2")), unname(r2(m, "ar2"))),
    gof.decimal = c(FALSE, TRUE, TRUE)
  )
}
models <- lapply(c(initial, final), to_texreg)

# Note 
n_campus <- length(unique(df1$Campus))
s1 <- length(unique(df1$SessionCode))
s2 <- length(unique(df2$SessionCode))
sessions <- if (s1 == s2) paste0(s1, " sessions") else
  paste0(s1, " sessions initial, ", s2, " final")
note <- paste0("\\item %stars \\item Campus FE (", n_campus, " campuses). ",
               "SE clustered at the session level (", sessions, ").")

# Table 
tab <- texreg(
  models,
  custom.model.names = c("Initial", "Initial", "Final", "Final"),
  custom.coef.map    = as.list(setNames(unname(labels), unname(labels))),
  stars              = c(0.01, 0.05, 0.1),
  digits             = 3,
  booktabs           = TRUE,
  dcolumn            = FALSE,
  use.packages       = FALSE,
  threeparttable     = TRUE,
  fontsize           = "footnotesize",
  float.pos          = "htpb",
  caption            = "Gender effects in the \\textit{initial} and \\textit{final} allocations to the loser.",
  caption.above      = FALSE,
  label              = "regtreatmentGender",
  custom.note        = note
)
tab <- sub("\\tiny{", "\\footnotesize{", tab, fixed = TRUE)   # note in the size of the table
writeLines(tab, "../Paper/Figs/table9.tex")

######## Appendix B3-----

library(fixest)
library(texreg)

# Appendix B3: Tables 10 to 13. Same six specifications as Tables 3 and 4,
# without campus fixed effects, with standard errors clustered at the
# classroom level (Tables 10, 12) or at the classroom and campus levels
# (Tables 11, 13).

# Row labels, in the order of the table. Later patterns override earlier ones.
labels <- c(
  "^Age$"                                              = "\\textit{Age}",
  "^(I\\()+Age\\^2\\)+$"                               = "\\textit{Age}$^2$",
  "^Treatmentquestions$"                               = "\\textit{Talent}",
  "^Treatmentsliders$"                                 = "\\textit{Effort}",
  "^gender"                                            = "\\textit{Male}",
  "^Siblings"                                          = "\\textit{Siblings}",
  "^Topic"                                             = "\\textit{STEM}",
  "^as\\.factor\\(StartAlloc\\)62$"                    = "\\textit{Redistribution}",
  "^Age:as\\.factor\\(StartAlloc\\)62$|^as\\.factor\\(StartAlloc\\)62:Age$" =
    "\\textit{Age}$\\times$\\textit{Redistribution}",
  "StartAlloc.*Age\\^2|Age\\^2.*StartAlloc"            = "\\textit{Age}$^2\\times$\\textit{Redistribution}",
  "^\\(Intercept\\)$"                                  = "\\textit{Constant}"
)

to_texreg <- function(m) {
  ct  <- coeftable(m)
  old <- rownames(ct)
  new <- old
  for (p in names(labels)) new[grepl(p, old)] <- labels[[p]]
  createTexreg(
    coef.names  = new,
    coef        = unname(ct[, "Estimate"]),
    se          = unname(ct[, "Std. Error"]),
    pvalues     = unname(ct[, "Pr(>|t|)"]),
    gof.names   = c("Num. obs.", "R$^2$", "Adj. R$^2$"),
    gof         = c(nobs(m), unname(r2(m, "r2")), unname(r2(m, "ar2"))),
    gof.decimal = c(FALSE, TRUE, TRUE)
  )
}

# decision: 1 initial, 2 final. cluster: "classroom" or "classroom and campus".
age_table_b3 <- function(decision, cluster, file, label) {
  lhs <- paste0("8 - PayWinner", decision)
  rec <- data[[paste0("ToWinner", decision)]] != 0
  d62  <- data[data$Age < 225 & data$StartAlloc == 62, ]
  d31  <- data[data$Age < 225 & data$StartAlloc == 31 & rec, ]
  dall <- rbind(d62, d31)
  vc   <- if (cluster == "classroom") ~ SessionCode else ~ SessionCode + Campus
  
  ctrl <- "Treatment + gender + Siblings + Topic"
  fit <- function(rhs, d) feols(as.formula(paste(lhs, "~", rhs, "+", ctrl)), data = d, vcov = vc)
  specs <- list(
    list("Age",                                                             d62),
    list("Age + I(Age^2)",                                                  d62),
    list("Age",                                                             d31),
    list("Age + I(Age^2)",                                                  d31),
    list("Age * as.factor(StartAlloc)",                                     dall),
    list("Age * as.factor(StartAlloc) + I(Age^2) * as.factor(StartAlloc)",  dall)
  )
  fits <- lapply(specs, function(s) fit(s[[1]], s[[2]]))
  
  when <- if (decision == 1) "Initial" else "Final"
  tab <- texreg(
    lapply(fits, to_texreg),
    custom.model.names = c("Redistribution", "Redistribution", "Addition", "Addition", "All", "All"),
    custom.coef.map    = as.list(setNames(unname(labels), unname(labels))),
    stars              = c(0.01, 0.05, 0.1),
    digits             = 3,
    booktabs           = TRUE,
    dcolumn            = FALSE,
    use.packages       = FALSE,
    fontsize           = "footnotesize",
    float.pos          = "H",
    caption            = paste0("\\textit{", when, "} allocation to the loser by treatments and age with clustered standard errors at the ",
                                cluster, " level", if (cluster == "classroom") "." else "s."),
    caption.above      = FALSE,
    label              = label
  )
  tab <- sub("\\tiny{", "\\footnotesize{", tab, fixed = TRUE)
  writeLines(tab, file)
  invisible(fits)
}

t10 <- age_table_b3(1, "classroom",            "../Paper/Figs/table10.tex", "table-b3-initial-class")
t11 <- age_table_b3(1, "classroom and campus", "../Paper/Figs/table11.tex", "table-b3-initial-both")
t12 <- age_table_b3(2, "classroom",            "../Paper/Figs/table12.tex", "table-b3-final-class")
t13 <- age_table_b3(2, "classroom and campus", "../Paper/Figs/table13.tex", "table-b3-final-both")


######## Appendix B4-----

library(fixest)
library(texreg)

# Appendix B4: Tables 14 and 15. Age groups instead of age in months.
# Table 14: no fixed effects, SE clustered at the classroom level.
# Table 15: campus fixed effects, SE clustered at the classroom level.

data$grade2 <- factor(data$grade2, levels = c("Early Elem.", "Late Elem.", "Early Middle",
                                              "Late Middle", "High School"))

labels <- c(
  "^grade2.*Late Elem"    = "\\textit{Late Elem.}",
  "^grade2.*Early Mid"    = "\\textit{Early Middle}",
  "^grade2.*Late Mid"     = "\\textit{Late Middle}",
  "^grade2.*High"         = "\\textit{High School}",
  "^Treatmentquestions$"  = "\\textit{Talent}",
  "^Treatmentsliders$"    = "\\textit{Effort}",
  "^gender"               = "\\textit{Male}",
  "^Siblings"             = "\\textit{Siblings}",
  "^Topic"                = "\\textit{STEM}",
  "^\\(Intercept\\)$"     = "\\textit{Constant}"
)

to_texreg <- function(m) {
  ct  <- coeftable(m)
  old <- rownames(ct)
  new <- old
  for (p in names(labels)) new[grepl(p, old)] <- labels[[p]]
  createTexreg(
    coef.names  = new,
    coef        = unname(ct[, "Estimate"]),
    se          = unname(ct[, "Std. Error"]),
    pvalues     = unname(ct[, "Pr(>|t|)"]),
    gof.names   = c("Num. obs.", "R$^2$", "Adj. R$^2$"),
    gof         = c(nobs(m), unname(r2(m, "r2")), unname(r2(m, "ar2"))),
    gof.decimal = c(FALSE, TRUE, TRUE)
  )
}

age_group_table <- function(campus_fe, file, caption, label) {
  rhs <- "grade2 + Treatment + gender + Siblings + Topic"
  if (campus_fe) rhs <- paste(rhs, "| Campus")
  fit <- function(decision, env) {
    rec <- data[[paste0("ToWinner", decision)]] != 0
    d <- if (env == 62) data[data$Age < 225 & data$StartAlloc == 62, ] else
      data[data$Age < 225 & data$StartAlloc == 31 & rec, ]
    feols(as.formula(paste0("8 - PayWinner", decision, " ~ ", rhs)), data = d, vcov = ~ SessionCode)
  }
  fits <- list(fit(1, 62), fit(1, 31), fit(2, 62), fit(2, 31))
  
  tab <- texreg(
    lapply(fits, to_texreg),
    custom.header      = list("Initial" = 1:2, "Final" = 3:4),
    custom.model.names = c("Redistribution", "Addition", "Redistribution", "Addition"),
    custom.coef.map    = as.list(setNames(unname(labels), unname(labels))),
    stars              = c(0.01, 0.05, 0.1),
    digits             = 3,
    booktabs           = TRUE,
    dcolumn            = FALSE,
    use.packages       = FALSE,
    fontsize           = "footnotesize",
    float.pos          = "H",
    caption            = caption,
    caption.above      = FALSE,
    label              = label
  )
  tab <- sub("\\tiny{", "\\footnotesize{", tab, fixed = TRUE)
  writeLines(tab, file)
  invisible(fits)
}

t14 <- age_group_table(FALSE, "../Paper/Figs/table14.tex",
                       "Replication of regressions in Tables \\ref{table-age-initial} and \\ref{table-age-final} with age-groups (clusters SE at the classroom level)",
                       "table-b4-noFE")
t15 <- age_group_table(TRUE, "../Paper/Figs/table15.tex",
                       "Replication of regressions in Tables \\ref{table-age-initial} and \\ref{table-age-final} with age-groups (clusters SE at the classroom level and Campus FE)",
                       "table-b4-FE")



######## Appendices B5 and B6-----

library(fixest)
library(dplyr)
library(ggplot2)

# Appendix B5 (redistribution) and B6 (addition): final allocation regressed on
# age separately for each winner selection method. Tables 16 and 17 report the
# OLS estimates (no fixed effects, SE clustered at the session level); Figures 9
# and 10 draw the quadratic best fit of each separate regression.

# Rows: pattern for the coefficient name, printed label, decimals 
rows <- list(
  list("^Age$",                 "Age",       3),
  list("^(I\\()+Age\\^2\\)+$",  "Age$^2$",   5),
  list("^gender",               "Male",      3),
  list("^Siblings",             "Siblings",  3),
  list("^Topic",                "STEM",      3)
)
stars <- function(p) ifelse(p < 0.01, "^{***}", ifelse(p < 0.05, "^{**}", ifelse(p < 0.1, "^{*}", "")))
fmt   <- function(x, dg) formatC(x, format = "f", digits = dg)

cell <- function(m, pattern, dg) {
  ct <- coeftable(m)
  hit <- grep(pattern, rownames(ct), perl = TRUE)
  if (length(hit) != 1) return(c("", ""))
  b <- ct[hit, "Estimate"]; se <- ct[hit, "Std. Error"]; p <- ct[hit, "Pr(>|t|)"]
  c(paste0("$", fmt(b, dg), stars(p), "$"), paste0("($", fmt(se, dg), "$)"))
}

separate_table <- function(env, file, caption, label) {
  envname <- if (env == 62) "redistribution" else "addition"
  d <- if (env == 62) data[data$Age < 225 & data$StartAlloc == 62, ] else
    data[data$Age < 225 & data$StartAlloc == 31 & data$ToWinner2 != 0, ]
  fits <- list()
  for (tr in c("sliders", "questions", "luck")) {
    dt <- d[d$Treatment == tr, ]
    fits[[length(fits) + 1]] <- feols(8 - PayWinner2 ~ Age + I(Age^2), data = dt, vcov = ~ SessionCode)
    fits[[length(fits) + 1]] <- feols(8 - PayWinner2 ~ Age + I(Age^2) + gender + Siblings + Topic, data = dt, vcov = ~ SessionCode)
  }
  lines <- c(
    "\\begin{table}[htpb]",
    "\\centering",
    "\\footnotesize",
    "\\begin{tabular}{l cc cc cc}",
    "\\toprule",
    " & \\multicolumn{2}{c}{\\textit{effort}} & \\multicolumn{2}{c}{\\textit{talent}} & \\multicolumn{2}{c}{\\textit{luck}} \\\\",
    "\\cmidrule(lr){2-3} \\cmidrule(lr){4-5} \\cmidrule(lr){6-7}",
    " & (1) & (2) & (3) & (4) & (5) & (6) \\\\",
    "\\midrule"
  )
  for (r in rows) {
    cells <- sapply(fits, cell, pattern = r[[1]], dg = r[[3]])
    lines <- c(lines,
               paste(r[[2]], "&", paste(cells[1, ], collapse = " & "), "\\\\"),
               paste("        &", paste(cells[2, ], collapse = " & "), "\\\\"))
  }
  lines <- c(lines,
             "\\midrule",
             paste("Obs. &", paste(sapply(fits, nobs), collapse = " & "), "\\\\"),
             paste("Adj. R$^2$ &", paste(sapply(fits, function(m) fmt(r2(m, "ar2"), 3)), collapse = " & "), "\\\\"),
             "\\bottomrule",
             "\\multicolumn{7}{l}{\\footnotesize $^{***}p<0.01$; $^{**}p<0.05$; $^{*}p<0.1$. SE clustered at the session level.}",
             "\\end{tabular}",
             paste0("\\caption{", caption, "}"),
             paste0("\\label{", label, "}"),
             "\\end{table}"
  )
  writeLines(lines, file)
  invisible(d)
}

# Figure: quadratic best fit from the separate regressions (columns 1, 3, 5)
separate_figure <- function(d, file, legend_size = 12, axis_size = 15) {
  d$predic <- NA_real_
  for (tr in c("sliders", "questions", "luck")) {
    i <- d$Treatment == tr
    d$predic[i] <- predict(lm(8 - PayWinner2 ~ Age + I(Age^2), data = d[i, ]))
  }
  out <- d %>%
    mutate(Treatment1 = recode(Treatment, "sliders" = "Effort", "luck" = "Luck", "questions" = "Talent"),
           Treatment1 = factor(Treatment1, levels = c("Luck", "Effort", "Talent")),
           age2 = Age / 12) %>%
    filter(age2 > 6)
  g <- ggplot(out, aes(x = age2, y = predic, color = Treatment1)) +
    ylim(2, 4) +
    geom_point(size = 1) +
    geom_smooth(se = FALSE, method = "loess") +
    xlab("Age") + ylab("Total amount for loser") +
    theme_bw() + ggtitle(" ") +
    scale_color_manual(values = c("Luck" = "grey", "Effort" = "dodgerblue", "Talent" = "gold"), name = " ") +
    theme(legend.title = element_text(size = 15),
          legend.text  = element_text(size = legend_size),
          axis.text    = element_text(size = axis_size),
          axis.title   = element_text(size = 20, face = "bold")) +
    scale_x_continuous(breaks = c(6, 9, 12, 15, 18))
  print(g)
  ggsave(file, g, width = 7, height = 7)
}

d62 <- separate_table(62, "../Paper/Figs/Table16.tex",
                      "OLS regressions of \\textit{final} allocation in the \\textit{redistribution} treatment, performed separately on each winner selection method",
                      "table-b5")
separate_figure(d62, "../Paper/Figs/figure9.pdf")

d31 <- separate_table(31, "../Paper/Figs/Table17.tex",
                      "OLS regressions of \\textit{final} allocation in the \\textit{addition} treatment, performed separately on each winner selection method",
                      "table-b6")
separate_figure(d31, "../Paper/Figs/figure10.pdf")

######## Appendix B7-----
# Appendix B7, part a (Performance)----------
# Needs in `data`: Tom1..Tom16 (answer, asterisk = correct), scoreTom, grade1 (1..12), gender (M/F), Age (months).

d <- data
for (v in c("grade1", "Age", "scoreTom")) d[[v]] <- as.numeric(as.character(d[[v]]))
tom <- paste0("Tom", 1:16)
emotion <- c("confused", "tired", "sad", "disapproving", "happy", "ashamed", "angry", "flirting",
             "excited", "scared", "disgusted", "thinking", "sneaky", "worried", "hopeful", "surprised")

# Mean score by grade (the averages printed on top of Figure 7, left) 
mean_by_grade <- tapply(d$scoreTom, d$grade1, mean, na.rm = TRUE)
cat("Mean DeRMET score by grade:\n"); print(round(mean_by_grade, 2))

# Grades 1 to 5, and 5 to 12: change in the mean and correlation with age 
slope <- function(g1, g2) {
  sub <- d[d$grade1 >= g1 & d$grade1 <= g2, ]
  ct  <- cor.test(sub$scoreTom, sub$Age)
  c(mean_first = round(mean_by_grade[as.character(g1)], 1),
    mean_last  = round(mean_by_grade[as.character(g2)], 1),
    per_grade  = round((mean_by_grade[as.character(g2)] - mean_by_grade[as.character(g1)]) / (g2 - g1), 2),
    PCC        = round(unname(ct$estimate), 2),
    p          = signif(ct$p.value, 2),
    n          = nrow(sub))
}
cat("\nGrades 1 to 5:\n");  print(slope(1, 5))
cat("\nGrades 5 to 12:\n"); print(slope(5, 12))

# Perfect scores and the random-guessing benchmark 
cat("\nPerfect scores: n =", sum(d$scoreTom == 16, na.rm = TRUE),
    " (", round(100 * mean(d$scoreTom == 16, na.rm = TRUE), 1), "% )\n")
cat("Random guessing (4 options, 16 images): P(score <= 5) =",
    round(100 * pbinom(5, 16, 0.25), 0), "%\n")

# Percentage correct by image (Appendix A2 column), and its range 
pct <- sapply(tom, function(v) 100 * mean(grepl("\\*$", d[[v]][!is.na(d[[v]])])))
names(pct) <- emotion
cat("\nPercent correct by image:\n"); print(round(pct, 1))
cat("Range:", round(min(pct), 1), "to", round(max(pct), 1), "\n")

# Least clear-cut image: share correct and share of the most common wrong answer
clarity <- t(sapply(tom, function(v) {
  x <- d[[v]][!is.na(d[[v]])]
  wrong <- x[!grepl("\\*$", x)]
  c(correct = 100 * mean(grepl("\\*$", x)), same_wrong = 100 * max(table(wrong)) / length(x))
}))
rownames(clarity) <- paste(1:16, emotion)
cat("\nImages ordered by share correct (lowest first):\n")
print(round(clarity[order(clarity[, "correct"]), ][1:4, ], 1))

# Gender 
tt <- t.test(scoreTom ~ gender, data = d[d$gender %in% c("F", "M"), ])
cat("\nMean score, F:", round(tt$estimate[1], 2), " M:", round(tt$estimate[2], 2),
    " t-test p =", signif(tt$p.value, 2), "\n")



# Appendix B7, part b (Validation)-----

# Needs in `data`: Tom1..Tom16 (answer, asterisk = correct), scoreTom, grade1
# (1..12), Age (months), and the 20 mini-IPIP items. Packages: psych, lavaan.
library(psych)
library(lavaan)

# Mini-IPIP: the frame that holds the items (the older children only) and the
# item names, in the order administered. `data_ipip` is `data` itself when the
# items are columns of `data`; otherwise name the frame that has them.
data_ipip     <- dataPersoBig
ipip_items    <- paste0("Q", 1:20)
agreeableness <- ipip_items[c(2, 9, 14, 16)]   # Q2 and Q14 reverse-keyed
extraversion  <- ipip_items[c(1, 7, 12, 20)]   # Q7 and Q20 reverse-keyed

d <- data
for (v in c("grade1", "Age", "scoreTom")) d[[v]] <- as.numeric(as.character(d[[v]]))
missing <- setdiff(ipip_items, names(data_ipip))
if (length(missing)) message("mini-IPIP columns not found: ", paste(missing, collapse = ", "))

tom <- paste0("Tom", 1:16)
emotion <- c("confused", "tired", "sad", "disapproving", "happy", "ashamed", "angry", "flirting",
             "excited", "scared", "disgusted", "thinking", "sneaky", "worried", "hopeful", "surprised")
correct <- as.data.frame(lapply(d[tom], function(x) as.numeric(grepl("\\*$", x))))
correct[is.na(d[tom])] <- NA
names(correct) <- make.names(emotion)

# Sample size 
cat("Observations:", nrow(d), "\n")

# High schoolers: percent correct by image 
hs <- colMeans(correct[d$grade1 >= 11, ], na.rm = TRUE) * 100
cat("\nHigh school (grades 11-12), percent correct by image:\n"); print(round(hs, 0))
cat("Below 70%:", paste0(names(hs)[hs < 70], " (", round(hs[hs < 70], 0), "%)", collapse = ", "), "\n")
all_pct <- colMeans(correct, na.rm = TRUE) * 100
cat("All participants: range", round(min(all_pct), 0), "to", round(max(all_pct), 0), "%\n")

# Reliability: Cronbach's alpha on tetrachoric correlations, by age group 
grp <- cut(d$grade1, c(0, 3, 6, 8, 10, 12),
           labels = c("Early elem.", "Late elem.", "Early middle", "Late middle", "High school"))
ord_alpha <- function(x) {
  x <- x[complete.cases(x), ]
  suppressWarnings(psych::alpha(psych::tetrachoric(x)$rho)$total$raw_alpha)
}
alpha_grp <- sapply(split(correct, grp), ord_alpha)
cat("\nCronbach's alpha by age group:\n"); print(round(alpha_grp, 2))
cat("Mean", round(mean(alpha_grp), 2), " range", round(min(alpha_grp), 2), "to", round(max(alpha_grp), 2), "\n")

# Exploratory factor analysis: three factors on tetrachoric correlations 
cc  <- correct[complete.cases(correct), ]
efa <- psych::fa(cc, nfactors = 3, cor = "tet", fm = "minres", rotate = "oblimin")
L   <- unclass(efa$loadings)
cat("\nEFA loadings (three factors, oblimin):\n"); print(round(L, 2))
assign_f <- apply(abs(L), 1, which.max)
for (k in 1:3) cat("Factor", k, ":", paste(rownames(L)[assign_f == k], collapse = ", "), "\n")

# Confirmatory factor analysis of that structure, younger (< 13) and older 
model <- paste(sapply(1:3, function(k)
  paste0("F", k, " =~ ", paste(rownames(L)[assign_f == k], collapse = " + "))), collapse = "\n")
cfa_fit <- function(sub) {
  fit <- lavaan::cfa(model, data = sub, ordered = names(sub), std.lv = TRUE)
  round(lavaan::fitMeasures(fit, c("rmsea", "cfi", "tli", "srmr")), 3)
}
young <- d$Age < 13 * 12
cat("\nCFA fit:\n")
print(rbind(younger = cfa_fit(correct[young & complete.cases(correct), ]),
            older   = cfa_fit(correct[!young & complete.cases(correct), ])))

# Convergent validity: DeRMET score and the mini-IPIP items 
if (!length(missing)) {
  older <- data_ipip
  for (v in c("scoreTom", ipip_items)) older[[v]] <- as.numeric(as.character(older[[v]]))
  older <- older[!is.na(older[[ipip_items[1]]]) & older[[ipip_items[1]]] > 0, ]   # answered the questionnaire
  cat("\nParticipants with the mini-IPIP:", nrow(older), "\n")
  conv <- function(items) t(sapply(items, function(qv) {
    ct <- cor.test(older$scoreTom, older[[qv]])
    c(r = round(unname(ct$estimate), 2), p = signif(ct$p.value, 2))
  }))
  cat("DeRMET and agreeableness items:\n"); print(conv(agreeableness))
  cat("DeRMET and extraversion items:\n");  print(conv(extraversion))
}

######## Appendix B8-----
# Appendix B8 (P-Big 5): part a (trends with age) and part b (Tables 18 and 19).
# Inputs: `data_Big` (P-Big 5 non-responders removed) with BigE, BigA, BigC,
# BigN, BigO, Age (months), grade1 (1..12), gender, ClientID; and
# `dataPersoBig` with ClientID and the mini-IPIP items Q1..Q20.

traits <- c(O = "BigO", C = "BigC", E = "BigE", A = "BigA", N = "BigN")
trait_name <- c(O = "Openness", C = "Conscientiousness", E = "Extraversion",
                A = "Agreeableness", N = "Neuroticism")
# mini-IPIP items by trait; starred items are framed in the opposite direction
ipip <- list(O = c("Q5", "Q8*", "Q11*", "Q17*"), C = c("Q3", "Q6", "Q13*", "Q18*"),
             E = c("Q1", "Q7*", "Q12", "Q20*"),  A = c("Q2*", "Q9", "Q14*", "Q16"),
             N = c("Q4*", "Q10", "Q15", "Q19*"))

d <- data_Big
for (v in c(traits, "Age", "grade1")) d[[v]] <- as.numeric(as.character(d[[v]]))

# a. Performance -------------------------------------------------------------
cat("Observations:", nrow(d), "\n\nMean score by trait and grade (Figure 7, right):\n")
print(round(sapply(traits, function(v) tapply(d[[v]], d$grade1, mean, na.rm = TRUE)), 2))
cat("\nCorrelation between score and age (months):\n")
print(t(sapply(traits, function(v) {
  ct <- cor.test(d[[v]], d$Age)
  c(PCC = round(unname(ct$estimate), 2), p = signif(ct$p.value, 2))
})))

# b. Validation: sample with the mini-IPIP -----------------------------------
items <- paste0("Q", 1:20)
p <- dataPersoBig[, c("ClientID", items)]
for (v in items) p[[v]] <- as.numeric(as.character(p[[v]]))
m <- merge(d, p, by = "ClientID")
m <- m[!is.na(m$Q1) & m$Q1 > 0, ]
m$Male <- as.numeric(m$gender == "M")
# mini-IPIP trait score: mean of the four items, starred items reversed (6 - x)
for (t in names(ipip)) {
  cols <- sub("\\*$", "", ipip[[t]])
  rev  <- grepl("\\*$", ipip[[t]])
  x <- m[, cols]; x[, rev] <- 6 - x[, rev]
  m[[paste0("ipip", t)]] <- rowMeans(x)
}
cat("\nObservations with the mini-IPIP:", nrow(m), "\n")

# Table 18: P-Big 5 score on mini-IPIP score, Male and Grade (OLS) -----------
fits <- lapply(names(traits), function(t)
  lm(as.formula(paste0(traits[[t]], " ~ ipip", t, " + Male + grade1")), data = m))
names(fits) <- names(traits)
stars <- function(p) ifelse(p < 0.01, "^{***}", ifelse(p < 0.05, "^{**}", ifelse(p < 0.1, "^{*}", "")))
f3 <- function(x) formatC(x, format = "f", digits = 3)
cellf <- function(fit, term) {
  ct <- summary(fit)$coefficients
  if (!term %in% rownames(ct)) return(c("", ""))
  c(paste0("$", f3(ct[term, 1]), stars(ct[term, 4]), "$"), paste0("$(", f3(ct[term, 2]), ")$"))
}
row2 <- function(label, term) {
  cells <- sapply(fits, cellf, term = term)
  c(paste(label, "&", paste(cells[1, ], collapse = " & "), "\\\\"),
    paste("           &", paste(cells[2, ], collapse = " & "), "\\\\"))
}
t18 <- c("\\begin{table}[htpb]", "\\small \\begin{center}", "\\begin{tabular}{l c c c c c}",
         paste(" &", paste("Pict", names(traits), collapse = " & "), "\\\\"), "\\hline")
for (t in names(traits)) t18 <- c(t18, row2(paste("mini-IPIP", t), paste0("ipip", t)))
t18 <- c(t18, row2("Male", "Male"), row2("Grade", "grade1"), row2("Constant", "(Intercept)"),
         "\\hline",
         paste("Adj. R$^2$ &", paste(sapply(fits, function(f) paste0("$", f3(summary(f)$adj.r.squared), "$")), collapse = " & "), "\\\\"),
         paste("Num. obs.  &", paste(sapply(fits, function(f) paste0("$", nobs(f), "$")), collapse = " & "), "\\\\"),
         "\\hline",
         "\\multicolumn{6}{l}{\\scriptsize{$^{***}p<0.01$; $^{**}p<0.05$; $^{*}p<0.1$}}",
         "\\end{tabular}",
         "\\caption{\\small Regression of P-Big 5 scores on mini-IPIP scores }",
         "\\label{table-big5-ipip}", "\\end{center}", "\\end{table}")
writeLines(t18, "../Paper/Figs/table18.tex")

# Table 19: correlation of each P-Big 5 score with each mini-IPIP item -------
fp <- function(p) { p <- round(p, 2); if (p == 0) "(p=0)" else paste0("(p=", formatC(p, format = "f", digits = 2), ")") }
block <- function(t) {
  rows <- sapply(ipip[[t]], function(q) {
    ct <- cor.test(m[[traits[[t]]]], m[[sub("\\*$", "", q)]])
    paste0("    ", q, " & ", formatC(ct$estimate, format = "f", digits = 2), " ", fp(ct$p.value), " \\\\")
  })
  c("  \\begin{tabular}{l c}", "    \\toprule",
    paste0("    \\multicolumn{2}{c}{\\textbf{", t, " - P-Big5}} \\\\"), "    \\midrule",
    rows, "    \\bottomrule", "  \\end{tabular}")
}
blocks <- lapply(names(traits), block)
body <- unlist(lapply(seq_along(blocks), function(i) {
  b <- blocks[[i]]; if (i < length(blocks)) b[length(b)] <- paste(b[length(b)], "&"); b
}))
t19 <- c(" \\begin{table}[h]", "\\hspace*{-5mm}", "{\\footnotesize", "\\centering",
         "\\setlength{\\tabcolsep}{3pt}", "\\renewcommand{\\arraystretch}{1.2}",
         "\\begin{tabular}{c c c c c}", body, "\\end{tabular}",
         "\\caption{\\small Correlations between P-Big 5 scores and IPIP scores by question. * indicates IPIP questions that are framed in the opposite direction of the P-Big 5.}",
         "\\label{table-big5-ipip-questions}", "}", "\\end{table}")
writeLines(t19, "../Paper/Figs/table19.tex")

cat("\nTable 19 entries:\n")
for (t in names(traits)) for (q in ipip[[t]]) {
  ct <- cor.test(m[[traits[[t]]]], m[[sub("\\*$", "", q)]])
  cat(sprintf("  %s  %-4s r = %5.2f  p = %s\n", t, q, ct$estimate, signif(ct$p.value, 2)))
}

######## Appendix B9-----
library(nnet)
library(sandwich)

# Appendix B9: Tables 20 (initial choice) and 21 (final choice).
# Multinomial logit of the choice (Merit, Comp; Equit is the reference) with
# trait-by-environment and trait-by-condition interactions (first model) and
# full trait-by-environment-by-condition interactions (second model).
# Same sample, residuals and clustering as Table 6. Output uses longtable.

if (is.null(getS3method("estfun", "multinom", optional = TRUE))) {
  estfun.multinom <- function(x, ...) {
    X <- model.matrix(terms(x), x$model)
    Y <- model.response(x$model)
    P <- fitted(x)
    Y <- sapply(colnames(P), function(k) as.numeric(Y == k))
    cls <- rownames(coef(x))
    S <- do.call(cbind, lapply(cls, function(k) (Y[, k] - P[, k]) * X))
    colnames(S) <- as.vector(t(outer(cls, colnames(X), paste, sep = ":")))
    S
  }
  bread.multinom <- function(x, ...) nrow(x$model) * vcov(x)
}

# Settings 
cluster_vars <- c("SessionCode", "Campus")
resid_rhs    <- "AgeY"

# Sample and residuals (as in Table 6)
d <- data_Big
d$AgeY <- d$Age / 12
d <- d[d$Age < 225 & (d$StartAlloc == 62 | (d$ToWinner1 != 0 & d$ToWinner2 != 0)), ]
traits <- c(DeRMET = "scoreTom", Extraversion = "BigE", Agreeableness = "BigA",
            Conscientiousness = "BigC", Neuroticism = "BigN", Openness = "BigO")
for (t in names(traits)) {
  d[[paste0(t, "_r")]] <- resid(lm(as.formula(paste(traits[[t]], "~", resid_rhs)), data = d, na.action = na.exclude))
}
choice <- function(start, tw) {
  ifelse(start == 62,
         c("0" = "Merit", "-1" = "Equit", "-2" = "Comp")[as.character(tw)],
         c("3" = "Merit",  "2" = "Equit",  "1" = "Comp")[as.character(tw)])
}
d$choice1 <- relevel(factor(choice(d$StartAlloc, d$ToWinner1)), ref = "Equit")
d$choice2 <- relevel(factor(choice(d$StartAlloc, d$ToWinner2)), ref = "Equit")
d$redistribution <- as.numeric(d$StartAlloc == 62)
d$Treatment <- relevel(factor(d$Treatment), ref = "sliders")

tr   <- paste0(names(traits), "_r")
base <- paste("AgeY + I(AgeY^2) + gender + Siblings + Topic +", paste(tr, collapse = " + "),
              "+ redistribution + Treatment")
rhs_two   <- paste(base, "+", paste(paste0(tr, ":redistribution"), collapse = " + "),
                   "+", paste(paste0(tr, ":Treatment"), collapse = " + "))
rhs_three <- paste(rhs_two, "+ redistribution:Treatment +",
                   paste(paste0(tr, ":redistribution:Treatment"), collapse = " + "))

mnl_cols <- function(lhs, rhs) {
  f  <- as.formula(paste(lhs, "~", rhs))
  m  <- multinom(f, data = d, trace = FALSE, model = TRUE, Hess = TRUE, maxit = 2000)
  mf <- model.frame(f, d)
  cl <- d[rownames(mf), cluster_vars, drop = FALSE]
  V  <- vcovCL(m, cluster = cl, type = "HC1")
  B  <- coef(m)
  nm <- as.vector(t(outer(rownames(B), colnames(B), paste, sep = ":")))
  b  <- setNames(as.vector(t(B)), nm)[colnames(V)]
  se <- sqrt(diag(V))[names(b)]
  lapply(c("Merit", "Comp"), function(k) {
    idx  <- startsWith(names(b), paste0(k, ":"))
    keep <- sub("^[^:]+:", "", names(b)[idx])
    list(b = setNames(b[idx], keep), se = setNames(se[idx], keep), n = nrow(mf), aic = AIC(m))
  })
}

# Rows 
it <- function(x) paste0("\\textit{", x, "}")
X  <- "$\\times$"
rows <- c("^AgeY$" = it("Age"), "^I\\(AgeY\\^2\\)$" = paste0(it("Age"), "$^2$"),
          "^gender" = it("Male"), "^Siblings" = it("Siblings"), "^Topic" = it("STEM"))
for (t in names(traits)) rows[paste0("^", t, "_r$")] <- paste0(t, " (resid)")
rows["^redistribution$"]     <- it("redistribution")
rows["^Treatmentluck$"]      <- it("luck")
rows["^Treatmentquestions$"] <- it("talent")
for (t in names(traits)) rows[paste0("^", t, "_r:redistribution$")] <- paste0(it(t), X, it("redistribution"))
for (t in names(traits)) {
  rows[paste0("^", t, "_r:Treatmentluck$")]      <- paste0(it(t), X, it("luck"))
  rows[paste0("^", t, "_r:Treatmentquestions$")] <- paste0(it(t), X, it("talent"))
}
rows["^redistribution:Treatmentluck$"]      <- paste0(it("Redistribution"), X, it("luck"))
rows["^redistribution:Treatmentquestions$"] <- paste0(it("Redistribution"), X, it("talent"))
for (t in names(traits)) {
  rows[paste0("^", t, "_r:redistribution:Treatmentluck$")]      <- paste0(it(t), X, it("Redistribution"), X, it("luck"))
  rows[paste0("^", t, "_r:redistribution:Treatmentquestions$")] <- paste0(it(t), X, it("Redistribution"), X, it("talent"))
}
rows["^\\(Intercept\\)$"] <- "Constant"

term_of <- function(col, key) {
  hit <- grep(key, names(col$b), perl = TRUE, value = TRUE)
  if (length(hit) > 1) stop("row pattern '", key, "' matches several coefficients: ", paste(hit, collapse = ", "))
  if (length(hit) == 0) NA_character_ else hit
}
stars <- function(p) ifelse(p < 0.01, "^{***}", ifelse(p < 0.05, "^{**}", ifelse(p < 0.1, "^{*}", "")))
fmt   <- function(x, dg = 3) formatC(x, format = "f", digits = dg)
cell  <- function(col, key) {
  tm <- term_of(col, key)
  if (is.na(tm)) return(c("", ""))
  b <- col$b[[tm]]; se <- col$se[[tm]]; p <- 2 * pnorm(-abs(b / se))
  c(paste0("$", fmt(b), stars(p), "$"), paste0("($", fmt(se), "$)"))
}

# longtable 
interaction_table <- function(decision, file, caption, label) {
  lhs  <- paste0("choice", decision)
  cols <- c(mnl_cols(lhs, rhs_two), mnl_cols(lhs, rhs_three))
  when <- if (decision == 1) "Initial choice" else "Final choice"
  head <- c(
    "\\toprule",
    paste0(" & \\multicolumn{2}{c}{", when, "} & \\multicolumn{2}{c}{", when, "} \\\\"),
    "\\cmidrule(lr){2-3} \\cmidrule(lr){4-5}",
    " & Merit. & Comp. & Merit. & Comp. \\\\",
    "\\midrule"
  )
  note <- c("$^{***}p<0.01$; $^{**}p<0.05$; $^{*}p<0.1$.",
            "Reference categories: equitable choice, effort, addition. Age in years.",
            paste0("SE clustered by ", paste(tolower(sub("Code", "", cluster_vars)), collapse = " and "), "."))
  lines <- c(
    "\\begin{footnotesize}",
    "\\begin{longtable}{l cc cc}",
    paste0("\\caption{", caption, "} \\label{", label, "} \\\\"),
    head, "\\endfirsthead",
    "\\multicolumn{5}{l}{\\textit{Table \\thetable{} continued}} \\\\",
    head, "\\endhead",
    "\\midrule",
    "\\multicolumn{5}{r}{\\textit{Continued on next page}} \\\\",
    "\\endfoot",
    "\\bottomrule",
    paste0("\\multicolumn{5}{l}{\\footnotesize ", note, "} \\\\"),
    "\\endlastfoot"
  )
  for (key in names(rows)) {
    cells <- sapply(cols, cell, key = key)
    if (all(cells == "")) next
    lines <- c(lines,
               paste(rows[[key]], "&", paste(cells[1, ], collapse = " & "), "\\\\"),
               paste("    &", paste(cells[2, ], collapse = " & "), "\\\\"))
  }
  lines <- c(lines,
             "\\midrule",
             paste("Obs. &", paste(sapply(cols, `[[`, "n"), collapse = " & "), "\\\\"),
             paste("AIC  &", paste(sapply(cols, function(x) formatC(round(x$aic), format = "d", big.mark = ",")), collapse = " & "), "\\\\"),
             "\\end{longtable}",
             "\\end{footnotesize}"
  )
  writeLines(lines, file)
  invisible(cols)
}

t20 <- interaction_table(1, "../Paper/Figs/Table20.tex",
                         "Multinomial regressions of meritocratic and compensatory initial choices: interaction effects", "table-b9-initial")
t21 <- interaction_table(2, "../Paper/Figs/Table21.tex",
                         "Multinomial regressions of meritocratic and compensatory final choices: interaction effects", "table-b9-final")


######## Appendix B10-----

library(nnet)
library(sandwich)
library(multiwayvcov)

# sandwich methods for multinom objects, defined only if the installed
# sandwich lacks them (needed by vcovCL on the multinomial models).
if (is.null(getS3method("estfun", "multinom", optional = TRUE))) {
  estfun.multinom <- function(x, ...) {
    X <- model.matrix(terms(x), x$model)
    Y <- model.response(x$model)
    P <- fitted(x)
    Y <- sapply(colnames(P), function(k) as.numeric(Y == k))
    cls <- rownames(coef(x))                       # non-baseline classes
    S <- do.call(cbind, lapply(cls, function(k) (Y[, k] - P[, k]) * X))
    colnames(S) <- as.vector(t(outer(cls, colnames(X), paste, sep = ":")))
    S
  }
  bread.multinom <- function(x, ...) nrow(x$model) * vcov(x)
}

# Appendix B10, Table 22: the Table 5 models with the DeRMET score and the five
# P-Big 5 scores as additional regressors. Runs on data_Big (non-responders to
# the P-Big 5 removed).

# Settings
data         <- data_Big
age_unit     <- "years"                      # "years" in every column, or "months"
# in the Poisson columns as in the original code
cluster_vars <- c("SessionCode", "Campus")   # two-way clustering; c("SessionCode") for session only

# Samples 
prep <- function(d) {
  d$howHard5[d$howHard5 %in% c("", NA)] <- NA           # blanks are missing answers
  d$howWell5[d$howWell5 %in% c("", NA)] <- NA
  d$Treatment  <- relevel(factor(d$Treatment), ref = "sliders")
  d$howHard5   <- relevel(factor(d$howHard5),  ref = "Medium")
  d$howWell5   <- relevel(factor(d$howWell5),  ref = "Same")
  d$ChangeWabs <- abs(d$ChangeW)
  d$AgeY       <- d$Age / 12
  droplevels(d)
}
base62 <- with(data, Age < 225 & Treatment != "luck" & StartAlloc == 62)
base31 <- with(data, Age < 225 & Treatment != "luck" & StartAlloc == 31 &
                 ToWinner1 != 0 & ToWinner2 != 0)
sample_of <- function(base, type) prep(data[base & data$ToWinner1Type == type, ])

ctrl   <- "gender + Siblings + Topic + Treatment + howHard5 + howWell5 + scoreTom + BigE + BigA + BigC + BigN + BigO"
rhs_m  <- paste("Age + I(Age^2) +", ctrl)      # months
rhs_y  <- paste("AgeY + I(AgeY^2) +", ctrl)    # years
rhs_p  <- if (age_unit == "years") rhs_y else rhs_m   # Poisson columns

# Poisson column: coefficients, two-way clustered SE (session, campus) 
pois_col <- function(d, lhs) {
  m <- glm(as.formula(paste(lhs, "~", rhs_p)), family = poisson, data = d)
  V <- cluster.vcov(m, as.matrix(d[, cluster_vars]))
  list(b = coef(m), se = sqrt(diag(V)), n = nobs(m), aic = AIC(m), years = age_unit == "years")
}

# Multinomial: two columns (-1 and +1 against no change), same clustering 
mnl_cols <- function(d) {
  d$ChangeW <- relevel(factor(d$ChangeW), ref = "0")
  f  <- as.formula(paste("ChangeW ~", rhs_y))
  m  <- multinom(f, data = d, trace = FALSE, model = TRUE, Hess = TRUE)
  mf <- model.frame(f, d)
  cl <- d[rownames(mf), cluster_vars, drop = FALSE]
  V  <- vcovCL(m, cluster = cl, type = "HC1")
  B  <- coef(m)
  nm <- as.vector(t(outer(rownames(B), colnames(B), paste, sep = ":")))
  b  <- setNames(as.vector(t(B)), nm)[colnames(V)]
  se <- sqrt(diag(V))[names(b)]
  lapply(c("-1", "1"), function(k) {
    idx <- startsWith(names(b), paste0(k, ":"))
    keep <- sub("^-?1:", "", names(b)[idx])
    list(b = setNames(b[idx], keep), se = setNames(se[idx], keep),
         n = nrow(mf), aic = AIC(m), years = TRUE)
  })
}

cols_for <- function(base) {
  c(list(pois_col(sample_of(base, "2-Rep"),  "ChangeWabs")),   # Merit.
    mnl_cols(sample_of(base, "1-Soc")),                        # Equit. (-1), (+1)
    list(pois_col(sample_of(base, "3-Comm"), "ChangeW")))      # Comp.
}
cols <- c(cols_for(base62), cols_for(base31))

# LaTeX 
# Rows: a regular expression for the coefficient name, and the label printed.
# Patterns rather than exact names, so that Siblings, Topic and howHard5 can be
# factors with any level labels (e.g. SiblingsYes, howHard5Difficult).
rows <- c("^AgeY?$"                 = "\\textit{Age}",
          "^I\\(AgeY?\\^2\\)$"      = "\\textit{Age}$^2$",
          "^gender"                 = "\\textit{Male}",
          "^Siblings"               = "\\textit{Siblings}",
          "^Topic"                  = "\\textit{STEM}",
          "^Treatmentquestions$"    = "\\textit{Talent}",
          "^howWell5Better$"        = "\\textit{Better}",
          "^howWell5Worse$"         = "\\textit{Worse}",
          "^howHard5(?!Easy$)."     = "\\textit{Hard}",
          "^howHard5Easy$"          = "\\textit{Easy}",
          "^scoreTom$"              = "\\textit{DeRMET}",
          "^BigE$"                  = "\\textit{Extraversion}",
          "^BigA$"                  = "\\textit{Agreeableness}",
          "^BigC$"                  = "\\textit{Conscientiousness}",
          "^BigN$"                  = "\\textit{Neuroticism}",
          "^BigO$"                  = "\\textit{Openness}",
          "^\\(Intercept\\)$"       = "Constant")
term_of <- function(col, key) {       # the coefficient name behind each row
  hit <- grep(key, names(col$b), perl = TRUE, value = TRUE)
  if (length(hit) > 1) stop("row pattern '", key, "' matches several coefficients: ", paste(hit, collapse = ", "))
  if (length(hit) == 0) NA_character_ else hit
}
stars <- function(p) ifelse(p < 0.01, "^{***}", ifelse(p < 0.05, "^{**}", ifelse(p < 0.1, "^{*}", "")))
fmt   <- function(x, dg) formatC(x, format = "f", digits = dg)

cell <- function(col, key) {
  tm <- term_of(col, key)
  if (is.na(tm)) return(c("", ""))
  b <- col$b[[tm]]; se <- col$se[[tm]]
  p  <- 2 * pnorm(-abs(b / se))
  dg <- if (grepl("2", key) && !col$years) 5 else 3        # Age^2 in months needs 5 decimals
  c(paste0("$", fmt(b, dg), stars(p), "$"), paste0("($", fmt(se, dg), "$)"))
}

lines <- c(
  "\\begin{table}[htpb]",
  "\\centering",
  "\\footnotesize",
  "\\setlength{\\tabcolsep}{3.5pt}",
  "\\begin{tabular}{l cccc | cccc}",
  "\\toprule",
  " & \\multicolumn{4}{c}{\\textit{redistribution}} & \\multicolumn{4}{c}{\\textit{addition}} \\\\",
  "\\cmidrule(lr){2-5} \\cmidrule(lr){6-9}",
  paste(" &", paste(rep(c("Merit.", "\\shortstack{Equit.\\\\($-1$)}", "\\shortstack{Equit.\\\\($+1$)}", "Comp."), 2), collapse = " & "), "\\\\"),
  "\\midrule"
)
for (key in names(rows)) {
  cells <- sapply(cols, cell, key = key)
  lines <- c(lines,
             paste(rows[[key]], "&", paste(cells[1, ], collapse = " & "), "\\\\"),
             paste("           &", paste(cells[2, ], collapse = " & "), "\\\\"))
}
lines <- c(lines,
           "\\midrule",
           paste("Obs. &", paste(sapply(cols, `[[`, "n"), collapse = " & "), "\\\\"),
           paste("AIC  &", paste(sapply(cols, function(x) round(x$aic)), collapse = " & "), "\\\\"),
           "\\bottomrule",
           paste0("\\multicolumn{9}{l}{\\footnotesize $^{***}p<0.01$; $^{**}p<0.05$; $^{*}p<0.1$. ",
                  if (age_unit == "years") "Age in years. " else
                    "Age in months in the Poisson columns and in years in the multinomial columns. ",
                  "SE clustered by ", paste(tolower(sub("Code", "", cluster_vars)), collapse = " and "), ".}"),
           "\\end{tabular}",
           "\\caption{Poisson and multinomial regressions of change in allocation to winner as a function of initial choice (meritocratic, equitable, compensatory) by treatment with traits as explanatory variables.}",
           "\\label{table-revisions-traits}",
           "\\end{table}"
)
writeLines(lines, "../Paper/Figs/Table22.tex")



