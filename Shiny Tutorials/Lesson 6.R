# Lesson 6

# Reactive expressions enable you to control which parts of your app update when,
# which prevents unnecessary computation that can slow down your app.

install.packages("quantmod")

# The stockVis app looks up stock prices by ticker symbol and displays the results as a line chart. The app lets you

# Select a stock to examine
# Pick a range of dates to review
# Choose whether to plot stock prices or the log of the stock prices on the y axis, and
# Decide whether or not to correct prices for inflation.

# stockVis relies heavily on two functions from the quantmod package:
  
# It usesgetSymbols to download financial data straight into R from websites
# like Google finance and the Federal Reserve Bank of St. Louis.
# It uses chartSeries to display prices in an attractive chart.

# stockVis also relies on an R script named helpers.R, which contains a function that adjusts stock prices for inflation.

