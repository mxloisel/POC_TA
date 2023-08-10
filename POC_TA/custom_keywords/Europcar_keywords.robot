***Settings***
Resource    ../resources/europcar_resources.robot
Resource    ../resources/transverse/links.robot
Resource    ../resources/transverse/drivers.robot

*** Variables ***
${selectionCalendar}    //div[@aria-roledescription="datepicker" and @aria-label="Calendar"]
${firstAvailableDate}    (//div[@data-visible="true"]//td[@aria-disabled="false"])[50]
${secondAvailableDate}    (//div[@data-visible="true"]//td[@aria-disabled="false"])[51]

*** Keywords ***
Open Europcar PreProd  
    Open Browser    ${EUROPCAR_PPD}    ${CHROME}    options=add_argument("--start-maximized")
    Title Should Be     Location Voiture Martinique | Europcar

Open Europcar    
    Open Browser    ${EUROPCAR}    ${CHROME}    options=add_argument("--start-maximized")
    Title Should Be     Europcar martinique accueil

#Select Vehicule Type
#Activate Different Arrival Point
#Select Departure Point  
Select Departure Date
    Click element   ${departureDateSelector}
    Wait Until element Is Visible      ${selectionCalendar}
    Click Element   ${firstAvailableDate}
    Click Element   ${secondAvailableDate}
#Select Departure Time
#Select Arrival Point  
#Select Arrival Date
#Select Arrival Time
#Select Age
#Activate Promo Code
Select Vehicule By Type
    [Arguments]     ${vehicule_type}
    Sleep   2s
    Scroll Element into View    //div[@class="MuiBox-root css-1s03asw" and .//p[contains(text(), "${vehicule_type}")]]
    Element should be visible    //div[@class="MuiBox-root css-1s03asw" and .//p[contains(text(), "${vehicule_type}")]]//button[.//p[text()="Payer en ligne"]]
    Click Element    //div[@class="MuiBox-root css-1s03asw" and .//p[contains(text(), "${vehicule_type}")]]//button[.//p[text()="Payer en ligne"]]
Submit Search
    Click element   ${homepageSubmitSearchButton} 

