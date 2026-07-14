# LinkedIn Robot Framework Automation

Automated LinkedIn test suite built with [Robot Framework](https://robotframework.org/) and the [Browser library](https://robotframework-browser.org/) (Playwright-based).

## Features

- Login to LinkedIn with credentials passed securely via CLI
- Navigate to the My Network section
- Retrieve and log all connection names (handles pagination & infinite scroll)
- Page Object Model design — selectors isolated per page
- Each test is fully self-contained and can run in any order
- Timestamped report saving per execution

---

## Project Structure

```
linkedin-robot/
├── resources/
│   ├── variables.robot                  # URLs, timeouts, browser config, credentials
│   ├── pages/
│   │   ├── LoginPage.robot              # Page Object: login page selectors & keywords
│   │   └── NetworkPage.robot            # Page Object: network/connections selectors & keywords
│   └── keywords/
│       └── LinkedInKeywords.robot       # Composite keywords used by test suites
├── tests/
│   ├── 01_LoginTests.robot              # Test suite: authentication
│   └── 02_NetworkTests.robot            # Test suite: My Network & connections
├── results/                             # Generated reports (git-ignored)
├── requirements.txt
├── .gitignore
└── README.md
```

---

## Prerequisites

- Python 3.8+
- Node.js 16+ (required by the Browser library internally)

---

## Installation

```bash
# 1. Install Python dependencies
pip install -r requirements.txt

# 2. Install Playwright browsers (one-time setup)
rfbrowser init
```

---

## Running the Tests

### Run all tests (with timestamped report)

**Linux / macOS:**
```bash
robot --outputdir results/$(date +%Y%m%d_%H%M%S) \
      --variable USERNAME:you@example.com \
      --variable PASSWORD:yourpassword \
      tests/
```

**Windows (CMD):**
```cmd
robot --outputdir results\%date:~0,4%%date:~5,2%%date:~8,2% ^
      --variable USERNAME:you@example.com ^
      --variable PASSWORD:yourpassword ^
      tests\
```

### Run a single suite

```bash
robot --outputdir results \
      --variable USERNAME:you@example.com \
      --variable PASSWORD:yourpassword \
      tests/02_NetworkTests.robot
```

### Run by tag

```bash
# Run only connection retrieval tests
robot --include connections \
      --variable USERNAME:you@example.com \
      --variable PASSWORD:yourpassword \
      tests/
```

---

## Reports

After each run, Robot Framework generates three files inside `--outputdir`:

| File | Description |
|---|---|
| `report.html` | High-level pass/fail summary |
| `log.html` | Detailed step-by-step execution log |
| `output.xml` | Machine-readable results (for CI/CD) |

Open `report.html` or `log.html` in any browser to view results.

---

## Configuration

All configurable values live in `resources/variables.robot`:

| Variable | Default | Description |
|---|---|---|
| `${BROWSER}` | `chromium` | Browser engine (`chromium`, `firefox`, `webkit`) |
| `${HEADLESS}` | `false` | Run without UI (`true` for CI) |
| `${TIMEOUT}` | `30s` | Global element wait timeout |
| `${USERNAME}` | _(empty)_ | LinkedIn email — pass via CLI |
| `${PASSWORD}` | _(empty)_ | LinkedIn password — pass via CLI |

Override any variable at runtime: `--variable HEADLESS:true`

---

## Architecture

### Page Objects (`resources/pages/`)
Each file represents one LinkedIn page. It owns that page's selectors and low-level interaction keywords (fill field, click button, wait for element). No test logic lives here.

### Keywords (`resources/keywords/LinkedInKeywords.robot`)
Composite keywords that combine page-object steps into meaningful actions (`Login To LinkedIn`, `Retrieve And Log All Connections`). Test suites import only this file.

### Test Suites (`tests/`)
Each suite has `Test Setup` / `Test Teardown` that open and close a fresh browser, making every test independent and order-agnostic.

---

## Notes

- **Credentials** are never hardcoded. Always pass them via `--variable` flags or a CI secret manager.
- **LinkedIn DOM selectors** (e.g. `.mn-connection-card__name`) may change if LinkedIn updates their UI. All selectors are centralised in the relevant `pages/` file for easy updates.
- **Headless mode**: set `--variable HEADLESS:true` for CI/CD pipelines.
