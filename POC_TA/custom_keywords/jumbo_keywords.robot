***Settings***
Resource    ../resources/jumbo_resources.robot
Resource    ../resources/transverse/links.robot
Resource    ../resources/transverse/drivers.robot
Resource    ../resources/transverse/commun_keywords.robot

***Keywords***
# Actions Simples
# Mots-Clefs de la Homepage
Activate Seperate Arrival Point
    Element Should Not Be Visible 	 ${arrivalPointSelector}
    Mouse Over 	 ${checkboxSeperatePoints}    
    Click Element 	 ${checkboxSeperatePoints} 
    Sleep   1s 
    Element Should Be Visible 	 ${arrivalPointSelector}

Choose Age
    [Arguments]     ${locator}      ${age}
    Click Element 	 ${locator}
    ${age_value}=    Get Converted Age Value      ${age}
    Select From List By Value    ${locator}   ${age_value}
    ${selected_value}=    Get Selected List Value    ${locator}
    Should Be Equal     ${selected_value}    ${age_value}

Choose Date 
    [Arguments]     ${numberOfDays}     ${locator}
    ${date}     Get Formatted Date      ${numberOfDays}
    Element Should Be Visible 	 ${locator}
    Scroll Element Into View 	 //a[text()="Plus de détails"]
    Click Element       ${locator}
    Wait Until Element Is Visible 	 ${selectionCalendar}       3s       L'élément selectionCalendar n'est pas visible après 3 secondes
    Sleep   1s
    Click Element       (${selectionCalendar}//div[@data-visible="true"]//td[@aria-disabled="false" and text()="${date}"])[1]
    ${is_visible}=    Run Keyword And Return Status    Element Should Be Visible    //div[@role="presentation"]
    Run Keyword If    ${is_visible}     Click Element    //div[@role="presentation"]

Choose Time
    [Arguments]     ${time}     ${locator}
    Click Element 	 ${locator}
    ${value}=      Convert Time To Seconds    ${time}
    Select From List By Value    ${locator}    ${value}
    Verify Option Selection    ${locator}    ${value}
    
Choose Point
    [Arguments]     ${selectedPoint}     ${pointSelector}
    Element Should Be Visible      ${pointSelector} 
    Click Element   ${pointSelector}  
    Wait Until Element Is Visible     //li[text()="${selectedPoint}"]   10s     L'option ${selectedPoint} ne s'affiche pas dans les options après 10 secondes
    Click Element       //li[text()="${selectedPoint}"]
    Sleep   0.5s
    Element Should Not Be Visible     //li[text()="${selectedPoint}"]
    ${element_text}=    Get Text    ${pointSelector}
    Should Be Equal    ${element_text}    ${selectedPoint}

Close Cookies
    Wait Until Element Is Visible 	 ${Cookies} 	 20s	 
    ${isVisible}=   Run Keyword And Return Status    Element Should Be Visible     ${closeCookies}
    Sleep   1s
    Run Keyword If   ${isVisible}
    ...     Click Element       ${closeCookies}
    Wait Until Element Is Not Visible   ${cookies}      20s

Open Jumbo 
    Open Browser    ${JUMBO}    ${CHROME}    options=add_argument("--start-maximized")
    Wait until Element Is Visible       ${searchSubmitButton}      10s
    Title Should Be     Composant SEO Temporaire
  
Verify Jumbo Homepage
    Verify Jumbo Homepage Search Module
    Verify Jumbo Homepage Header
    Verify Jumbo Homepage Footer

Verify Jumbo Homepage Footer
    Element Should be Visible    ${footerContainer}
    Element Should be Visible    ${footerMenu1}
    Element Should be Visible    ${footerMenu2}
    Element Should be Visible    ${footerMenu3}
    Element Should be Visible    ${footerMenu4}

Verify Jumbo Homepage Header
    Element Should be Visible    ${headerContainer}
    Element Should be Visible 	 ${headerLogo}
    Element Should be Visible 	 ${faqLink}
    Element Should be Visible 	 ${languageSelection} 

Verify Jumbo Homepage Search Module
    Element Should be Visible    ${departurePointSelector}
    Element Should be Visible    ${departureDateSelector}
    Element Should be Visible    ${arrivalDateSelector}
    Element Should be Visible    ${departureTimeSelector}
    Element Should be Visible    ${arrivalTimeSelector}
    Element Should be Visible    ${promoCodeInput}
    Element Should be Visible    ${ageSelector}
    Element Should be Visible 	 ${searchSubmitButton}

Verify Option Selection
    [Arguments]     ${locator}     ${Value}
    ${selected_value}=    Get Selected List Value    ${locator}
    ${selected_value}=    Convert To Integer    ${selected_value}    
    Should Be Equal     ${selected_value}       ${value}

# Mots-Clefs lié aux étapes de Location
Verify Summary Band
    [Arguments]       ${expected_length}
    Wait Until Element Is Visible 	 ${step_band}   
    ${band_length}    Get Element Count    ${step_band_steps}
    Should Be Equal As Integers    ${band_length}       ${expected_length}

Verify Step Background Color
    [Arguments]     ${step}     ${step_BG_color}
    ${current_step}     Set Variable     (${step_band_steps})[${step}]/div[2]
    ${background_style}=    Get Element Attribute    ${current_step}    class
    ${elem}=    Get Class Name Background Color Element    ${background_style}    1
    ${background_color}=    Get Background Color   ${elem}
    Should Be Equal As Strings   '${background_color}'     ${step_BG_color}

Verify Current Step
    [Arguments]    ${current_step}
    ${first_step_BG_color}    Set Variable If    ${current_step} == 1
    ...    ${current_step_BG_color}
    ...    ${to_be_current_step_BG_color}
    ${second_step_BG_color}    Set Variable If    ${current_step} == 2
    ...    ${current_step_BG_color}
    ...    ${to_be_current_step_BG_color}

    ${third_step_BG_color}    Set Variable If    ${current_step} == 3
    ...    ${current_step_BG_color}
    ...    ${to_be_current_step_BG_color}  

    Verify Step Background Color     1       ${first_step_BG_color}
    Verify Step Background Color     2       ${second_step_BG_color}
    Verify Step Background Color     3       ${third_step_BG_color}

Get Class Name Background Color Element
    [Arguments]    ${class_string}      ${index}
    ${class_list}=    Split String    ${class_string}    separator= 
    ${desired_class}=    Set Variable    ${class_list}[${index}]
    [Return]    ${desired_class}
# Actions Composées
# Mots-Clefs de la Homepage
Launch Simple Jumbo Vehicule Search
    [Arguments]     ${depatureTime}     ${arrivalTime}     ${depatureIn}     ${arrivalIn}     ${selectedAge}    ${testDepartureDestination}
    Verify Jumbo Homepage
    Choose Point    ${testDepartureDestination}   ${departurePointSelector}
    Close Cookies
    Choose Date     ${depatureIn}     ${departureDateSelector}
    Choose Date     ${arrivalIn}     ${arrivalDateSelector}
    Sleep   0.25s
    Choose Time     ${depatureTime}    ${departureTimeSelector}
    Choose Time     ${arrivalTime}   ${arrivalTimeSelector}
    Sleep   0.25s
    Choose Age  ${ageSelector}  ${selectedAge}
    Click Submit Button     ${searchSubmitButton}
    Wait Until Element Is Visible 	 //select/option[@value="asc" and text()="Prix Croissant"]      20s     Le choix de véhicule n'est pas visible après 20 secondes
    Verify Summary Band     3

Lanuch Jumbo Vehicule Search With Different Arrival Point
    [Arguments]     ${depatureTime}     ${arrivalTime}     ${depatureIn}     ${arrivalIn}     ${selectedAge}    ${testDepartureDestination}    ${testArrivalDestination}
    
    Close Cookies
    Verify Jumbo Homepage
    Choose Point    ${testDepartureDestination}   ${departurePointSelector}
    Activate Seperate Arrival Point
    Choose Point    ${testArrivalDestination}   ${arrivalPointSelector}
    Choose Date     ${depatureIn}     ${departureDateSelector}
    Choose Date     ${arrivalIn}     ${arrivalDateSelector}
    Sleep   0.25s
    Choose Time     ${depatureTime}    ${departureTimeSelector}
    Choose Time     ${arrivalTime}   ${arrivalTimeSelector}
    Sleep   0.25s
    Choose Age  ${ageSelector}  ${selectedAge}
    Click Submit Button     ${searchSubmitButton}
    Wait Until Element Is Visible 	 //select/option[@value="asc" and text()="Prix Croissant"]      20s     Le choix de véhicule n'est pas visible après 20 secondes    
    Verify Summary Band     3
    Verify Submited Informations     ${depatureTime}     ${arrivalTime}     ${depatureIn}     ${arrivalIn}     ${selectedAge}    ${testDepartureDestination}    ${testArrivalDestination}

# Mots-Clefs liés au process de location
Verify Submited Informations
    [Arguments]     ${depatureTime}     ${arrivalTime}     ${depatureIn}     ${arrivalIn}     ${selectedAge}    ${testDepartureDestination}    ${testArrivalDestination}
    ${submited_departure_point}     Get Text 	 //div[@id="search-form-agency-departure" and @aria-labelledby="search-form-agency-departure"]
    ${submited_arrival_point}     Get Text 	 //div[@id="search-form-agency-arrival" and @aria-labelledby="search-form-agency-arrival"]
    ${submited_departure_date}     Get Element Attribute 	 //input[@name="dateDeparture"] 	 value
    ${expected_departure_date}	 Get Formatted Date      ${depatureIn}
    ${submited_arrival_date}     Get Element Attribute 	 //input[@name="dateArrival"] 	 value
    ${expected_arrival_date}	 Get Formatted Date      ${arrivalIn}
    
    ${depatureTime_sec}=      Convert Time To Seconds    ${depatureTime}
    ${arrivalTime}=      Convert Time To Seconds    ${arrivalTime}
    ${age_value}=    Get Converted Age Value      ${selectedAge}
    ${selected_value}=    Get Selected List Value    //select[@name="driverAge"]

    Should Be Equal    ${submited_departure_point}    ${testDepartureDestination}
    Should Be Equal    ${submited_arrival_point}    ${testArrivalDestination}
    Should Contain    ${submited_departure_date}     ${expected_departure_date}
    Should Contain    ${submited_arrival_date}     ${expected_arrival_date}
    Verify Option Selection    //select[@name="hourDeparture"] 	${depatureTime_sec} 
    Verify Option Selection    //select[@name="hourArrival"]     ${arrivalTime}     
    Should Be Equal     ${selected_value}    ${age_value}

# Mots-Clefs liés à l'étape "1. Choix du Véhicule"
Verify Vehicule Type Bande
    [Arguments]    ${nb_of_type}    ${preselected_type}
    Element Should Be Visible 	 ${vehicule_type_band}
    ${band_length}    Get Element Count    ${vehicule_types}
    Should Be Equal as Integers    ${band_length}    ${nb_of_type}
 	Run Keywords    Click Element 	 ${slide_right}	  AND    Sleep   1s    AND    Element Should Be Visible 	 (${vehicule_types})[${nb_of_type}]
 	Run Keywords    Click Element 	 ${slide_left} 	 AND    Sleep   1s    AND    Element Should Be Visible 	 (${vehicule_types})[1]
    Verify Selected Type    ${preselected_type}

Verify Selected Type
    [Arguments]    ${selected_type}
    ${selected_type_container}=    Set Variable    ${vehicule_type_band}//div[./button/div/p[text()="${selected_type}"]]
    ${selected_type_container_class}   Get Element Attribute 	 ${selected_type_container} 	 class
    ${count}=    Get Count    ${selected_type_container_class}    jss
    Should Be Equal As Integers     ${count}    4    Le type '${selected_type}' n'est pas le type sélectionné

Select Vehicule Type
    [Arguments]    ${selected_type}
    ${is_selected}    Run Keyword And Return Status    Verify Selected Type    ${selected_type}
    ${is_visible}    Run Keyword And Return Status    Element Should Be Visible    ${vehicule_type_band}//div[./button/div/p[text()="${selected_type}"]]
    Run Keyword If    '${is_visible}' == 'False'    Run Keywords
    ...    Slide Type Into View
    ...    AND    Log To Console    On est entré et on a is_visible : ${is_visible}
    ...    AND    Sleep    1s
    ...    ELSE    Log To Console    Le type '${selected_type}' est déjà visible

    Run Keyword If    "${is_selected}" == "False"    Run Keywords
    ...    Element Should Be Visible    ${vehicule_type_band}//div[./button/div/p[text()="${selected_type}"]]
    ...    AND    Click Element    ${vehicule_type_band}//div[./button/div/p[text()="${selected_type}"]]
    ...    ELSE    Log To Console    On a déjà sélectionné '${selected_type}'

    Verify Selected Type    ${selected_type}
    Sleep   0.5s
    
Slide Type Into View
    ${is_slide_left_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${slide_left}
    ${is_slide_right_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${slide_right}
    Run Keyword If    ${is_slide_left_visible}
    ...    Click Element    ${slide_left}
    ...    ELSE IF    ${is_slide_right_visible}
    ...    Click Element    ${slide_right}

Activate Filter
    [Arguments] 	 ${filter_categorie} 	 ${filter_value}
    Element Should Be Visible 	 ${filter}
    ${previous_vehicule_count}      Get Number Of Found Vehicule
    Element Should Be Visible 	 ${filter}//div[./div/p[text()="${filter_categorie}"]]
    Element Should Be Visible 	 //div[.//p[text()="${filter_value}"]]/span
    Click Element 	 //div[.//p[text()="${filter_value}"]]/span
    ${new_vehicule_count}      Get Number Of Found Vehicule
    Run Keyword If    '${previous_vehicule_count}' != '0' and '${new_vehicule_count}' != '0' 
    ...     Should Not Be Equal    ${previous_vehicule_count}    ${new_vehicule_count}

Get Number Of Found Vehicule
    #${element}   Set Variable    //p[contains(text(), "voitures trouvées")]
    ${element}   Set Variable    //p[contains(text(), "voiture") and contains(text(), "trouvée")]
    ${text}     Get Text 	 ${element}
    ${number_of_vehicule}    Split String    ${text}    ${SPACE}
    [Return]    ${number_of_vehicule}[0]

Choose Vehicule
    [Arguments]     ${vehicule_model}
    ${vehicule_container}    Set Variable    //div[@class="MuiBox-root css-1s03asw" and .//p[text()="${vehicule_model}"]]
    Scroll Element Into View    ${vehicule_container}
    Element Should Be Visible    ${vehicule_container}
    Click Element 	 ${vehicule_container}//button[.//p[text()="Réserver"]]

# Mots-Clefs liés à l'étape "2. Choix des options"
# Mots-Clefs liés à l'étape "3. Paiement"