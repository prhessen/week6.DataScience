# R Studio API Code 
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))

# Data Import
library(stringi)
citations <- stri_read_lines("../data/citations.txt")
citations_txt <- citations[!stri_isempty(citations)]
print(length(citations) - length(citations_txt))

# Data Cleaning
library(tidyverse)
library(rebus)

sample(citations_txt, size = 10)
citations_tbl <- tibble(line = 1:length(citations_txt), cite = citations_txt) %>% 
    mutate(cite = str_remove_all(cite, pattern = or("\"","\'"))) %>%
    mutate(year = as.numeric(str_extract(cite, pattern = "[0-9]{4}"))) %>%
    mutate(page_start = as.numeric(str_match(cite, pattern = "\\s([0-9]+)\\-[0-9]+")[,2])) %>%
    mutate(perf_ref = str_detect(cite, pattern = or("performance", "Performance", "PERFORMANCE"))) %>%
    mutate(title = str_match(cite, pattern = "[0-9]{4}\\)\\.\\s*([A-Z][^.]+)")[,2]) %>%
    mutate(first_author = str_match(cite, pattern = "^\\*?([A-Z][a-zA-Z-?\\s*]+\\,?\\s*[A-Z]\\.?\\s*[A-Z]?\\.?\\s*?[A-Z]?\\.?)")[,2])