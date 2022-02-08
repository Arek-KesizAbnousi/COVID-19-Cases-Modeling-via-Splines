#---------------
# loading data
#----------------
florida_covid19 <- read.csv(url("https://ajmolstad.github.io/docs/florida_covid.csv")) 
covid19 <- florida_covid19[order(as.Date(florida_covid19$date, format="%m/%d/%Y")),] 
covid19$x <- 1:length(covid19$date)

# Construct basis sets for order M = 2 and then we will fit spline with LASSO.

library(glmnet) 
d <- 360 
knots <- seq(2, d-1, length=100)


M <- 2 
basis <- matrix(0,nrow=360,ncol=M) 
for (j in 1:M) 
{ 
  basis[,j] <- covid19$x^j 
} 
basis_M <- matrix(0,nrow=360,ncol=100) 
for (l in 1:length(knots)) 
{ 
  basis_M[,l] <- ifelse((covid19$x-knots[l])^(M-1)>0,(covid19$x-knots[l])^(M-1),0) 
} 
X2 <- cbind(basis,basis_M) 
cv_fit_2 <- cv.glmnet(X2, covid19$positiveIncrease) 
lambda_opt_2 <- cv_fit_2$lambda.min 
lasso_fit_2 <- glmnet(X2, covid19$positiveIncrease, alpha = 1, lambda=lambda_opt_2, standardize = FALSE) 
predicted_2 <- predict(lasso_fit_2, s=lambda_opt_2, newx = X2 )

# Now, Construct basis sets for order M = 4 and then the spline fit with LASSO.


M <- 4 
basis <- matrix(0,nrow=360,ncol=M) 
for (j in 1:M) 
{ 
  basis[,j] <- covid19$x^j 
} 
basis_M <- matrix(0,nrow=360,ncol=100) 
for (l in 1:length(knots)) 
{
  basis_M[,l] <- ifelse((covid19$x-knots[l])^(M-1)>0,(covid19$x-knots[l])^(M-1),0) 
} 
X4 <- cbind(basis,basis_M) 
cv_fit_4 <- cv.glmnet(X4, covid19$positiveIncrease) 
lambda_opt_4 <- cv_fit_4$lambda.min 
lasso_fit_4 <- glmnet(X4, covid19$positiveIncrease, alpha = 1, lambda=lambda_opt_4, standardize = FALSE) 
predicted_4 <- predict(lasso_fit_4, s=lambda_opt_4, newx = X4 )



# We Plot of these two estimated functions over the data

plot(covid19$x, covid19$positiveIncrease, xlab="days since 3/2/20",ylab="Florida covid19 positive cases") 
lines(covid19$x,predicted_4,col="blue") 
lines(covid19$x,predicted_2,col="red")

# We want to fit a smoother to best estimate f, the true data generating function
# First we omit the possible anomalous days.

omit_days <- boxplot(covid19$positiveIncrease, plot=FALSE)$out 
omit_days

# Keeping the non-anomalous days
nonanomalous_covid19 <- covid19[-which(covid19$positiveIncrease %in% omit_days),] 
nonanomalous_covid19

# We use smoothing spline method to fit model to this data

spline <- smooth.spline(nonanomalous_covid19$x,nonanomalous_covid19$positiveIncrease) 
plot(nonanomalous_covid19$x,nonanomalous_covid19$positiveIncrease,xlab="Days since 3/2/20",ylab="Florida covid19 positive cases") 
lines(spline,col="orange",lwd=2)

