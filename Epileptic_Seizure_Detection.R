
data = read.csv("AveragedData.csv", header = TRUE)
data = data[c(-1,-2)]
data$y[data$y != 1] = 0
data$y = as.factor(data$y)
data[,1:178] = scale(data[,-179])
n = nrow(data)
smp_size = floor(0.75*n)
set.seed(123)
train_ind = sample(seq_len(n), size = smp_size)
train = data[train_ind,]
test = data[-train_ind,]
##visualising OGData
count = as.data.frame(table(train$y))
barplot(count$Freq, main="Frequency of Classes", names.arg = c("0","1"), xlab = "Class", ylab = "Count")

#LDA fitting
library(MASS)
library(caret)
lda.fit = lda(y~., data = train)

##Training error
lda.train = predict(lda.fit,train)
lda.class.train = lda.train$class
tr.lda.table = table(lda.class.train, train$y)
lda.train.error = mean(lda.class.train != train$y)

##prediction accuracy
lda.pred = predict(lda.fit,test)
lda.class = lda.pred$class
cm.lda = confusionMatrix(lda.class, as.factor(test$y))
print(cm.lda)


# ## QDA Fitting
qda.fit = qda(y~., data = train)
 
# ##Training error
 qda.train = predict(qda.fit,train)
 qda.class.train = qda.train$class
 tr.qda.table=table(qda.class.train, train$y)
 qda.train.error = mean(qda.class.train != train$y)
 
# ##Prediction Accuracy
 qda.pred = predict(qda.fit, test)
 qda.class = qda.pred$class
 cm.qda = confusionMatrix(qda.class, as.factor(test$y))
 print(cm.qda)
```

#Classification Tree CHANGE TO FACTORS
library(tree)
library(ISLR)
set.seed(3)

tree.ep = tree(y~., data = train)
##Training Error
pred.tree.train = predict(tree.ep, data = train, type = "class")
table(pred.tree.train, train$y)
plot(tree.ep)
text(tree.ep, pretty = 0)
tree.train.error = mean(pred.tree.train !=train$y)
##Test Error
tree.pred.test = predict(tree.ep, test, type = "class")
cm.tree = confusionMatrix(tree.pred.test, test$y)
##Pruning
set.seed(3)
cv_tree = cv.tree(tree.ep, FUN = prune.misclass)
plot(cv_tree$size, cv_tree$dev, type = "b") ##shows us that tree with 9 nodes is best
prune.ep = prune.misclass(tree.ep, best = 12)
prune.pred = predict(prune.ep, test, type = "class")
Prune.error = mean(prune.pred != test$y)
plot(prune.ep)
text(prune.ep, pretty = 0)
#  Check



# #KNN with k = 11
library(class)
train.x = train[-179]
test.x = test[-179]
train.y = train$y
test.y = test$y
# ##Finding best K for K Nearest Neighbors
trControl = trainControl(method = "cv", number = 10)
fit = train(y~., method = "knn", tuneGrid = expand.grid(k=1:11), trControl = trControl, metric = "Accuracy", data = data) ##Change to test data
# ##Predicting with KNN
pred.knn = knn(train.x, test.x, train.y, k = 1)
cm.knn = confusionMatrix(pred.knn, test.y)
print(cm.knn)



#Lasso Regression
library(glmnet)
x = model.matrix(y~., data)[,-c(179)]
y = data$y
fit.cv = cv.glmnet(x,y,alpha = 1)
fit.cv$lambda.min
plot(fit.cv)

lasso.fit = glmnet(x,y,alpha=1, lambda = fit.cv$lambda.min)
abc = as.matrix(coef(lasso.fit)[,1])
Lasso.final = data.frame(abc[which(rowSums(abc)> 0),]) #Transpose

#RR - useless because doesnt make 0
rr.cv = cv.glmnet(x,y,alpha=1)
plot(rr.cv)

ridge.fit = glmnet(x,y, alpha = 0, lambda = ridge.cv$lambda.min)
abc = as.matrix(coef(ridge.fit)[,1])
Ridge.final = data.frame(abc[which(rowSums(abc)> 0),])



library(e1071)
model = naiveBayes(y~., data = train)
p1 <- predict(model,train)
tab1 <- table(p1, train$y)
print(tab1)
1-sum(diag(tab1))/sum(tab1)
p2 <- predict(model,test)
tab2 <- table(p2, test$y)
tab2
1-sum(diag(tab2))/sum(tab2)


mydata <- read.csv("AveragedData.csv")
scaleddata<-scale(mydata)
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}
maxmindf <- as.data.frame(lapply(mydata, normalize))
n = nrow(data)
smp_size = floor(0.75*n)
set.seed(123)
train_ind = sample(seq_len(n), size = smp_size)
trainset <- maxmindf[train_ind,]
testset <-  maxmindf[-train_ind,]
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f, data=trainset, hidden=c(2,1), linear.output=FALSE, threshold=0.01)
nn$result.matrix


#PCA
pr.out=prcomp(data.csv , scale=TRUE)
Cols=function(vec){ 
  + cols=rainbow (length(unique(vec))) 
  + return(cols[as.numeric (as.factor(vec))]) 
  +}
par(mfrow=c(1,2)) 
plot(pr.out$x[,1:2], col=Cols(nci.labs), pch=19 ,
     xlab="Z1",ylab="Z2")
plot(pr.out$x[,c(1,3)], col=Cols(nci.labs), pch=19,
     xlab="Z1",ylab="Z3")
plot(pr.out)






