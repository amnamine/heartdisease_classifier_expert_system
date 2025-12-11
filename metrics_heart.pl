:- consult('heart_expert.pl').

% --- CONFUSION MATRIX ---

tp(Count) :-
    findall(ID, (diagnose(ID, heart_disease), patient(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, 1)), L),
    length(L, Count).

tn(Count) :-
    findall(ID, (diagnose(ID, healthy), patient(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, 0)), L),
    length(L, Count).

fp(Count) :-
    findall(ID, (diagnose(ID, heart_disease), patient(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, 0)), L),
    length(L, Count).

fn(Count) :-
    findall(ID, (diagnose(ID, healthy), patient(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, 1)), L),
    length(L, Count).

% --- REPORT ---

print_report :-
    tp(TP), tn(TN), fp(FP), fn(FN),
    Total is TP + TN + FP + FN,
    Correct is TP + TN,
    (Total > 0 -> Accuracy is (Correct / Total) * 100 ; Accuracy is 0),
    (TP + FP > 0 -> Precision is (TP / (TP + FP)) * 100 ; Precision is 0),
    (TP + FN > 0 -> Recall is (TP / (TP + FN)) * 100 ; Recall is 0),
    
    write('=========================================='), nl,
    write('      HEART DISEASE EXPERT SYSTEM REPORT  '), nl,
    write('=========================================='), nl,
    format('Total Patients: ~w', [Total]), nl, nl,
    format('True Positives (Caught Disease):   ~w', [TP]), nl,
    format('True Negatives (Cleared Healthy):  ~w', [TN]), nl,
    format('False Positives (False Alarm):     ~w', [FP]), nl,
    format('False Negatives (Missed Case):     ~w', [FN]), nl, nl,
    format('ACCURACY:  ~2f %', [Accuracy]), nl,
    format('PRECISION: ~2f %', [Precision]), nl,
    format('RECALL:    ~2f %', [Recall]), nl,
    write('=========================================='), nl.