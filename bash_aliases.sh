## penguin ~/.bash_aliases file for user
# User specific alises and functions

# Function definitions.
# Custom functions are in this file.
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

function generate_timesheet() (
    monday=$(date -dmonday +%Y%m%d)
    friday=$(date -dfriday +%Y%m%d)
    if [ ${monday} -gt ${friday} ]; then
        monday=$(date -dmonday-1week +%Y%m%d)
        previoustimesheet=$(date -dmonday-2week +%Y%m%d)-$(date -dfriday-1week +%Y%m%d)
    else
        previoustimesheet=$(date -dmonday-1week +%Y%m%d)-$(date -dfriday-1week +%Y%m%d)
    fi

    if [ -f ~/timesheets/${monday}-${friday} ]; then
        echo "Timesheet already generated."
        exit 0;
    fi

    if [ -f ~/timesheets/${previoustimesheet} ]; then
        mv ~/timesheets/${previoustimesheet} ~/timesheets/archive
        echo "${previoustimesheet} moved to archive."
    fi

    tks -t week > ~/timesheets/${monday}-${friday}
    echo "Timesheet ${monday}-${friday} generated."
)

alias grr='grep -Ri'
alias {tsgen,gents}=generate_timesheet

# git aliases
alias gs='git status'
alias gb='git branch'
alias gc='git checkout'
alias gd='git diff'
alias gdno='git diff --name-only'
alias gp='git pull'

# setup autocompletion
if [ -f "/usr/share/bash-completion/completions/git" ]; then
  source /usr/share/bash-completion/completions/git
  __git_complete gb _git_branch
  __git_complete gc _git_checkout
  __git_complete gd _git_diff
  __git_complete gdno _git_diff
  __git_complete gp _git_pull
else
  echo "Error loading git completions"
fi
