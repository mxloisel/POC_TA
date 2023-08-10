*** Variables ***
${BROWSER}    Chrome
${URL}        http://www.google.com

*** Keywords ***

Title Should Not Be
    [Arguments]  ${wrongTitle}
    ${actualTitle}=  Get Title
    Should Not Be Equal As Strings  ${actualTitle}  ${wrongTitle}

Open Google    
    Open Browser    ${URL}    ${BROWSER}
