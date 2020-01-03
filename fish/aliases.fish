# Git
abbr --add -U -- gb 'git branch'
abbr --add -U -- gst 'git status'
abbr --add -U -- gf 'git fetch'
abbr --add -U -- ga 'git add'
abbr --add -U -- gc 'git commit'
abbr --add -U -- glg 'git log'
abbr --add -U -- grb 'git rebase'
abbr --add -U -- gl 'git pull'
abbr --add -U -- gp 'git push'
abbr --add -U -- gd 'git diff'
abbr --add -U -- gm 'git merge'
abbr --add -U -- gco 'git checkout'
function gitpurge
    git branch --merged | rg -v "\*" | rg -v "master" | xargs -n 1 git branch -d
end

# System Utils
abbr --add -U -- ls "exa"
abbr --add -U -- lsa "exa -l"
abbr --add -U -- lsah "exa -l"
abbr --add -U -- tree "exa -T"
abbr --add -U -- psg 'ps -eF | rg -i'
abbr --add -U -- rest "loginctl suspend"
abbr --add -U -- bat "upower -I (upower -e | rg BAT)"

# Emacs
abbr --add -U -- ed "emacs --bg-daemon=term"
function em
    env TERM=xterm-24bits emacsclient -nw --socket-name term $argv
end
abbr --add -U -- e env TERM=xterm-24bits emacsclient -nw --socket-name term $argv

# Tmux
abbr --add -U -- tmux "env TERM=xterm-24bits tmux new-session -A -s (basename (pwd)) -n emacs"
function tm
    env TERM=xterm-24bits tmux new-session -A -s (basename (pwd)) -n emacs
end
abbr --add -U -- tma "env TERM=xterm-24bits tmux attach -t"
abbr --add -U -- tml "tmux list-sessions"
abbr --add -U -- tm "env TERM=xterm-24bits tmux new-session -A -s (basename (pwd)) -n emacs"

# Lynx
abbr --add -U -- lynx lynx -cfg=~/.config/lynx/lynx.cfg
function google -a query
    lynx -cfg=~/.config/lynx/lynx.cfg "www.google.com/search?q='"$query"'"
end

function pursuit -a query
    lynx -cfg=~/.config/lynx/lynx.cfg "pursuit.purescript.org/search?q="$query
end
