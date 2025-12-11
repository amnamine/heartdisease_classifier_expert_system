import pandas as pd

# 1. Load the dataset
df = pd.read_csv("heart.csv")

# 2. Open a new file to write the Prolog facts
output_file = "heart_data.pl"

print(f"Converting heart.csv to {output_file}...")

with open(output_file, "w") as f:
    f.write("% --- HEART PATIENT KNOWLEDGE BASE ---\n")
    # Explanation of columns for the Prolog file header
    f.write("% Format: patient(Id, Age, Sex, CP, Trestbps, Chol, FBS, RestECG, Thalach, Exang, Oldpeak, Slope, CA, Thal, ActualOutcome).\n\n")
    
    for index, row in df.iterrows():
        # Unique ID: p0, p1, p2...
        p_id = f"p{index}"
        
        # Extract values (casting to int/float to be safe)
        age = int(row['age'])
        sex = int(row['sex'])
        cp = int(row['cp'])             # Chest Pain Type
        trestbps = int(row['trestbps']) # Resting Blood Pressure
        chol = int(row['chol'])         # Cholesterol
        fbs = int(row['fbs'])           # Fasting Blood Sugar > 120 (1=true)
        restecg = int(row['restecg'])
        thalach = int(row['thalach'])   # Max Heart Rate
        exang = int(row['exang'])       # Exercise Induced Angina (1=yes)
        oldpeak = float(row['oldpeak']) # ST depression induced by exercise
        slope = int(row['slope'])
        ca = int(row['ca'])             # Number of major vessels (0-3)
        thal = int(row['thal'])
        target = int(row['target'])     # 1 = Disease, 0 = Healthy
        
        # Write the fact
        fact = f"patient({p_id}, {age}, {sex}, {cp}, {trestbps}, {chol}, {fbs}, {restecg}, {thalach}, {exang}, {oldpeak}, {slope}, {ca}, {thal}, {target}).\n"
        f.write(fact)

print("Success! 'heart_data.pl' created.")