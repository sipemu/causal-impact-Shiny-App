function(input, output, session) {
  # source files from tools directory
  flist <- sourceDirectory(path      = 'modules', 
                           encoding  = "UTF-8",
                           recursive = TRUE)
  for (i in 1:length(flist)) {
    source(flist[i], local=TRUE, encoding="UTF-8")
  }
}

