## laplace ~/.bash_aliases file for user

# Keyboard colour
g810-led -fx hwave all 10

# git aliases
alias gs='git status'
alias gb='git branch'
alias gc='git checkout'
alias gd='git diff'
alias gdno='git diff --name-only'
alias gf='git fetch origin'

# setup autocompletion
if [ -f "/usr/share/bash-completion/completions/git" ]; then
  source /usr/share/bash-completion/completions/git
  __git_complete gb _git_branch
  __git_complete gc _git_checkout
  __git_complete gd _git_diff
  __git_complete gdno _git_diff
else
  echo "Error loading git completions"
fi

# Locate partial filename recursively.
function locate() {
    if [ "$#" -ne 1 ]; then
        echo "Probably not what you want to run."
        return
    fi

    find . -iname "*${1}*"
}

# Other aliases
alias grr='grep -Ri'
alias less='/usr/share/vim/vim81/macros/less.sh'

# vagrant aliases
alias vagrantup='cd ~/dev/vagrant/builds/local && vagrant up && cd -'
alias vagrantconnect='cd ~/dev/vagrant/builds/local && vagrant ssh'

alias config='vim ~/dev/dockerised/config_files/app/config.php'

# Set up my cd path
export CDPATH=".:$HOME:$HOME/dev"

# Show custom path colours in terminal
export PS1='\[\033[01;36m\]\u\[\033[m\]@\[\033[01;32m\]\H:\w$ \[\033[m\]'

# Docker aliases
alias webip="docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' web_container"
alias dbip="docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' db_container"
alias web='docker exec -it web_container bash'
alias db='docker exec -it db_container mysql -pPasswordGoesHere -D local'
alias up='cd ~/dev/dockerised && docker-compose stop && docker-compose up -d && cd -'
alias go='cd ~/dev/dockerised && docker-compose up -d'

# Vue aliases
alias vuedev="cd ~/dev/citizenticket/vue/ && npm run dev"
alias vuebuild="cd ~/dev/citizenticket/vue/ && npm run build"

export LOCAL_IP=$(hostname -I | cut -d ' ' -f1)
