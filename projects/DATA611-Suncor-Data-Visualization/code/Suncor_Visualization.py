import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import calendar

# Load data
file_path = '../data/TSX_SU_Stock_Price.csv'
df = pd.read_csv(file_path)

# Make date column to datetime
df['date'] = pd.to_datetime(df['date'], errors='coerce')
df = df.dropna(subset=['date'])

# Sort by date
df = df.sort_values('date')

# Calculate daily returns
df['return'] = df['closing_price'].pct_change()
df['log_return'] = np.log(df['closing_price'] / df['closing_price'].shift(1))

# Extract Year and Month for grouping
df['Year'] = df['date'].dt.year
df['Month'] = df['date'].dt.month
df['Month_Name'] = df['date'].dt.strftime('%b')
df['Day_of_week'] = df['date'].dt.dayofweek  

# 1. Line Chart — Price Trend
df['close_smooth'] = df['closing_price'].rolling(window=30).mean()
plt.figure(figsize=(12,6))
plt.plot(df['date'], df['close_smooth'], label='30-Day Moving Average')
plt.xlabel('Date')
plt.ylabel('Price')
plt.title('Smoothed Suncor Stock Price Trend (2015-2026)')
plt.legend()
plt.tight_layout()
plt.show()

# 2. Histogram — Return Distribution
plt.figure(figsize=(10,6))
sns.histplot(df['return'].dropna(), bins=50, kde=True)
plt.xlabel('Daily Return')
plt.ylabel('Frequency')
plt.title('Distribution of Daily Returns')
plt.show()

# 3. Box Plot — Return Volatility by Year
plt.figure(figsize=(12,6))
sns.boxplot(x='Year', y='return', data=df)
plt.xlabel('Year')
plt.ylabel('Daily Return')
plt.title('Return Volatility Across Years')
plt.show()

# 4a. Bar Chart — Monthly Average Return 
monthly_return = df.groupby(['Year', 'Month'])['return'].mean().reset_index()
monthly_return['date'] = pd.to_datetime(monthly_return['Year'].astype(str) + '-' + monthly_return['Month'].astype(str) + '-01')
monthly_return['Month_Year'] = monthly_return['date'].dt.strftime('%b %Y')

# Plot with reduced labels
total_labels = len(monthly_return)
interval = 6  
ticks_positions = range(0, total_labels, interval)
ticks_labels = monthly_return['Month_Year'].iloc[ticks_positions]
plt.figure(figsize=(14,6))
sns.barplot(x='Month_Year', y='return', data=monthly_return)
plt.xticks(ticks=ticks_positions, labels=ticks_labels, rotation=45, ha='right')
plt.xlabel('Month-Year')
plt.ylabel('Average Return')
plt.title('Average Monthly Return')
plt.tight_layout()
plt.show()

# 4b. Bar Chart — Average Volume per Month 
df['daily_trading_volume'] = pd.to_numeric(df['daily_trading_volume'], errors='coerce')
monthly_volume = df.groupby(['Year', 'Month'])['daily_trading_volume'].mean().reset_index()
monthly_volume['date'] = pd.to_datetime(monthly_volume['Year'].astype(str) + '-' + monthly_volume['Month'].astype(str) + '-01')
monthly_volume['Month_Year'] = monthly_volume['date'].dt.strftime('%b %Y')

# Plot with reduced labels
total_labels_vol = len(monthly_volume)
interval_vol = 6
ticks_positions_vol = range(0, total_labels_vol, interval_vol)
ticks_labels_vol = monthly_volume['Month_Year'].iloc[ticks_positions_vol]
plt.figure(figsize=(14,6))
sns.barplot(x='Month_Year', y='daily_trading_volume', data=monthly_volume)
plt.xticks(ticks=ticks_positions_vol, labels=ticks_labels_vol, rotation=45, ha='right')
plt.xlabel('Month-Year')
plt.ylabel('Average Volume')
plt.title('Average Monthly Trading Volume')
plt.tight_layout()
plt.show()

# 5. Scatter Plot — Return vs Volume
df['return_sign'] = df['return'] >= 0
plt.figure(figsize=(10,6))
sns.scatterplot(x='daily_trading_volume', y='return', data=df, hue='return_sign', palette={True: 'blue', False: 'black'}, s=100, alpha=0.7)
plt.xlabel('Trading Volume')
plt.ylabel('Daily Return')
plt.title('Return vs Trading Volume')
plt.legend(title='Return Type', labels=['Positive Return', 'Negative or Zero Return'], loc='upper right')
plt.show()

# 6. Heat Map — Seasonality (Average Return by Month and Day of Week)
seasonality = df.groupby(['Month', 'Day_of_week'])['return'].mean().reset_index()
seasonality_pivot = seasonality.pivot(index='Day_of_week', columns='Month', values='return')

# Map day of week to weekday names
day_names = list(calendar.day_name)
seasonality_pivot.index = day_names[:len(seasonality_pivot.index)]
plt.figure(figsize=(12,6))
sns.heatmap(seasonality_pivot, annot=True, fmt=".4f", cmap='coolwarm')
plt.title('Seasonality in Daily Returns (Day of Week vs Month)')
plt.ylabel('Day of Week')
plt.xlabel('Month')
plt.show()