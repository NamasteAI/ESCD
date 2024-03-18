% Define symptoms that are associated with the virsus infection
symptom(1,fever).
symptom(2,dry_cough).
symptom(3,tiredness).
symptom(4,aches_and_pains).
symptom(5,sore_throat).
symptom(6,diarrhoea).
symptom(7,conjunctivitis).
symptom(8,headache).
symptom(9,anosmia_hyposmia).
symptom(10,running_nose).
symptom(11,difficulty_breathing).
symptom(12,chest_pain).
symptom(13,loss_of_speech_or_movement).


% Define Severity
severity(mild).
severity(moderate).
severity(severe).


% Responses based on symptoms, past history of events and pre-existing conditions. 
response_asymptomatic(PatientName, ContactWithPositive, InCrowdedPlaces) :-
    (( ContactWithPositive = yes ; InCrowdedPlaces = yes) ->
        format('~w is asymptomatic and less likely infected by the virus. However, he/she was either in close contact with a positive person or was at a crowded place. It is advised to stay at home for the next 14 days to observe if any symptoms appear and seek medical attention.', [PatientName]),
        nl
    ;   
        format('~w is asymptomatic and less likely infected by the virus. It is advised to follow general guidelines.', [PatientName]),
        nl
    ).

response_severe_infection(PatientName) :-
    format('~w has symptoms which are at high-risk category and may have a severe virus infection. Seek immediate medical attention.', [PatientName]),
    nl.

response_high_risk(PatientName, PatientGender) :-
    format('~w has pre-existing conditions and/or above 70 years old,  and has mild and/or moderate symptoms and may have a virus infection.', [PatientName]),
    nl,
    PatientGender = male ->
    (   write('Males in these groups also appeared to be at a slightly higher risk than females'),
        nl
    ),
    write('Please seek immediate medical assistance.').

response_contact_with_positive(PatientName) :-
    format('~w has moderate symptoms and recent contact with a positive case. Home isolate and seek medical advice.', [PatientName]),
    nl.

response_in_crowded_places(PatientName) :-
    format('~w has moderate symptoms and has been in crowded places. Monitor symptoms closely, especially high-risk category symptoms, and if the symptoms persist or worsen, seek medical attention immediately.', [PatientName]),
    nl.

response_low_risk(PatientName) :-
    format('~w has low-risk symptoms with mild severity and is less likely to have a virus infection. However, monitor body temperature, take general medicines to manage symptoms, stay at home, observe social distancing.', [PatientName]),
    nl.

response_less_common_symptoms(PatientName) :-
    format('~w has less common symptoms and is less likely to have the virus infection. However, consult a medical practitioner to treat these symptoms.', [PatientName]),
    nl.

response_unlikely_infection(PatientName) :-
    format('Based on the information provided, it is less likely that ~w has the virus infection. However, follow general guidelines to prevent from getting infected.', [PatientName]),
    nl.

% Main evaluation predicate which does the assesment based on symptoms, past history of events and pre-existing conditions. 
evaluate_patient_data(PatientName, Symptoms, ContactWithPositive, InCrowdedPlaces, Above70, PreExistingConditions, PatientGender) :-
    (Symptoms = [] ->
        response_asymptomatic(PatientName, ContactWithPositive, InCrowdedPlaces)

    ;   has_serious_high_risk_symptoms(Symptoms) ->
        response_severe_infection(PatientName)

    ;   (has_moderate_symptoms(Symptoms) ; has_mild_symptoms(Symptoms)), (Above70 = yes ; PreExistingConditions = yes) ->
        response_high_risk(PatientName, PatientGender)

    ;   has_moderate_symptoms(Symptoms), ContactWithPositive = yes ->
        response_contact_with_positive(PatientName)

    ;   has_moderate_symptoms(Symptoms), InCrowdedPlaces = yes ->
        response_in_crowded_places(PatientName)

    ;   has_low_risk_symptoms(Symptoms) ->
        response_low_risk(PatientName)

    ;   has_less_common_symptoms(Symptoms) ->
        response_less_common_symptoms(PatientName)

    ;   response_unlikely_infection(PatientName)

    ).




% Define rules for symptom severity assesment
has_serious_high_risk_symptoms(Symptoms) :-
    member(difficulty_breathing-_, Symptoms) ;
    member(chest_pain-_, Symptoms) ;
    member(loss_of_speech_or_movement-_, Symptoms);
    member(fever-severe,Symptoms).

has_moderate_symptoms(Symptoms) :-
    member(_-moderate, Symptoms).

has_mild_symptoms(Symptoms) :-
    member(_-mild, Symptoms).

has_low_risk_symptoms(Symptoms) :- 
    member(fever-mild, Symptoms);
    member(dry_cough-mild,Symptoms);
    member(tiredness-mild,Symptoms).

has_less_common_symptoms(Symptoms) :-
    member(aches_and_pains-_, Symptoms) ;
    member(sore_throat-_, Symptoms) ;
    member(diarrhoea-_, Symptoms) ;
    member(conjunctivitis-_, Symptoms) ;
    member(headache-_, Symptoms) ;
    member(anosmia_hyposmia-_, Symptoms).

is_asymptomatic(Symptoms) :-
    member(asymptomatic-_,Symptoms).

% General advisory guidelines.
display_general_guidelines :- 
    nl,nl,
    writeln('## GENERAL GUIDELINES:'),
    writeln('-> Practice good hand hygiene by washing hands frequently.'),
    writeln('-> Wear masks, especially in crowded places or when in close proximity to others.'),
    writeln('-> Maintain social distancing to reduce the risk of virus transmission.'),
    writeln('-> Stay informed about local health guidelines and follow them diligently.'),
    writeln('-> Follow local health authorities\' guidelines for self-isolation and symptom management.'),
    writeln('-> Be aware of the potential for transmission even before symptoms appear.'),
    writeln('-> Follow preventive measures consistently to protect oneself and others.').
    

% Take user inputs interactively 
% PatientName, PatientAge, PatientGender, Symptoms, ContactWithPositive, InCrowdedPlaces, Above70, PreExistingConditions
begin_diagnosis :-
    write('What is your name? '), read(PatientName),
    write('What is your age?'), read(PatientAge),
    (PatientAge >= 70 ->
        Above70 = yes
        ;
        Above70 = no
    ),
    write('What is your gender? (male/female/other)'), read(PatientGender), nl,
    write('List of common symptoms of virus infection: '), nl,
    list_symptoms(1),
    read_symptoms(Symptoms),
    write('Have you had close contact with anyone who tested positive for the virus? (yes/no)'), read(ContactWithPositive),
    write('Have you been in crowded places recently? (yes/no)'), read(InCrowdedPlaces),
    write('Do you have pre-existing health conditions (hypertension, diabetes, cardiovascular disease, chronic respiratory disease, or cancer)? (yes/no)'), read(PreExistingConditions),
    nl,nl,
    write('# DIAGNOSIS:'), nl,
    % call the main predicate rules for diagnosis
    evaluate_patient_data(PatientName, Symptoms, ContactWithPositive, InCrowdedPlaces, Above70, PreExistingConditions, PatientGender),
    display_general_guidelines.

list_symptoms(N) :-
    symptom(N, Symptom),
    format('~w. ~w~n', [N, Symptom]),
    NextN is N + 1,
    list_symptoms(NextN).

list_symptoms(_).

% Predicate to read symptoms and their severity
read_symptoms(Symptoms) :-
    nl,
    write('Are you experiencing any of these symptoms listed above? (yes/no)'), read(Asymptomatic),
    (Asymptomatic = no -> 
        Symptoms = []
    ;
        write('Please select the symptoms and severity of symptoms you are experiencing. '), nl,
        read_symptoms([], Symptoms)
    ).

     
read_symptoms(Accumulator, Symptoms) :-
    write('Enter the number corresponding to the symptom (or 0 to finish): '), read(Number),
    (Number = 0 ->
        Symptoms = Accumulator
    ;
        symptom(Number, Symptom),
        write('Enter the severity corresponding to the symptom (mild, moderate, severe): '), read(Severity),
        (severity(Severity) ->
            append(Accumulator, [Symptom-Severity], UpdatedList),
            read_symptoms(UpdatedList, Symptoms)
        ;
            write('Invalid severity. Please enter a valid severity (mild, moderate, severe).'), nl,
            read_symptoms(Accumulator, Symptoms)
        )
    ).