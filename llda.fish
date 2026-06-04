function llda --wraps='ls -lrta | grep ^d' --description 'alias llda=ls -lrta | grep ^d'
    ls -lrta | grep ^d $argv
end
