
TaiwanAQ provides tidy and efficient access to Taiwan’s air quality
data, including both historical measurements and near-real-time data
from the [Environmental Data Open Platform](https://data.moenv.gov.tw/).

It allows users to easily retrieve and analyze hourly pollution
measurements by station, pollutant, and date — without needing to
manually download and clean raw CSVs or deal with the official API’s
limitations.

------------------------------------------------------------------------

## Installation

You can install the development version of **TaiwanAQ** from
[GitHub](https://github.com/MiaoChien0204/TaiwanAQ) with:

``` r
# install.packages("devtools")
devtools::install_github("MiaoChien0204/TaiwanAQ")
```

## Example usage

``` r
library(TaiwanAQ)

# Get hourly PM2.5 for Guting station on a specific day
get_taiwan_aq("2024-08-01", station = "古亭", item = "PM2.5")

# Query multiple days across years
get_taiwan_aq("2023-12-30", "2024-01-02", item = "O3")

# Query full-day record for a station using real-time API data (2025+)
get_taiwan_aq("2025-08-16", station = "古亭", item = "CO")
```

This function automatically pulls from historical .parquet archives
(2018–2024) or live API sources (2025 onward), and caches remote files
locally for future use.

## Features

- Efficient access to hourly historical air quality data from 2018
  onward
- Optional integration with Taiwan’s environmental API for recent data
- Smart caching and data download from GitHub releases
- Query by pollutant (PM2.5, CO, SO2, etc.), date, and station
- Clean and tidy output for immediate analysis

## Roadmap

⬜ Add support for real-time auto-updating API cache

⬜ Include station metadata via get_station_info()

⬜ Add visualization helpers for pollutant time trends

## Data Sources

- Historical CSVs: [Taiwan Air Quality Query
  System](https://airtw.moenv.gov.tw/cht/Query/His_Data.aspx)

- Realtime data: [MOENV Open Data Platform](https://data.moenv.gov.tw/)
