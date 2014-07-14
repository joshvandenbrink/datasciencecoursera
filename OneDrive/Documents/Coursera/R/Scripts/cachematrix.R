makeCacheMatrix <- function(initial_matrix = matrix()) {
  # set inverse matrix store to NULL
  matrix_inverse <- NULL
  
  # set initial matrix to variable m
  set <- function(m){
    initial_matrix <<- m
    matrix_inverse <<- NULL #clear (or NULL) inveser matrix in closure
  }
  
  # search by name for an object
  get <- function(){
    return(initial_matrix)
  }
  
  # create the inverse function in the global
  setinverse <- function(inverse){
    matrix_inverse <<- inverse
  }
  # display the inverse
  getinverse <- function(){
    return(matrix_inverse)
  }
  
  list(set = set, get = get,
       setinverse = setinverse,
       getinverse = getinverse)
}

cacheSolve <- function(x, ...) {

  CacheObject <- x
  matrix_inverse <- x$getinverse()
  
  # test to see if matrix_inverse is already cached
  if(! is.null(matrix_inverse)){
    message("obtianing cached data")
    return(matrix_inverse)
  }
  #if no inverse matrix cached, create inverse matrix
  else {
    # create inverse matrix using solve method
    matrix_inverse <- solve(CacheObject$get(), ...)
    # cache the inverse matrix
    CacheObject$setinverse(matrix_inverse)
    
    #return the results and print
    return(matrix_inverse)
  }
  
}