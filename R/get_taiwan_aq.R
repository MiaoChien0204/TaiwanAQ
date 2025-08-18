#' Get Taiwan Air Quality Data
#'
#' Retrieves air quality data from historical `.parquet` files.
#'
#' @param start Start date as character (e.g. "2022-01-01") or Date object.
#' @param end End date as character (e.g. "2022-01-31") or Date object.
#' @param station Optional. Character vector of station names.
#' @param item Character scalar indicating the pollutant (e.g., "PM2.5").
#' @return A tibble of filtered air quality records.
#' @export
get_taiwan_aq = function(start, end = start, item = "PM2.5", station = NULL) {
  start = lubridate::ymd(start)
  end = lubridate::ymd(end)

  if (start > end) {
    stop("`start` date must be before or equal to `end` date.")
  }

  years = seq(lubridate::year(start), lubridate::year(end))
  dfs = list()

  for (yr in years) {
    parquet_path = download_parquet(yr, item)

    df = arrow::read_parquet(parquet_path) %>%
      dplyr::filter(date >= !!start, date <= !!end)

    dfs[[as.character(yr)]] = df
  }

  result = dplyr::bind_rows(dfs)

  if (!is.null(station)) {
    result = dplyr::filter(result, station %in% station)
  }

  return(result)
}

#' Get the local cache directory for TaiwanAQ data
get_cache_dir = function() {
  dir = rappdirs::user_cache_dir("TaiwanAQ")
  fs::dir_create(dir)
  return(dir)
}

#' Download the parquet file for a given year and item, if not already cached
download_parquet = function(year, item, version = "v0.1.0") {
  file_name = glue::glue("tw_aq_{year}_{item}.parquet")
  cache_path = fs::path(get_cache_dir(), file_name)

  if (!fs::file_exists(cache_path)) {
    url = glue::glue("https://github.com/MiaoChien0204/TaiwanAQ/releases/download/{version}/{file_name}")
    message("Downloading from: ", url)
    utils::download.file(url, destfile = cache_path, mode = "wb", quiet = TRUE)
    message("Saved to cache: ", cache_path)
  }

  return(cache_path)
}
