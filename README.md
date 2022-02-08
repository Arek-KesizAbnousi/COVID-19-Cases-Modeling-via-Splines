# Model-COVID-19-Cases-Using-Splines

In this Project, we fit various splines to model the COVID-19 daily positive case
numbers in Florida from 3/3/20 – 3/7/21.

   # Data  
 - COVID-19 daily positive case numbers in Florida from 3/3/20 – 3/7/21.
 -  We will fit various splines to these data.

 # Algorithm implementation.

 - Construct basis sets for an order M = 2 and M = 4 spline.
 - Using both bases, we fit a spline with lasso using glmnet.
 - The tuning parameters are selected using cv.glmnet (standardize=FALSE).
 - We Plot these two estimated functions (based on the two splines) over the data.
 - Fit a local polynomial\kernel smoother to best estimate the true data generating function(f).
 - Verify the fit. Evaluate squared prediction error.
