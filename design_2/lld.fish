function lld --wraps='ls -lrt | grep ^d' --description 'alias lld=ls -lrt | grep ^d'
    ls -lrt | grep ^d $argv
end
