#' Read Photosynthetic gas-exchange parameters Logged by MIC-100
#'
#' @param file path to MIC-100 csv file
#' @param simple return time evolution data if FALSE
#'
#' @importFrom rlang .data
#' @export
read_mic <-
  function(file, simple = TRUE){
    header <-
      readr::read_csv(file, n_max = 1, col_names = FALSE)

    course <-
      readr::read_csv(file, skip = 1, col_names = c("time", "co2_raw", "temp", "rh", "co2"), col_types = readr::cols())

    summary <-
      tibble::tibble(
        file,
        time = lubridate::ymd_hm(paste0(header$X1, "-", header$X2, "-", header$X3, " ", header$X4)),
        Pn = header$X10,
        temp = header$X8,
        rh = mean(course$rh),
        co2_init = course$co2[1],
        duration = max(course$time) + 0.1, # start from 0.0 sec
        slope = header$X9,
        area = header$X5,
        vol = header$X6,
        calib_temp = header$X7)

    if(simple){
      return(summary)
    } else {
      return(
        list(summary = summary, course = course)
      )
    }
  }

#' Create MIC-100 summary csv
#'
#' @param path directory which contains mic100's csv files
#' @param output name of summary file
#'
#' @importFrom rlang .data
#'
#' @export
summarise_mic <-
 function(path, output){
   csvs <-
     dir(path, full.names = TRUE)

   result <-
     purrr::map_dfr(csvs, read_mic) |>
     dplyr::mutate(csv = basename(csvs),
                   time = as.character(file.mtime(csvs)),
                   .before = 1)

   readr::write_csv(result, output)
   usethis::edit_file(output)
 }
