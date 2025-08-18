library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(fs)
library(lubridate)
library(arrow)
library(glue)
library(purrr)

target_year = 2024
zip_path = glue::glue("data-raw/zips/全部_{target_year}.zip")
csv_dir = glue::glue("data-raw/csv/{target_year}/")
output_dir = "data-raw/parquet/"
dir_create(output_dir)


# unzip
if (!dir_exists(csv_dir)) {
  dir_create(csv_dir)
  unzip(zip_path, exdir = csv_dir)
}


# file_path = csv_files[2]
clean_one_file = function(file_path){

  read_csv(file_path, show_col_types = FALSE) %>% select(-starts_with("...")) %>%
    mutate(across(matches("^\\d{2}$"), .fns = function(x){as.numeric(x)})) %>%
    pivot_longer(cols = matches("^\\d{2}$"), names_to = "hour", values_to = "value") %>%
    mutate(
      station = 測站 %>% first(),
      date = 日期 %>% stringr::str_remove(., " 00:00:00") %>% lubridate::ymd(.),
      item = 測項
    ) %>%
    mutate(station, date, hour, item, value)


}


csv_files = dir_ls(paste0(csv_dir, "全部"), glob = "*.csv")

all_data = purrr::map(csv_files[1:2], clean_one_file) %>% bind_rows()

items = unique(all_data$item)

for(it in items){
  df_item = filter(all_data, item == it)
  file_out <- glue("{output_dir}/tw_aq_{target_year}_{it}.parquet")
  write_parquet(df_item, file_out)
  message("Saved: ", file_out)
}

