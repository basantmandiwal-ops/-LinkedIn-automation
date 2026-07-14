*** Settings ***
Documentation    Test suite that validates LinkedIn authentication.
...
...              Run in isolation:
...                robot --outputdir results --variable USERNAME:you@example.com \
...                      --variable PASSWORD:secret tests/01_LoginTests.robot
...
...              Run all suites with timestamped report:
...                robot --outputdir results/%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2% \
...                      --variable USERNAME:you@example.com --variable PASSWORD:secret tests/
Library          Browser
Resource         ../resources/keywords/LinkedInKeywords.robot
Resource         ../resources/variables.robot

Test Setup       Open LinkedIn Browser
Test Teardown    Close LinkedIn Browser


*** Test Cases ***
Successful Login With Valid Credentials
    [Documentation]
    ...    *Pre-Condition(s):*
    ...    - A valid LinkedIn account exists and credentials are supplied via
    ...      CLI variables (--variable USERNAME:... --variable PASSWORD:...).
    ...    - Network access to linkedin.com is available.
    ...    - Chromium browser is installed (run: rfbrowser init).
    ...
    ...    *Execution:*
    ...    - Opens a new Chromium browser window.
    ...    - Navigates to https://www.linkedin.com/login.
    ...    - Enters the provided email and password.
    ...    - Clicks the Sign In button.
    ...    - Waits for the global navigation bar to confirm successful login.
    ...    - Asserts the redirected URL matches a post-login LinkedIn path.
    ...
    ...    *Post-Condition(s):*
    ...    - User is authenticated; browser is on the LinkedIn home feed or
    ...      another post-login page.
    ...    - Browser session is closed by Test Teardown regardless of outcome.
    [Tags]    login    smoke
    Login To LinkedIn    ${USERNAME}    ${PASSWORD}
    Landing Page Should Be Feed
