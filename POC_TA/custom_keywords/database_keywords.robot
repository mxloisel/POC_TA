*** Settings ***
Library    SSHLibrary
Library    SSHTunnelLibrary
Library    DatabaseLibrary
Library    OperatingSystem
Library    Process 

Resource    ../resources/transverse/database_info.robot

*** Keywords ***
Initialize SSH Tunnel
    # Set up the SSH tunnel using the SSH key file through the bastion host
    # Open SSH connection using the SSH key file
    Open Connection    host=${SSH_HOST}     port=${SSH_PORT}    timeout=60s
    Login With Public Key    ${SSH_USERNAME}    ${SSH_KEY_FILE}

Load Data Dump
    [Arguments]     ${dump_file}
    Initialize SSH Tunnel
    ${tunnel_cmd}=    Set Variable    mysql --host=${DB_HOST} --user=${DB_USER} --password=${DB_PASS} ${DB_NAME} -u ${DB_USER} -p${DB_PASS} ${DB_NAME} < ${dump_file}'
    ${output}=    Execute Command    ${tunnel_cmd}

    log to console      Output = ${output}
    # Close the database connection
    Disconnect From Database

    # Close the SSH tunnel
    Close All Connections

Request To Database  
    [Arguments]     ${request}
    Initialize SSH Tunnel
    Execute Command     mysql --host=${DB_HOST} --user=${DB_USER} --password=${DB_PASS} ${DB_NAME} -e '${request}'

Execute SQL Request Through Command
    [Arguments]     ${request}
    # Initialize the SSH tunnel through the bastion host
    Initialize SSH Tunnel
    Request To Database      ${request}
    # Test MySQL Connection Via SSH Tunnel
    # Connect to our database
    # Connect To Database    pymysql    ${DB_NAME}    ${DB_USER}    ${DB_PASS}    ${DB_HOST}    ${DB_PORT}

    # Perform some queries or actions on the database
    # ${result}    Execute SQL String    Select COUNT(*) from booking

    # Close the database connection
    Disconnect From Database

    # Close the SSH tunnel
    Close All Connections
