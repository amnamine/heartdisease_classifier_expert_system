:- consult('heart_data.pl').

% --- MEDICAL EVIDENCE RULES ---

% Rule: Chest Pain Type 0 (Typical Angina) is the strongest predictor of disease in this dataset.
indicator(angina) :- 
    patient(ID, _, _, 0, _, _, _, _, _, _, _, _, _, _, _).

% Rule: Thallium Stress Test (Thal=3 is Reversable Defect => Sick)
indicator(thal_defect, ID) :-
    patient(ID, _, _, _, _, _, _, _, _, _, _, _, _, 3, _).

% Rule: Fluoroscopy showing Blocked Major Vessels (CA > 0)
indicator(blocked_vessels, ID) :-
    patient(ID, _, _, _, _, _, _, _, _, _, _, _, CA, _, _),
    CA > 0.

% Rule: Exercise Induced Angina (Exang=1)
indicator(exercise_pain, ID) :-
    patient(ID, _, _, _, _, _, _, _, _, 1, _, _, _, _, _).

% Rule: ST Depression (Oldpeak) indicates heart stress
indicator(high_oldpeak, ID) :-
    patient(ID, _, _, _, _, _, _, _, _, _, Oldpeak, _, _, _, _),
    Oldpeak > 1.5.

% --- DIAGNOSTIC ENGINE ---

% Diagnosis 1: The "Smoking Gun" (Blocked Vessels + Stress)
diagnose(ID, heart_disease) :-
    indicator(blocked_vessels, ID),
    indicator(high_oldpeak, ID).

% Diagnosis 2: Thallium Defect + Angina
diagnose(ID, heart_disease) :-
    indicator(thal_defect, ID),
    indicator(exercise_pain, ID).

% Diagnosis 3: Typical Angina Pectoris (CP=0)
% This specific type of pain is highly correlated with disease here.
diagnose(ID, heart_disease) :-
    patient(ID, _, _, 0, _, _, _, _, _, _, _, _, _, _, _).

% Diagnosis 4: "Silent" Progression
% No pain (Exang=0), but multiple blocked vessels
diagnose(ID, heart_disease) :-
    indicator(blocked_vessels, ID),
    patient(ID, _, _, _, _, _, _, _, _, 0, _, _, _, _, _).

% DEFAULT: If no severe rules match, the patient is healthy.
diagnose(ID, healthy) :-
    \+ diagnose(ID, heart_disease).