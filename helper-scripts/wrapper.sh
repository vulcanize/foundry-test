#!/bin/bash
# This script will run everthing for you. Sit back and enjoy they show.

set -e
showHelp() {
# `cat << EOF` This means that cat should stop reading when EOF is detected
cat << EOF
Usage: ./wrapper.sh -e <compiler-env> -d <database-image-source> -v <keep-or-remove-volume> -u <remote-username> -n <remote-host> -p <path-to-related-repositories-map>
Spin up Foundry with Geth and a database.

-h,         Display help

-e,         Should we compile geth on your "local" machine or in "docker" or on a "remote" machine or "skip" compiling. Recommended to use "docker" for releases

-d,         Should be the path(s) to the docker compose file you want to use. You can string together multiple docker
            compose files. Just make sure the services do not have conflicts!

-v,         Should we "remove" the volume when bringing the image down or "keep" it?

-u,         What username should we use for the remote build?

-n,         What is the hostname for the remote build?

-p,         Path to config.sh file.

EOF
exit 1
# EOF is found above and hence cat command stops reading. This is equivalent to echo but much neater when printing out.
}

e="local"
v="keep"
u="abdul"
n="alabaster.lan.vdb.to"
p="../config.sh"
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
while getopts ":e:d:v:u:n:p:" o; do
    case "${o}" in
        e)
            e=${OPTARG}
            [ "$e" = "local" -o "$e" = "docker" -o "$e" = "skip" -o "$e" = "remote" ] ||showHelp
            ;;
        d)  composeFiles+=($OPTARG)
            [[ -f "$OPTARG" ]] || showHelp
            ;;
        v)
            v=${OPTARG}
            [ "$v" = "keep" -o "$v" = "remove" ] || showHelp
            ;;
        u)
            u=${OPTARG}
            ;;
        n)
            n=${OPTARG}
            ;;
        p)
            p=${OPTARG}
            [[ -f "$p" ]] || showHelp
            ;;
        *)
            showHelp
            ;;
    esac
done
shift $((OPTIND-1))

# Local Build or Docker Build

echo -e "${GREEN} STARTING PARAMS${NC}"
echo -e "${GREEN} e=${e} ${NC}"
echo -e "${GREEN} composeFiles=${composeFiles[@]} ${NC}"
echo -e "${GREEN} v=${v} ${NC}"
echo -e "${GREEN} u=${u} ${NC}"
echo -e "${GREEN} n=${n} ${NC}"
echo -e "${GREEN} p=${p} ${NC}"

if [ "$e" != "skip" ]; then
    ./compile-geth.sh -e $e -n $n -u $u -p $p
fi

echo -e "${GREEN} Sourcing: $p ${nc}"
source $p

fileArgs=()
for files in "${composeFiles[@]}"; do fileArgs+=(-f "$files"); done

echo -e "${GREEN} fileArgs: ${fileArgs[@]} ${nc}"


if [[ "$v" = "keep" ]] ; then
    trap 'cd ../docker/; docker-compose --env-file $p ${fileArgs[@]} down --remove-orphans; cd ../' SIGINT SIGTERM
fi

if [[ "$v" = "remove" ]] ; then
    trap 'cd ../docker/; docker-compose --env-file $p ${fileArgs[@]} down -v --remove-orphans; cd ../' SIGINT SIGTERM
fi

echo -e "${GREEN}Building DB image using ${d}${NC}"
echo -e "${GREEN}docker-compose --env-file $p ${fileArgs[@]} up --build${NC}"
docker-compose --env-file "$p" ${fileArgs[@]} up --build