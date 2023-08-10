***Settings***
Resource    ../resources/contentful_resources.robot
Resource    ../resources/transverse/links.robot
Resource    ../resources/transverse/drivers.robot

*** Keywords ***

Open Contentful Login  
    Open Browser    ${CONTENTFUL_LOGIN}    ${CHROME}    options=add_argument("--start-maximized")
    Title Should Be     Log in - Contentful
    Wait until Element Is Visible       ${email_input}      10s

Log In To Contentful
    Wait until Element Is Visible       ${email_input}
    Click Element	 ${email_input}
    Input Text      ${email_input}      ${login}
    
    Wait until Element Is Visible       ${password_input}
    Click Element	 ${password_input}
    Input Text      ${password_input}      ${password}    

    Wait Until Element Is Visible       ${login_submit_button}
    Click Element       ${login_submit_button}  