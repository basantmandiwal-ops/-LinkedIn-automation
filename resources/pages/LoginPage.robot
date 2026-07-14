*** Settings ***
Documentation    Page Object for the LinkedIn Login page.
...              Contains all selectors and low-level keywords scoped to /login.
Library          Browser
Resource         ../variables.robot


*** Variables ***
# ─── Selectors ───────────────────────────────────────────────────────────────
${EMAIL_FIELD}          id=username
${PASSWORD_FIELD}       id=password
${SUBMIT_BUTTON}        button[type="submit"]
${NAV_BAR}              css=.global-nav__nav


*** Keywords ***
# Navigates to the LinkedIn login URL and waits until the email field
# is visible, confirming the page has fully loaded.
Go To Login Page
    Go To                       ${LOGIN_URL}
    Wait For Elements State     ${EMAIL_FIELD}    visible    timeout=${TIMEOUT}

# Types the given email address into the username/email input field.
Enter Email
    [Arguments]    ${email}
    Fill Text    ${EMAIL_FIELD}    ${email}

# Types the given password into the password input field.
Enter Password
    [Arguments]    ${password}
    Fill Text    ${PASSWORD_FIELD}    ${password}

# Clicks the sign-in submit button to submit the login form.
Click Sign In
    Click    ${SUBMIT_BUTTON}

# Waits for the global navigation bar to appear, which confirms
# that authentication was successful and the feed is loaded.
Wait Until Logged In
    Wait For Elements State    ${NAV_BAR}    visible    timeout=${TIMEOUT}

# Verifies the current page URL contains '/feed', confirming
# the user has been redirected to the home feed after login.
Landing Page Should Be Feed
    Get Url    matches    .*/(feed|mynetwork|in/).*
