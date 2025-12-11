% 1. Load the data
:- consult('heart_data.pl').

% --- CARDIOLOGY RULES (The Expert Knowledge) ---

% Rule 1: High Cholesterol
% Medical standard: > 240 mg/dl is high.
high_cholesterol(ID) :-
    patient(ID, _, _, _, _, Chol, _, _, _, _, _, _, _, _, _),
    Chol > 240.

% Rule 2: High Blood Pressure (Hypertension)
% Medical standard: Resting BP > 140 is Stage 2 Hypertension.
high_bp(ID) :-
    patient(ID, _, _, Trestbps, _, _, _, _, _, _, _, _, _, _, _),
    Trestbps > 140.

% Rule 3: Exercise Induced Angina
% If exercise causes chest pain, this is a strong indicator.
has_exang(ID) :-
    patient(ID, _, _, _, _, _, _, _, _, Exang, _, _, _, _, _),
    Exang = 1.

% Rule 4: Significant ST Depression
% Oldpeak > 2.0 usually indicates ischemia.
bad_oldpeak(ID) :-
    patient(ID, _, _, _, _, _, _, _, _, _, Oldpeak, _, _, _, _),
    Oldpeak > 2.0.

% Rule 5: Major Vessels Colored (Fluoroscopy)
% If CA > 0, there is blockage.
blocked_vessels(ID) :-
    patient(ID, _, _, _, _, _, _, _, _, _, _, _, CA, _, _),
    CA > 0.

% --- DIAGNOSTIC ENGINE (Inference) ---

% Diagnosis 1: Critical Indicators
% IF Blocked Vessels detected OR Significant ST Depression -> SICK.
diagnose(ID, heart_disease) :-
    blocked_vessels(ID).

diagnose(ID, heart_disease) :-
    bad_oldpeak(ID).

% Diagnosis 2: The "Risk Factor" Combination
% IF (High Cholesterol OR High BP) AND Exercise Angina -> SICK.
diagnose(ID, heart_disease) :-
    (high_cholesterol(ID) ; high_bp(ID)), % ; means OR
    has_exang(ID).

% Diagnosis 3: Age Factor
% IF Age > 60 AND High BP -> SICK (Higher risk for elderly).
diagnose(ID, heart_disease) :-
    patient(ID, Age, _, _, _, _, _, _, _, _, _, _, _, _, _),
    Age > 60,
    high_bp(ID).

% Default: If no rules match, assume Healthy.
diagnose(ID, healthy) :-
    \+ diagnose(ID, heart_disease).

% --- VALIDATION HELPERS ---

% Check if our diagnosis matches the Ground Truth (Target column)
% Note: In this dataset, Target=1 is Disease, Target=0 is Healthy.
is_correct(ID) :-
    diagnose(ID, heart_disease),
    patient(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, 1).

is_correct(ID) :-
    diagnose(ID, healthy),
    patient(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, 0).