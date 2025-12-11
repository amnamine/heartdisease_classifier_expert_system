:- consult('heart_data.pl').

% --- MEDICAL EVIDENCE INDICATORS ---

% Indicator: Significant Chest Pain (Type 0 = Typical Angina)
indicator(typical_angina, ID) :- 
    patient(ID, _, _, 0, _, _, _, _, _, _, _, _, _, _, _).

% Indicator: Thallium Stress Test (Thal=3 is Reversable Defect, Thal=2 is Normal)
indicator(thal_defect, ID) :-
    patient(ID, _, _, _, _, _, _, _, _, _, _, _, _, 3, _).

indicator(thal_normal, ID) :-
    patient(ID, _, _, _, _, _, _, _, _, _, _, _, _, 2, _).

% Indicator: Fluoroscopy (CA = Number of major vessels colored by flourosopy)
% CA > 0 suggests blockage.
indicator(blocked_vessels, ID) :-
    patient(ID, _, _, _, _, _, _, _, _, _, _, _, CA, _, _),
    CA > 0.

indicator(clear_vessels, ID) :-
    patient(ID, _, _, _, _, _, _, _, _, _, _, _, 0, _, _).

% Indicator: Exercise Induced Angina (1 = Yes, 0 = No)
indicator(exercise_pain, ID) :-
    patient(ID, _, _, _, _, _, _, _, _, 1, _, _, _, _, _).

indicator(no_exercise_pain, ID) :-
    patient(ID, _, _, _, _, _, _, _, _, 0, _, _, _, _, _).

% Indicator: ST Depression (Oldpeak)
% > 2.0 is a strong sign of pathology. < 1.0 is generally safe.
indicator(high_oldpeak, ID) :-
    patient(ID, _, _, _, _, _, _, _, _, _, Oldpeak, _, _, _, _),
    Oldpeak > 2.0.

indicator(low_oldpeak, ID) :-
    patient(ID, _, _, _, _, _, _, _, _, _, Oldpeak, _, _, _, _),
    Oldpeak < 1.0.

% --- DIAGNOSTIC ENGINE (RULES) ---

% RULE 1: High Severity (Blocked Vessels + Stress Defect)
% Strongest predictor: Physical blockage visible + Thallium defect.
diagnose(ID, heart_disease) :-
    indicator(blocked_vessels, ID),
    indicator(thal_defect, ID).

% RULE 2: The "Silent" Ischemia Rule (Blocked Vessels + High ST Depression)
% Even if they don't complain of pain, the biology shows stress.
diagnose(ID, heart_disease) :-
    indicator(blocked_vessels, ID),
    indicator(high_oldpeak, ID).

% RULE 3: Angina with Supporting Evidence
% Chest pain alone isn't enough. But Pain + Exercise Pain + Blockage is.
diagnose(ID, heart_disease) :-
    indicator(typical_angina, ID),
    indicator(exercise_pain, ID),
    indicator(blocked_vessels, ID).

% RULE 4: Explicit Healthy Rule
% If vessels are clear, Thal is normal, and ST depression is low -> Healthy.
% We prioritize this definition of health.
diagnose(ID, healthy) :-
    indicator(clear_vessels, ID),
    indicator(thal_normal, ID),
    indicator(low_oldpeak, ID).

% DEFAULT FALLBACK
% If strict disease rules don't match, and strict healthy rules don't match,
% we use the "negation as failure" fallback based on risk factors.
diagnose(ID, healthy) :-
    \+ diagnose(ID, heart_disease).