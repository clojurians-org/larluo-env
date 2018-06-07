my=$(cd -P -- "$(dirname -- "${BASH_SOURCE-$0}")" > /dev/null && pwd -P)
mkdir -p $my/{download,opt,home}

source /nix/var/nix/profiles/per-user/larluo/profile/etc/profile.d/nix.sh


export PATH=$my/home/.local/bin:$my/opt/redis/bin:$my/opt/kafka/bin:$my/opt/zookeeper/bin:$my/opt/bin:$my/opt:$PATH
export PATH=$my/../go-ethereum/build/bin:$PATH


export HOME=$my/home
