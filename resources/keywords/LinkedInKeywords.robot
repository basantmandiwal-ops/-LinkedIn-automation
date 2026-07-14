*** Settings ***
Documentation    Composite, reusable keywords that combine page-object interactions
...              into higher-level actions consumed by the test suites.
Library          Browser
Resource         ../variables.robot
Resource         ../pages/LoginPage.robot
Resource         ../pages/NetworkPage.robot


*** Keywords ***
# Opens a new Chromium browser, creates a context with the configured viewport,
# opens a blank page, and applies the global default timeout for all operations.
Open LinkedIn Browser
    New Browser    ${BROWSER}    headless=${HEADLESS}
    New Context
    ...    viewport={'width': ${VIEWPORT_WIDTH}, 'height': ${VIEWPORT_HEIGHT}}
    ...    acceptDownloads=true
    New Page    ${LINKEDIN_URL}
    Set Browser Timeout    ${TIMEOUT}

# Performs the complete login sequence:
#   1. Navigates to the login page.
#   2. Fills in the email and password fields.
#   3. Submits the form.
#   4. Waits until the global nav confirms successful authentication.
Login To LinkedIn
    [Arguments]    ${username}    ${password}
    Go To Login Page
    Enter Email       ${username}
    Enter Password    ${password}
    Click Sign In
    Wait Until Logged In

# Navigates to My Network, then to the Connections sub-page,
# scrolls through all paginated/lazy-loaded results, retrieves every
# connection name, and logs each one to the console and the RF log.
# Returns the full list of names for downstream assertions.
Retrieve And Log All Connections
    Go To My Network Page
    Go To Connections Page
    Load All Connections
    ${names}=    Get Connection Names
    ${total}=    Get Length    ${names}
    Log    \n========== LinkedIn Connections (${total} total) ==========    console=True
    FOR    ${name}    IN    @{names}
        Log    • ${name}    console=True
    END
    Log    ============================================================    console=True
    RETURN    ${names}

# Closes every open browser context and browser instance, ensuring
# no stale sessions remain after a test or suite completes.
Close LinkedIn Browser
    Close Browser    ALL
