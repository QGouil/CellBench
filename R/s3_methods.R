#' Summary of benchmark_tbl
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
summary.benchmark_tbl <- function(x) {
    if (dplyr::last(colnames(x)) != "result") {
        # if benchmark_tbl has been manipulated by user to non-standard form
        print(summary.data.frame(x))
        return()
    }

    method_names <- names(x)
    method_names <- method_names[-1]
    method_names <- method_names[-length(method_names)]

    out <- ""

    out <- c(glue::glue("Pipeline summary:"), out)
    pipeline_str_vec <- c("data", glue::glue("{method_names}"), "result")
    out <- c(out, glue::glue_collapse(pipeline_str_vec, sep = " → "))

    names(method_names) <- method_names
    unique_method_list <- purrr::map(method_names, function(nm) unique(x[, nm]) %>% dplyr::pull(1))

    for (method_name in method_names) {
        unique_methods <- unique_method_list[[method_name]]
        out <- c(out, glue::glue(""))
        out <- c(out, glue::glue("{method_name} variants:"))
        out <- c(out, glue::glue_collapse(glue::glue(" * {unique_methods}"), sep = "\n"))
    }

    cat(out, sep = "\n")
}

as.list.benchmark_tbl <- function(x) {
    if (dplyr::last(colnames(x)) != "result") {
        # if benchmark_tbl has been manipulated by user to non-standard form
        return(as.list.data.frame(x))
    }

    benchmark_summary
}