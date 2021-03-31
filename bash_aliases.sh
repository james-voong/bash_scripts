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

# Aliases
alias grr='grep -Ri'
alias keyboard='g810-led -fx hwave all 10'
alias {tsgen,gents}=generate_timesheet
alias dockips="docker ps -q | xargs -n 1 docker inspect --format '{{.Name }} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' | sed 's/^\///'"
alias shell='inv db.shell'

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

# aliases for common typos:
alias les='less'

# Purge my cache.
function purgecache() {
    if [ "$#" -ne 1 ]; then
        echo "Master, you must give me exactly 1 parameter."
        return
    fi
    docker exec -it ${1} php /var/www/html/admin/cli/purge_caches.php
}

# Release management related functions.
alias release="cat ~/dev/eumetadata/[0-9]*.json | jq -r '.sites[]|select(.project_team==\"MI6\")|.environments.production.url'"

# Allows you to give multiple WRs as params to deployment_script.py
function deployment() {
    if [ "$#" -lt 1 ]; then
        echo "Need more params. Exited."
        return
    fi
    for deploymentnumber in "$@"
        do
            python3 ~/dev/wrmsapi/deployment_script.py $deploymentnumber
    done

}

# Locate partial filename recursively.
function locate() {
    if [ "$#" -ne 1 ]; then
        echo "Probably not what you want to run."
        return
    fi

    find . -iname "*${1}*"
}

# Install codechecker.
function codechecker_install() {
    git submodule add git@github.com:moodlehq/moodle-local_codechecker.git local/codechecker
    if [ $? -ne 0 ]; then
        return
    fi
    git reset .gitmodules local/codechecker

}

alias pierlogs='ssh piers "cd /var/log/sitelogs; bash"'
alias pierdbs='ssh piers "cd /var/backup/db-backups; bash"'

# To find instances:
# Run aws ec2 describe-instances
# Look through JSON for your instance.
