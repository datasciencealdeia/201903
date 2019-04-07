import sys
import math
import time
import pylab
import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import load_svmlight_file, make_classification
import os

i = 0

def predict(row, weights):
  activation = weights[0]
  for i in range(len(row)):
    activation += weights[i + 1] * row[i]

  # hardlim
  return 1.0 if activation >= 0.0 else 0.0

def update_weights(weights, error, X):
  global i

  w1 = weights[1] + error * X[i][0]
  w2 = weights[2] + error * X[i][1]
  bias = weights[0] + error

  return bias,w1,w2

def plot_line(X,y,weights,epoch,time):
  for x,label in zip(X,y):
    if label == 0:
      plt.scatter(x[0],x[1], color='red')
    else:
      plt.scatter(x[0],x[1], color='blue')

  # equcao da reta
  # x * w1 + y * w2 + bias = 0

  xx = []
  yy = []
  x_min = min(X.transpose()[0])
  x_max = max(X.transpose()[0])
  y_min = min(X.transpose()[1])
  y_max = max(X.transpose()[1])

  # point 1
  x = x_max + 1
  if weights[2] == 0:
    y = 0
  else:
    y = (x * weights[1] + weights[0]) / - weights[2]

  if weights[1] == 0:
    x = 0
  else:
    x = (y * weights[2] + weights[0]) / - weights[1]

  xx.append(x)
  yy.append(y)

  # point 2
  x = x_min - 1
  if weights[2] == 0:
    y = 0
  else:
    y = (x * weights[1] + weights[0]) / - weights[2]
	
  if weights[1] == 0:
    x = 0
  else:
    x = (y * weights[2] + weights[0]) / - weights[1]

  xx.append(x)
  yy.append(y)

  # plot perceptron line
  fig = pylab.gcf()
  fig.canvas.set_window_title('Epoch ' + str(epoch))

  plt.plot(xx,yy)

  plt.title('W = ({0:.2f},{1:.2f}) | b = {2:.2f}'.format(weights[1],weights[2],weights[0]))
  plt.xlim(x_min-1,x_max+1)
  plt.ylim(y_min-1,y_max+1)

  # updates every x seconds
  plt.pause(time)
  plt.clf()

def main(data):
  global i

  if data == None:
    print('No dataset given | Usage: perceptron.py <data>')
    # print 'Loading default data...'
    # time.sleep(2)
    #X = np.array([[2,2],[-2,-2],[-2,2],[-1,1],[1,1.5],[2,-1],[2.64,0.4],[-1.8,0]])
    #y = np.float64([0,1,0,1,0,1,0,1])

    print('Loading random data...')
    time.sleep(3)
    X, y = make_classification(n_samples=30, n_features=2, n_redundant=0, n_clusters_per_class=1, class_sep=0.5)
  else:
    print("Loading data...")
    X, y = load_svmlight_file(data)
    X = X.toarray()

  weights = [0, 0.3, 0.8]
# weights = [0, 0, 0]

  print('W = ({0:.2f},{1:.2f}) | b = {2:.2f}'.format(weights[1],weights[2],weights[0]))

  epoch = 0
  correct = 0

  while correct < len(X) and epoch < 300:
    if i == len(X):
      i = 0 
    prediction = predict(X[i], weights)
    gt = y[i]
    print(("  Pattern %d -> gt=%d, Predicted=%d" % (i, gt, prediction)))
    if gt == prediction:
      correct += 1
    else:
      error = gt - prediction

      weights = update_weights(weights, error, X)

      print('\nUpdate Weights:')
      print('  Weights = ({0:.2f},{1:.2f}) | bias = {2:.2f}'.format(weights[1],weights[2],weights[0]))

      # i = 0
      correct = 0

    if i == 0:
      epoch += 1
      plot_line(X,y,weights,epoch, 0.05)
    i += 1
  input('') 
  print('\nResults:')
  print('  Epochs:', epoch)
  print('  Weights = ({0:.2f},{1:.2f}) | bias = {2:.2f}'.format(weights[1],weights[2],weights[0]))
  plot_line(X,y,weights,epoch,3)

if __name__ == "__main__":
  time1 = time.time()
  main(None)
  time2 = time.time()
  seconds = (time2-time1)
  m, s = divmod(seconds, 60)
  h, m = divmod(m, 60)
  # print "\nTotal time: %d:%02d:%02d" % (h, m, s)
