#'//////////////////////////////////////////////////////////////////////////////
#' FILE: icons.R
#' AUTHOR: David Ruvolo
#' CREATED: 2019-11-11
#' MODIFIED: 2019-11-11
#' PURPOSE: svg objects as R elements
#' STATUS: in.progress
#' PACKAGES: NA
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////
options(stringsAsFactors = FALSE)
icons <- data.frame(
    nextIcon = '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve" width="20" height="20" viewBox="0 0 20 20" preserveAspectRatio="xMinYMax"><path stroke="#252525" stroke-linecap="round" stroke-width="2px" fill="#252525" d="M2,2 10,14 18,2 Z" id="icon-next"/></svg>',
    plus = '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve" width="20" height="20" viewBox="0 0 20 20" preserveAspectRatio="xMinYMax"><path stroke="#252525" stroke-linecap="round" stroke-width="2px" fill="#252525" d="M0,10 L 10,20  M10,0 L 10,20" id="icon-plus"/></svg>'
    shoes = '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve" width="50" height="50" viewBox="0 0 50 60" preserveAspectRatio="xMinYMax"><path stroke="#3f454b" stroke-width="2px" fill="#a6bbda" fill-opacity="0.8" d="M50,47 L 5,44 Q2,40 5,39 L 48,43 Q50,45 48,47 M6,25 L 5,21"/><path stroke="#3f454b" stroke-width="2px" fill="#E64636" fill-opacity="0.38" d="M5,39 Q4,25 6,25 Q10,22 12,26 Q18,37 28,28 L 40,32 Q50,36 48,43 Z"/><path stroke="#3f454b" stroke-width="2px" fill="#ffffff" d="M5,32 Q10,32 15,40 L 5,39 Q3,40 5,32"/><path stroke="#3f454b" stroke-width="2px" fill="none" d="M35,31 L 33,34 M38,32 L 36,35 M41,33 L 39,36"/></svg>'
)