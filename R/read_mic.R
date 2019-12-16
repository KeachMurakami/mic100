#' Read Photosynthetic Rate Logged by MIC100
#'
#' @usage
#'
#' @encoding UTF-8
#'
#' @param file path to the csv file
#'
#' @export
read_mic <-
  function(file){
    info <- readr::read_csv(file, n_max = 1, col_names = FALSE)
    course <- readr::read_csv(file, skip = 1, col_names = c("time", "co2_raw", "temp", "rh", "co2"))

    summary <-
      tibble(
        name = fs::path_ext_remove(basename(file)),
        date = lubridate::ymd_hm(paste0(info$X1, "-", info$X2, "-",info$X3, " ", info$X4)),
        Pn = info$X10,
        temp = info$X8,
        duration = max(course$time) + 0.1, # start from 0.0 sec
        slope = info$X9,
        area = info$X5,
        vol = info$X6,
        calib_temp = info$X7)

    attributes(summary)$course <- course

    return(summary)
  }
