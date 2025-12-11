import pandas as pd

def clean_data():
    # Load the dataset
    df = pd.read_csv("heart.csv")
    
    # Write to Prolog file
    with open("heart_data.pl", "w") as f:
        f.write("% --- HEART DISEASE KNOWLEDGE BASE ---\n")
        f.write("% Format: patient(ID, Age, Sex, CP, Trestbps, Chol, FBS, RestECG, Thalach, Exang, Oldpeak, Slope, CA, Thal, Target).\n")
        f.write("% NOTE: In this dataset, Target 0 = Disease, Target 1 = Healthy.\n\n")
        
        for index, row in df.iterrows():
            p_id = f"p{index}"
            # Write fact
            f.write(f"patient({p_id}, {int(row['age'])}, {int(row['sex'])}, {int(row['cp'])}, "
                    f"{int(row['trestbps'])}, {int(row['chol'])}, {int(row['fbs'])}, {int(row['restecg'])}, "
                    f"{int(row['thalach'])}, {int(row['exang'])}, {float(row['oldpeak'])}, {int(row['slope'])}, "
                    f"{int(row['ca'])}, {int(row['thal'])}, {int(row['target'])}).\n")
    
    print("Success! 'heart_data.pl' has been generated.")

if __name__ == "__main__":
    clean_data()