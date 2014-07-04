#' # Optionally, you can set mocker as options, then mocker looks for them
#' # This makes your function calls cleaner by avoiding the extra parameter settings
#' # If you use options, arguments passed in to the function call will override options settings
#'
#' options(cache=TRUE)
#' options(backend='redis')
#' searchgbif(scientificName='Ursus', limit=2) # uses stored options
#' searchgbif(scientificName='Ursus', limit=2, cache=FALSE) # override cache option setting
#'
#' # You can also set global options for
#' # * 
