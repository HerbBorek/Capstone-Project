#!/usr/bin/env python
# coding: utf-8

# In[1]:


# Import the necessary modules
import numpy as np
import pandas as pd

import matplotlib.pyplot as plt
import seaborn as sb
from pylab import rcParams

import scipy
from scipy.stats import spearmanr


# In[2]:


get_ipython().run_line_magic('matplotlib', 'inline')
rcParams['figure.figsize'] = 14, 7
plt.style.use('seaborn-whitegrid')


# In[3]:


# Import the dataset and assign columns
address = '/Users/herbborek/Dropbox/H-Masters/Summer-Term 2/Datasets/WWI_FULLER_Data.csv'
WWI = pd.read_csv(address)

# WWI.columns = ['Package', 'Quantity', 'Unit Price', 'Tax Rate', 'Total Excluding Tax', 'Tax Amount', 'Profit', 'Total Including Tax', 'Transaction Type', 'Customer', 'Customer Category', 'Buying Group', 'Invoice Date Key', 'Delivery Date Key', 'Is Finalized', 'Lead Time Days', 'Stock Item']

# Look at the first five rows
WWI.head()


# In[4]:


print(WWI.columns)
WWI.shape


# In[5]:


# Split the customer column into the customer and the city columns
new = WWI['Customer'].str.split('(', n=1, expand = True)
WWI['Customer'] = new[0]
WWI['City'] = new[1]
WWI.head()


# In[6]:


# Split the Stock Item column into the item and item characteristic columns
new = WWI['Stock Item'].str.split('(', n=1, expand = True)
WWI['Item'] = new[0]
WWI['Item Characteristic'] = new[1]
WWI.head()


# In[7]:


new = WWI['Item'].str.split(' - ', n=1, expand = True)
WWI['Item'] = new[0]
WWI['Item Description'] = new[1]
WWI.head()


# In[8]:


# Split the date columns into months, days, and years
WWI[['Invoice Year', 'Invoice Month', 'Invoice Day']] = WWI['Invoice Date Key'].str.split('-', 2, expand=True)
WWI[['Delivery Year', 'Delivery Month', 'Delivery Day']] = WWI['Delivery Date Key'].str.split('-', 2, expand=True)

WWI['Invoice Month'] = WWI['Invoice Year'].map(str) + '-' + WWI['Invoice Month'].map(str)
WWI['Delivery Month'] = WWI['Delivery Year'].map(str) + '-' + WWI['Delivery Month'].map(str)

WWI.head()


# In[9]:


# Shape shows the number of rows and columns in the dataset
# Columns lists the columns
# Info() tells us about the variables including the datatype
print(WWI.shape, WWI.columns)
print(WWI.info())


# In[10]:


# Give Exploratory statistics of the numeric variables
WWI.describe()


# In[11]:


# Count the number of times each type of non-numeric variables appear: Package
WWI['Package'].value_counts()


# In[12]:


# Count the number of times each type of non-numeric variables appear: Transaction Type
WWI['Transaction Type'].value_counts()


# In[13]:


# Count the number of times each type of non-numeric variables appear: Is Finalized
WWI['Is Finalized'].value_counts()


# In[14]:


# Count the number of times each type of non-numeric variables appear: Customer
WWI['Customer'].value_counts()


# In[15]:


# Count the number of times each type of non-numeric variables appear: Item
WWI['Item'].value_counts()


# In[16]:


# Count the number of times each type of non-numeric variables appear: Item Characteristic
WWI['Item Characteristic'].value_counts()


# In[17]:


# Count the number of times each type of non-numeric variables appear: Item Characteristic
WWI['Item Description'].value_counts()


# In[18]:


# Count the number of times each type of non-numeric variables appear: Invoice Year
WWI['Invoice Year'].value_counts()


# In[19]:


# Get the mean of the Profit variable
WWI['Profit'].mean()


# In[20]:


# Get the mean of each variable where the buying group is the Wingtip Toys
WWI[WWI['Invoice Year'] == "2013"].mean()


# In[21]:


# Get the mean of each variable where the buying group is the Tailspin Toys
WWI[WWI['Invoice Year'] == "2016"].mean()


# In[23]:


# Boxplot of the two buying groups based on profit
np.random.seed(1234)
boxplot = WWI.boxplot(column='Profit',by='Invoice Year')


# In[24]:


# Boxplot of the two buying groups based on unit price
np.random.seed(1234)
boxplot = WWI.boxplot(column='Unit Price',by='Invoice Year')


# In[25]:


# Create a timeseries variable and aggregate profit
TS = WWI.groupby('Invoice Year', as_index=False).agg({"Profit":"mean"})
TS.head()


# In[26]:


# Create a line graph that goes along by month
plt.plot(TS['Invoice Year'], TS['Profit'])
plt.xlabel('Year')
plt.ylabel('Profit')
plt.title('Profit by Invoice Year')
plt.show()


# In[24]:


# Calculate our variables that we will be looking at, such as lead time demand, reorder points, etc.
Average_Sales = WWI['Profit'].mean()
Lead_Time = WWI['Lead Time Days']
Lead_Time_Demand = Lead_Time*Average_Sales

Max_Lead_Time = max(Lead_Time)
Avg_Lead_Time = Lead_Time.mean()

Daily_Usage = WWI.groupby('Invoice Date Key', as_index=False).agg({"Quantity":"sum"})
Max_Usage = max(Daily_Usage['Quantity'])
Avg_Usage = Daily_Usage['Quantity'].mean()

Safety_Stock = (Max_Lead_Time * Max_Usage) - (Avg_Lead_Time * Avg_Usage)
Reorder_Point = Lead_Time_Demand + Safety_Stock

WWI['Reorder Point'] = Reorder_Point
WWI.head()


# In[25]:


# Get demand by getting the mean of sales by item, then by month
Avg_Sales = WWI.groupby('Item', as_index=False).agg({"Profit":"mean"})
Avg_Sales.head()


# In[26]:


# Starting calculations for demand by separating out the three columns that will be necessary:
# The month, the item, and the profit
Calc_Demand = WWI[['Invoice Month', 'Item', 'Profit']]
Calc_Demand.head()


# In[27]:


# Get the mean profit of each item by month
group = Calc_Demand.groupby(['Invoice Month', 'Item']).agg({"Profit":"mean"})

# Calculate the demand by getting the mean of each item
Demand = group.groupby('Item').agg({"Profit":"mean"})

# Change the column name to 'Demand' so that there is no problem when adding the Demand variable to the dataset
Demand = Demand.rename(columns = {'Profit':'Demand'})

Demand.head()


# In[28]:


# Merge the Demand variable with the dataset
WWI = pd.merge(WWI, Demand, on='Item')
WWI.head()


# In[29]:


# Calculate the percent profit as a new variable
WWI['Percent Profit'] = WWI['Profit']/WWI['Total Excluding Tax']
WWI.head()


# In[30]:


WWI['ROI'] = (WWI['Profit']/(WWI['Total Excluding Tax'] - WWI['Profit']))*100
WWI.head()


# In[32]:


# Show pairwise scatterplots of variables
sb.pairplot(WWI[['ROI', 'Tax Rate', 'Profit', 'Reorder Point', 'Demand', 'Percent Profit']])


# In[34]:


export_csv = WWI.to_csv("/Users/herbborek/Dropbox/H-Masters/Summer-Term 2/Datasets/World_Wide_Importers.csv", columns = WWI.columns, index = None, header=True)


# In[ ]:





# In[ ]:




