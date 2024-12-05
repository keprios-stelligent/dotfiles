# load custom executable functions
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git ssh-agent)

source $ZSH/oh-my-zsh.sh

#for function in ~/.zsh/functions/*; do
#  source $function
#done


# Set default PATH to include ~/.local/ if it exists
if [[ -d ~/.local ]]; then
  export PATH=$PATH:~/.local/bin
fi

# AWS CLI command completion
export PATH=/usr/local/bin:$PATH
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/local/bin/aws_completer' aws


# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/*~*.zwc(N-.); do
        . $config
      done
    fi

    for config in "$_dir"/**/*(N-.); do
      case "$config" in
        "$_dir"/(pre|post)/*|*.zwc)
          :
          ;;
        *)
          . $config
          ;;
      esac
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/*~*.zwc(N-.); do
        . $config
      done
    fi
  fi
}
_load_settings "$HOME/.zsh/configs"

# Testing dynamic variable function
function loadVars() {
  export $(env | xargs) > /dev/null
}

# Google search function
function google() {
  open /Applications/Google\ Chrome.app/ "http://www.google.com/search?q= $1";
}

# Simplified git stage/commit/push
function gsp() {
  git stage . && git commit -m "$1" && git push
}

function gspt() {
  git stage . && git commit -m "$1" && git tag "$2" && git push --tags
}

function sshadd-ecne-identity() {
  ssh-add ~/.ssh/id_rsa-ecnemed
}

# Add EcneMed SSH identity
function sshadd-ecne() {
  eval $(ssh-agent)
  sshadd-ecne-identity
}

# Usage: maketag <compute-instance> <message>
# Example maketag "compute-rocky8-dev" "Message for commit"
function maketag() {
   echo "make TAG_MESSAGE=\"$2 $(stamp)\" COMMIT_MESSAGE=\"$2\" $1"
   make TAG_MESSAGE="$2 $(stamp)" COMMIT_MESSAGE="$2" $1
}

function awe() {
   aws --profile ecnemed $@
}

function awe-sso() {
   aws --profile ecnemed sso login
}

function indexer() {
   ssh kyle.keprios@10.0.1.177
}

function ecne-vpn() {
   ssh -p 3263 kyle.keprios@44.210.203.238
}

function awp() {
  aws --profile personal $@
}

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Set hostname
export HOSTNAME=$(hostname)

# Set aws autocomplete
if [[ -f /usr/local/bin/aws_completer ]]; then
  autoload bashcompinit && bashcompinit
  autoload -Uz compinit && compinit
  complete -C '/usr/local/bin/aws_completer' aws
fi

# SSL cert for work mac
#
case $HOSTNAME in
  (amma) \
    export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt;;
  (veta) \
    export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt;;
  (*) \
    #
    # SSL cert for work mac
    #
    export CERT_PATH=/Users/adj3tzz/onedrive/cert/tls-ca-bundle.pem && \
    export CERT_DIR=/Users/adj3tzz/onedrive/cert && \
    export SSL_CERT_FILE=${CERT_PATH} && \
    export SSL_CERT_DIR=${CERT_DIR} && \
    export REQUESTS_CA_BUNDLE=${CERT_PATH} && \
    export GPG_TTY=$(tty) && \
    export DRONE_SERVER=https://drone.3m-cloud.com && \
    export DRONE_TOKEN=rJcsHKEOZIxT86A1v0IcItxKKdnjWNha;;
esac
