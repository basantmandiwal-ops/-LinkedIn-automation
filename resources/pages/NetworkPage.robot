*** Settings ***
Documentation    Page Object for the LinkedIn My Network and Connections pages.
...              Contains all selectors and low-level keywords scoped to
...              /mynetwork/ and /mynetwork/connections/.
Library          Browser
Resource         ../variables.robot


*** Variables ***
# ─── Selectors ───────────────────────────────────────────────────────────────
# My Network landing page
${NETWORK_LAYOUT}           css=.scaffold-layout

# Connections list page
${CONNECTION_CARD}          css=.mn-connection-card
${CONNECTION_NAME}          css=.mn-connection-card__name
${SHOW_MORE_BUTTON}         css=button.scaffold-finite-scroll__load-button

# Fallback: infinite-scroll sentinel used when no explicit button exists
${SCROLL_SENTINEL}          css=.scaffold-finite-scroll__content


*** Keywords ***
# Navigates directly to the My Network URL and waits for the
# page scaffold to render, confirming the page is ready.
Go To My Network Page
    Go To                       ${NETWORK_URL}
    Wait For Elements State     ${NETWORK_LAYOUT}    visible    timeout=${TIMEOUT}

# Navigates to the Connections sub-page and waits for at least
# one connection card to appear before returning.
Go To Connections Page
    Go To                       ${CONNECTIONS_URL}
    Wait For Elements State     ${CONNECTION_CARD}    visible    timeout=${TIMEOUT}

# Repeatedly clicks the "Show more results" button (if present) and
# scrolls to the bottom to trigger infinite-scroll loading.
# Stops when no new content appears or the button is gone.
Load All Connections
    ${prev_count}=    Set Variable    0
    WHILE    True    limit=100
        # Scroll to bottom to trigger lazy-load / infinite scroll
        Scroll To Element    ${SCROLL_SENTINEL}
        Sleep    ${SCROLL_PAUSE}

        # Click "Show more" button if it is visible
        ${has_button}=    Run Keyword And Return Status
        ...    Wait For Elements State    ${SHOW_MORE_BUTTON}    visible    timeout=${SHORT_TIMEOUT}
        IF    ${has_button}
            Click    ${SHOW_MORE_BUTTON}
            Sleep    ${SCROLL_PAUSE}
        END

        # Check whether new cards appeared; exit if count is stable
        ${cards}=      Get Elements    ${CONNECTION_CARD}
        ${cur_count}=  Get Length      ${cards}
        IF    ${cur_count} == ${prev_count}    BREAK
        ${prev_count}=    Set Variable    ${cur_count}
    END

# Collects the display name text from every visible connection card
# and returns them as a Robot Framework list.
Get Connection Names
    ${elements}=    Get Elements    ${CONNECTION_NAME}
    ${names}=       Create List
    FOR    ${el}    IN    @{elements}
        ${raw}=     Get Text    ${el}
        ${name}=    Strip String    ${raw}
        Append To List    ${names}    ${name}
    END
    RETURN    ${names}

# Asserts that at least one connection card is present on the page,
# failing with a meaningful message if none are found.
Connection Cards Should Be Present
    ${count}=    Get Element Count    ${CONNECTION_CARD}
    Should Be True    ${count} > 0
    ...    msg=No connection cards found on the connections page. Ensure the account has at least one connection.
