#Import Pandas and give it an alias.
import pandas as pd

# Pull all of the tables from the Azure CAF into dataframes.
dataFrames = pd.read_html('https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations')

# Concatenate all of the dataframes into a single dataframe.
df = pd.concat(dataFrames)

# Loop through all the rows in our dataframe to create the strings we need for naming.
## Replace all of the spaces with underscores in the Resource column.
for row in df.itertuples():
    print(f'{row.Resource.replace(" ", "_")} = "{row.Abbreviation}"')

