"""
Analyzing Changes in Average Annual Returns for Top NASDAQ Companies

Research Question 1: Which company experienced the largest change in its
average annual return between the early period (2017-2019) and the recent
period (2021-2023)?
"""

import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Load dataset
file_path = os.path.join('..', 'data', 'data.csv')
df = pd.read_csv(file_path)
df.head()

# Convert Date column
df['Date'] = pd.to_datetime(df['Date'], format='mixed', dayfirst=True)

# Convert Close/Last to numeric (strip $ formatting)
df['Close/Last'] = df['Close/Last'].replace(r'[\$,]', '', regex=True).astype(float)

# Sort chronologically by company
df = df.sort_values(['Company', 'Date']).reset_index(drop=True)

# Daily returns
df['Daily_Return'] = df.groupby('Company')['Close/Last'].pct_change()

# Extract year for annual aggregation
df['Year'] = df['Date'].dt.year

# Average annual returns per company/year
annual_returns = df.groupby(['Company', 'Year'])['Daily_Return'].mean().reset_index()

# Early vs. recent periods
early_period = annual_returns[annual_returns['Year'].between(2017, 2019)]
recent_period = annual_returns[annual_returns['Year'].between(2021, 2023)]

early_avg = early_period.groupby('Company')['Daily_Return'].mean().reset_index()
early_avg.rename(columns={'Daily_Return': 'Early_Avg_Return'}, inplace=True)

recent_avg = recent_period.groupby('Company')['Daily_Return'].mean().reset_index()
recent_avg.rename(columns={'Daily_Return': 'Recent_Avg_Return'}, inplace=True)

# Merge and calculate percent change
comparison = early_avg.merge(recent_avg, on='Company')
comparison['Percent_Change'] = (
    (comparison['Recent_Avg_Return'] - comparison['Early_Avg_Return'])
    / abs(comparison['Early_Avg_Return'])
) * 100

# Identify company with the largest absolute change
largest_change = comparison.loc[comparison['Percent_Change'].abs().idxmax()]
print(comparison)
print('\nLargest change:\n', largest_change)

# Visualize early vs. recent average returns, highlighting the largest mover
plt.figure(figsize=(12, 6))

x = np.arange(len(comparison['Company']))
width = 0.35

plt.bar(x - width / 2, comparison['Early_Avg_Return'], width, label='2017-2019 Avg Return')
plt.bar(x + width / 2, comparison['Recent_Avg_Return'], width, label='2021-2023 Avg Return')

largest_idx = comparison['Percent_Change'].abs().idxmax()
plt.bar(x[largest_idx] + width / 2, comparison.loc[largest_idx, 'Recent_Avg_Return'],
        width, color='orange', label=f"Largest Change ({comparison.loc[largest_idx, 'Company']})")

plt.xticks(x, comparison['Company'], rotation=45)
plt.ylabel('Average Daily Return')
plt.title('Comparison of Early vs Recent Average Returns for NASDAQ Companies')
plt.legend()
plt.tight_layout()
plt.savefig(os.path.join('..', 'figures', 'early_vs_recent_returns_regenerated.png'), dpi=150)
plt.show()

# Reference:
# Pitroda, K. (2023, July 18). Stock market: Historical data of top 10 companies.
# Kaggle. https://www.kaggle.com/datasets/khushipitroda/stock-market-historical-data-of-top-10-companies?resource=download
