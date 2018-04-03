my=$(cd -P -- "$(dirname -- "${BASH_SOURCE-$0}")" > /dev/null && pwd -P)
mkdir -p $my/{download,opt,home}
export JAVA_HOME=$my/opt/jdk8

export PATH=$my/opt/emacs25/bin:$my/opt/bin:$my/opt:$JAVA_HOME/bin:$PATH

export HOME=$my/home

