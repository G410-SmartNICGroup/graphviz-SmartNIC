#!/bin/sh -e

set -x

if test -f /etc/os-release; then
    cat /etc/os-release
    . /etc/os-release
else
    cat /etc/redhat-release
    ID=$( cat /etc/redhat-release | cut -d' ' -f1 | tr 'A-Z' 'a-z' )
    VERSION_ID=$( cat /etc/redhat-release | cut -d' ' -f3  | cut -d'.' -f1 )
fi
printf '%s\n' "${ID}" >OS_ID
GV_VERSION=$( cat VERSION )
COLLECTION=$( cat COLLECTION )
DIR=Packages/${COLLECTION}/${ID}/${VERSION_ID}
ARCH=$( uname -m )
if [ "${ID_LIKE}" = "debian" ]; then
    if [ "${build_system}" = "cmake" ]; then
        apt install ./${DIR}/os/${ARCH}/Graphviz-${GV_VERSION}-Linux.deb
    else
        apt install ./${DIR}/os/${ARCH}/libgraphviz4_${GV_VERSION}-1_amd64.deb
        apt install ./${DIR}/os/${ARCH}/libgraphviz-dev_${GV_VERSION}-1_amd64.deb
        apt install ./${DIR}/os/${ARCH}/graphviz_${GV_VERSION}-1_amd64.deb
    fi
else
    rpm --install --force \
        ${DIR}/os/${ARCH}/graphviz-${GV_VERSION}*.rpm \
        ${DIR}/os/${ARCH}/graphviz-libs-${GV_VERSION}*.rpm \
        ${DIR}/os/${ARCH}/graphviz-devel-${GV_VERSION}*.rpm \
        ${DIR}/os/${ARCH}/graphviz-plugins-core-${GV_VERSION}*.rpm \
        ${DIR}/os/${ARCH}/graphviz-plugins-x-${GV_VERSION}*.rpm \
        ${DIR}/os/${ARCH}/graphviz-x-${GV_VERSION}*.rpm \
        ${DIR}/os/${ARCH}/graphviz-gd-${GV_VERSION}*.rpm \
        ${DIR}/os/${ARCH}/graphviz-qt-${GV_VERSION}*.rpm \
        ${DIR}/os/${ARCH}/graphviz-plugins-gd-${GV_VERSION}*.rpm \
        ${DIR}/os/${ARCH}/graphviz-nox-${GV_VERSION}*.rpm
fi
