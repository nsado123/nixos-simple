function ssh-server --wraps='ssh -p 22 nsado@192.168.1.134' --wraps='ssh -p 39901 nsado@192.168.1.134' --description 'alias ssh-server ssh -p 39901 nsado@192.168.1.134'
  ssh -p 39901 nsado@192.168.1.134 $argv
        
end
