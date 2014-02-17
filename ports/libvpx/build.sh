#!/bin/bash
# Copyright (c) 2012 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

source pkg_info
source ../../build_tools/common.sh


ConfigureStep() {
  Banner "Configuring ${PACKAGE_NAME}"
  # export the nacl tools
  export CC=${NACLCC}
  export CXX=${NACLCXX}
  export AR=${NACLAR}
  export RANLIB=${NACLRANLIB}
  export PKG_CONFIG_PATH=${NACLPORTS_LIBDIR}/pkgconfig
  export PKG_CONFIG_LIBDIR=${NACLPORTS_LIBDIR}
  export PATH=${NACL_BIN_PATH}:${PATH};
  ChangeDir ${NACL_PACKAGES_REPOSITORY}/${PACKAGE_NAME}

  local conf_host
  if [ "${NACL_ARCH}" = pnacl ]; then
    conf_host=pnacl
  else
    conf_host=${NACL_CROSS_PREFIX}
  fi
  export CROSS=$NACL_CROSS_PREFIX-

  LogExecute ./configure \
    --enable-vp8 \
    --target=pnacl \
    --prefix=${NACLPORTS_PREFIX} \
    --libdir=${NACLPORTS_LIBDIR} \
    --disable-unit-tests \
    --disable-examples \
    --disable-runtime_cpu_detect 

  make clean
}


PackageInstall
exit 0
