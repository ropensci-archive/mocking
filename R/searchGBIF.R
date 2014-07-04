#' Search for GBIF occurrences.
#'
#' @import httr jsonlite plyr mocker
#' @export
#' 
#' @param scientificName Scientific name
#' @param limit Number of results to return
#' @param cache Logical, defaults to FALSE
#' @param db Database
#' @param backend One of local, redis, couchdb, mongodb, sqlite, git.
#' @param path Path to a directory on your machine.
#' 
#' @examples \dontrun{
#' # Don't cache
#' searchgbif(scientificName='Ursus americanus', limit=2)
#' 
#' # Cache locally, using saveRDS
#' searchgbif(scientificName='Ursus americanus', limit=2, cache=TRUE, backend='local')
#' 
#' # Cache using redis
#' searchgbif(scientificName='Ursus americanus', limit=2, cache=TRUE, backend='redis')
#' 
#' # Cache using rcache, via the R.cache package
#' searchgbif(scientificName='Ursus americanus', limit=2, cache=TRUE, backend='rcache')
#' 
#' # Optionally, you can set mocker as options, then mocker looks for them
#' # This makes your function calls cleaner by avoiding the extra parameter settings
#' # If you use options, arguments passed in to the function call will override options settings
#' 
#' options(cache=TRUE)
#' options(backend='redis')
#' searchgbif(scientificName='Ursus', limit=2) # uses stored options
#' searchgbif(scientificName='Ursus', limit=2, cache=FALSE) # override cache option setting
#' }

searchgbif <- function(scientificName=NULL, limit=20, cache=FALSE, db=NULL, backend='local', path="~/")
{  
  url <- 'http://api.gbif.org/v0.9/occurrence/search'
  
  # Make arg list
  args <- bcompact(list(scientificName=scientificName, limit=as.integer(limit)))
  
  # create a key
  cachekey <- make_key(url, args)
  
  # if cache=TRUE, check for data in backend using key, if cache=FALSE, returns NULL
  obj <- suppressWarnings(cache_get(cache, cachekey, backend, path, db=db))

  # if obj=NULL, proceed to make call to web
  if(is.null(obj)){
    temp <- GET(url, query=args)
    if(temp$status_code > 200){
      stop(content(temp, as = "text"))
    }
    obj <- content(temp, as = 'text', encoding = "UTF-8")
    
    # If cache=TRUE, cache key and value in chosen backend
    cache_save(cache, cachekey, obj, backend, path, db=db)
  }
  
  process_data(obj)
}

extractelements <- function(x){
  data.frame(x[names(x) %in% c('key','scientificName','decimalLongitude','decimalLatitude')], stringsAsFactors = FALSE)  
}

process_data <- function(x){
  tt <- jsonlite::fromJSON(x, FALSE)
  res <- lapply(tt$results, extractelements)
  do.call(rbind.fill, res)
}

bcompact <- function (l) Filter(Negate(is.null), l)