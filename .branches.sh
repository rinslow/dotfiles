
RESET="\[\033[0m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[01;32m\]"
BLUE="\[\033[01;34m\]"
YELLOW="\[\033[0;33m\]"

 
PS_LINE=`printf -- '- %.0s' {1..200}`
function parse_git_branch {
  PS_BRANCH=''
  PS_FILL=${PS_LINE:0:$COLUMNS}
  if [ -d .svn ]; then
    PS_BRANCH="(svn r$(svn info|awk '/Revision/{print $2}'))"
    return
  elif [ -f _FOSSIL_ -o -f .fslckout ]; then
    PS_BRANCH="(fossil $(fossil status|awk '/tags/{print $2}')) "
    return
  fi
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  PS_BRANCH="(${ref#refs/heads/}) "
}
PROMPT_COMMAND=parse_git_branch

parse_exit_code() {

	if [ "$?" == "0" ]; then
		echo -e "\e[0;32m";
	else
		echo -e "\e[0;31m";
	fi
}

white() {
	echo -e '\e[0;37m';
}

PS_INFO="\u@\h$RESET:$BLUE\w"
PS_GIT="$YELLOW\$PS_BRANCH"
PS_TIME="\[\033[0;95m\]\t"
export PS1="\[\033[0G\]"'`parse_exit_code`'"${PS_INFO} ${PS_GIT}${PS_TIME}\n${RESET}\$ "


