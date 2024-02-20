*** Settings ***
Documentation    ZombiePLus API requests
Library    RequestsLibrary
Resource    ./helpers.resource
Variables   env.yaml

*** Variables ***
${FIXTURE_PATH}    /resources/fixtures/data

*** Keywords ***
Set Token
    ${data}    Get Fixture    
    ...    file_name=login    
    ...    scenario=success

    ${response}    POST    
    ...    url=${API_HOST}/sessions    
    ...    json=${data} 

    RETURN    ${response.json()}[token]

Get Company Id
    [Arguments]    ${company_name}
    
    ${token}      Set Token
    ${headers}    Create Dictionary    Authorization=Bearer ${token}
    ${params}     Create Dictionary    name=${company_name}

    ${response}    GET    url=${API_HOST}/companies   headers=${headers}    params=${params}
    
    LOG    ${response.json()}
    RETURN    ${response.json()}[data][0][id]

Create Media Payload
    [Arguments]    ${media_data}
    ${company_id}     Get Company Id    company_name=${media_data}[company]
    
    ${cover_exists}    Evaluate    expression=${media_data}.get("cover") is not None

    IF  ${cover_exists}
        ${file_tmp}=  Get File For Streaming Upload  
        ...    ${EXECDIR}${FIXTURE_PATH}${media_data}[cover]
        
        VAR    ${file}    ${file_tmp}    
    ELSE
        VAR    ${file}    ${EMPTY}    
    END
    
    ${movie_payload}    Delete Object From Json    
    ...    json_object=${media_data}    
    ...    json_path=cover
    ${movie_payload}    Delete Object From Json    
    ...    json_object=${movie_payload}    
    ...    json_path=company

    ${tmp_dict} 	Create Dictionary 	company_id=${company_id} 	
    ${movie_payload}    Add Object To Json
    ...    json_object=${movie_payload}    
    ...    json_path=@ 
    ...    object_to_add=${tmp_dict}
    
    ${file_payload} 	Create Dictionary    cover=${file} 

    ${result}    Create Dictionary    file_payload=${file_payload}    movie_payload=${movie_payload}
    RETURN    ${result}	

Create Movie
    [Arguments]    ${movie_data}

    ${token}          Set Token
    ${headers}        Create Dictionary    Authorization=Bearer ${token}
    
    ${payload}    Create Media Payload    media_data=${movie_data}
    POST     
    ...    url=${API_HOST}/movies
    ...    headers=${headers}
    ...    files=${payload}[file_payload]    
    ...    data=${payload}[movie_payload]
    ...    expected_status=201
    
Create Tvshow
    [Arguments]    ${tvshow_data}

    ${token}        Set Token
    ${headers}      Create Dictionary    Authorization=Bearer ${token}
    
    ${payload}    Create Media Payload    media_data=${tvshow_data}
    POST     
    ...    url=${API_HOST}/tvshows
    ...    headers=${headers}
    ...    files=${payload}[file_payload]    
    ...    data=${payload}[movie_payload]
    ...    expected_status=201
    

Create Lead
    [Arguments]    ${payload}
    POST    
    ...    url=${API_HOST}/leads    
    ...    json=${payload}    
    ...    expected_status=201
