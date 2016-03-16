"""
A basic script to help with Assignment C.
This can be used to generate an array of closing values for selected stocks for a given date range, using the Yahoo API.
"""

import numpy as np
import datetime

import matplotlib.pyplot as plt
from matplotlib.finance import quotes_historical_yahoo

symbol_dict = {
    'WFC': 'Wells Fargo',
    'JPM': 'JPMorgan Chase',
    'AIG': 'AIG',
    'AXP': 'American express',
    'BAC': 'Bank of America',
    'GS': 'Goldman Sachs',
}

symbols, names = np.array(list(symbol_dict.items())).T

startdate = datetime.datetime(2012, 1, 1)
enddate = datetime.datetime(2014, 12, 31)

quotes = []
for symbol in symbols:
	try:
		qt = quotes_historical_yahoo(symbol, startdate, enddate, asobject=True)
		quotes.append(qt)
	except:
		print("fail: ", symbol)


close = np.array([q.close for q in quotes])





