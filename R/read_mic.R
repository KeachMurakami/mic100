#' Read Photosynthetic gas-exchange parameters Logged by MIC-100
#'
#' @param file path to the csv file
#'
#' @export
read_mic <-
  function(file, simple = TRUE){
    abst <-
      readr::read_csv(file, n_max = 1, col_names = FALSE)

    course <-
      readr::read_csv(file, skip = 1, col_names = c("time", "co2_raw", "temp", "rh", "co2"))

    summary <-
      tibble::tibble(
        file,
        time = lubridate::ymd_hm(paste0(abst$X1, "-", abst$X2, "-",abst$X3, " ", abst$X4)),
        Pn = abst$X10,
        temp = abst$X8,
        rh = mean(course$rh),
        co2_init = course$co2[1],
        duration = max(course$time) + 0.1, # start from 0.0 sec
        slope = abst$X9,
        area = abst$X5,
        vol = abst$X6,
        calib_temp = abst$X7)

    if(simple){
      return(summary)
    } else {
      return(
        list(summary = summary, course = course)
      )
    }
  }

#' Create annotate csv
#'
#' @param path directory which contains mic100's csv files
#' @param output csv annotate file
#'
#' @export
annotate_mic <-
 function(path, output){
   csvs <-
     dir(path, full.names = TRUE)
   photosynthesis <-
     map_dfr(csvs, read_mic) %>%
     pull(Pn)
   result <-
     tibble::tibble(csv = basename(csvs),
                    time = as.character(file.mtime(csvs)),
                    Pn = photosynthesis)

   readr::write_csv(result, output)
   usethis::edit_file(output)
 }
