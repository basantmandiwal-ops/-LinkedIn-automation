*** Variables ***
# ─── URLs ────────────────────────────────────────────────────────────────────
${LINKEDIN_URL}         https://www.linkedin.com
${LOGIN_URL}            https://www.linkedin.com/login
${NETWORK_URL}          https://www.linkedin.com/mynetwork/
${CONNECTIONS_URL}      https://www.linkedin.com/mynetwork/connections/

# ─── Browser Configuration ───────────────────────────────────────────────────
${BROWSER}              chromium
${HEADLESS}             false
${VIEWPORT_WIDTH}       1920
${VIEWPORT_HEIGHT}      1080

# ─── Timeouts ────────────────────────────────────────────────────────────────
${TIMEOUT}              30s
${SHORT_TIMEOUT}        5s
${SCROLL_PAUSE}         2s

# ─── Credentials (pass via CLI: --variable USERNAME:email --variable PASSWORD:pass)
${USERNAME}             ${EMPTY}
${PASSWORD}             ${EMPTY}
