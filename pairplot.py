#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat May 11 20:48:59 2019

@author: younessubhi
"""

# import dependies

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# importér data og load til pandas dataframe

df = pd.read_excel("nn1_corr.xlsx")

df.head()

# fjern tidskolonne
df = df.drop(df.columns[1], axis=1).head(2)

# fjern outliers


# ekstraher attributes
attributeNames = df.columns

# hurtig oversigt over data
percentiles = df.describe(percentiles=[0.1,0.25,0.50,0.75,0.9])

describe = df.describe

sns.pairplot(df)

df.corr

plt.figure(figsize=(10,7))
sns.heatmap(df.corr(),annot=True,linewidths=2)