import pandas as pd

file_path = "Data1/hybrid_manufacturing_categorical.csv"

df = pd.read_csv(file_path)

print(df.head())
print("\nDataset shape:")
print(df.shape)

print("\nColumns:")
print(df.columns.tolist())

print("\nData types:")
print(df.dtypes)

print("\nMissing values:")
print(df.isnull().sum())
print("\nJob Status values:")
print(df["Job_Status"].value_counts())

print("\nOperation Type values:")
print(df["Operation_Type"].value_counts())

print("\nOptimization Category values:")
print(df["Optimization_Category"].value_counts())

print("\nDuplicate Job IDs:")
print(df["Job_ID"].duplicated().sum())