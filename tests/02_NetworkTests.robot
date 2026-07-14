*** Settings ***
Documentation    Test suite that validates the My Network section and
...              connection retrieval functionality.
...
...              Run in isolation:
...                robot --outputdir results --variable USERNAME:you@example.com \
...                      --variable PASSWORD:secret tests/02_NetworkTests.robot
...
...              Run all suites with timestamped report (Windows):
...                robot --outputdir results/%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2% \
...                      --variable USERNAME:you@example.com --variable PASSWORD:secret tests/
...
...              Run all suites with timestamped report (Linux/macOS):
...                robot --outputdir results/$(date +%%Y%%m%%d_%%H%%M%%S) \
...                      --variable USERNAME:you@example.com --variable PASSWORD:secret tests/
Library          Browser
Resource         ../resources/keywords/LinkedInKeywords.robot
Resource         ../resources/variables.robot

# Each test is self-contained: it logs in fresh and closes the browser,
# so suites can run independently in any order.
Test Setup       Run Keywords
...              Open LinkedIn Browser    AND
...              Login To LinkedIn    ${USERNAME}    ${PASSWORD}
Test Teardown    Close LinkedIn Browser


*** Test Cases ***
Navigate To My Network Section
    [Documentation]
    ...    *Pre-Condition(s):*
    ...    - User is authenticated (handled by Test Setup).
    ...    - The My Network page (linkedin.com/mynetwork/) is accessible.
    ...
    ...    *Execution:*
    ...    - Navigates directly to the My Network URL.
    ...    - Waits for the page scaffold layout to render.
    ...    - Asserts the page URL contains '/mynetwork'.
    ...
    ...    *Post-Condition(s):*
    ...    - The My Network page is fully loaded and visible.
    ...    - Browser session is closed by Test Teardown.
    [Tags]    network    navigation
    Go To My Network Page
    Get Url    contains    /mynetwork

Retrieve And Log All Connection Names
    [Documentation]
    ...    *Pre-Condition(s):*
    ...    - User is authenticated (handled by Test Setup).
    ...    - The account has at least one LinkedIn connection.
    ...    - The Connections page (linkedin.com/mynetwork/connections/) is accessible.
    ...
    ...    *Execution:*
    ...    - Navigates to the My Network page, then to the Connections sub-page.
    ...    - Scrolls through all paginated / lazy-loaded content until no new
    ...      connection cards appear.
    ...    - Extracts the display name from each connection card.
    ...    - Logs the total count and each individual name to the console
    ...      and to the Robot Framework execution log.
    ...    - Asserts that the returned list is non-empty.
    ...
    ...    *Post-Condition(s):*
    ...    - All connection names are recorded in the RF log and console output.
    ...    - The total connection count is visible in the log banner.
    ...    - Browser session is closed by Test Teardown.
    [Tags]    network    connections
    ${names}=    Retrieve And Log All Connections
    Should Not Be Empty    ${names}
    ...    msg=No connections were retrieved. Ensure the account has connections and selectors are up-to-date.
