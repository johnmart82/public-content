import pandas as pd
import re
import argparse
import os


parser = argparse.ArgumentParser()
parser.add_argument("outputFile", 
                    help="The path and filename for the output file.",
                    type=str)

parser.add_argument("--sourceUri", "-s",
                    help="Source URI for Microsoft CAF naming page.",
                    default="https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations")

args = parser.parse_args()

filePath = args.outputFile
cafURI = args.sourceUri

# Pull all of the tables from the Azure CAF into dataframes.
dataFrames = pd.read_html(cafURI)

# Concatenate all of the dataframes into a single dataframe.
df = pd.concat(dataFrames)
df = df.sort_values('Resource')


# Loop through all the rows in our dataframe to create the strings we need for naming.
## Replace all of the spaces with underscores in the Resource column.
## Add these to a list object we can work with.
nameList = []
for row in df.itertuples():
    #print(f'{re.sub(r"__","_",re.sub(r"[^a-zA-Z0-9_]","",row.Resource.replace(" ", "_")))} = "{row.Abbreviation}"')
    nameList.append(f'{re.sub(r"__","_",re.sub(r"[^a-zA-Z0-9_]","",row.Resource.replace(" ", "_")))} = "{row.Abbreviation}"')

# Strip out strings where there is < character which Microsoft put in for DNS things.
nameList = list(filter(lambda x: '<' not in x, nameList))

# Write out the scaffolding for our naming.tf file which will be populated with the Azure abbreviations.
with open(filePath, 'w') as file:
    # Write out the top lines of the locals for the list of naming abbreviations.
    ## We want structure not formatting we will use the Terraform fmt statement to clean up the file once we finish writing it.
    file.write("# Contains all constants for resource naming for this Terraform solution\n")
    file.write(f"# See: {cafURI}\n")
    file.write("locals {\n")
    file.write("azNaming = {\n")
    
    # Write out the content of the name list.
    for s in nameList:
        file.write(s+'\n')
    
    # Close out the locals.
    file.write("}\n}\n")

