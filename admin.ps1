# Set strict mode to stop execution on errors
Set-StrictMode -Version Latest

# Script name
$script = $MyInvocation.MyCommand.Name

# Color variables
$GREEN = "`e[0;32m"
$MAGENTA = "`e[0;95m"
$NC = "`e[0m"
$RED = "`e[0;31m"
$YELLOW = "`e[0;33m"

# Determine the SQLite executable name
if ($IsWindows) {
    $sqlite = "sqlite3.exe"
} else {
    $sqlite = "sqlite3"
}

# Function to show help
function Show-Help {
    Write-Host "Usage: ./${script} [options]" -NoNewline
    Write-Host "`n${YELLOW}Options:${NC}" -NoNewline
    Write-Host "`n`t-h  ${GREEN}Show Help ${NC}" -NoNewline
    Write-Host "`n`t-c  ${MAGENTA}Creates a users table ${NC}" -NoNewline
    Write-Host "`n`t-s  ${MAGENTA}Shows all records in the users table ${NC}" -NoNewline
    Write-Host "`n`t-r  ${RED}Removes users table ${NC}"
}

# Function to remove the database
function Remove-DB {
    if (Test-Path "users.sqlite") {
        Remove-Item -Force "users.sqlite"
        Write-Host "${GREEN}Database removed.${NC}"
    } else {
        Write-Host "${YELLOW}Database does not exist.${NC}"
    }
}

# Function to create the database
function Create-DB {
    $createTableSQL = @"
    CREATE TABLE IF NOT EXISTS users (
        user_id INTEGER not null,
        name TEXT NOT NULL
    );
"@
    $createTableSQL | & $sqlite users.sqlite
    Write-Host "${GREEN}Database created.${NC}"
}

# Function to show database records
function Show-DB {
    $querySQL = "SELECT * FROM users;"
    $querySQL | & $sqlite users.sqlite
}

# If no arguments, show help and exit
if ($args.Count -eq 0) {
    Show-Help
    exit
}

# Parse arguments
while ($args.Count -gt 0) {
    switch ($args[0]) {
        '-h' {
            Show-Help
            exit
        }
        '-c' {
            Create-DB
        }
        '-s' {
            Show-DB
        }
        '-r' {
            Remove-DB
        }
        default {
            Write-Host "${RED}Invalid option: $($args[0])${NC}"
            Show-Help
            exit
        }
    }
    if ($args.Count -gt 1) {
        $args = $args[1..($args.Count - 1)]
    } else {
        $args = @()
    }
}
