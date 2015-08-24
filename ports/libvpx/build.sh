#!/bin/bash
# Copyright (c) 2012 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

if [ "${NACL_SHARED}" = "1" ]; then
  NACLPORTS_CFLAGS+=" -fPIC"
  NACLPORTS_CXXFLAGS+=" -fPIC"
  EXECUTABLES+=
fi

ConfigureStep() {
  SetupCrossEnvironment

  local conf_host
  if [ "${NACL_ARCH}" = pnacl ]; then
    conf_host=pnacl
  else
    conf_host=${NACL_CROSS_PREFIX}
  fi
  enable_small=""
  if [ "${NACL_ARCH}" = "arm" ]; then
    enable_small="--enable-small"
  fi


  LogExecute ${SRC_DIR}/configure \
    --enable-vp8 \
    --target=pnacl \
    --prefix=${PREFIX} \
    --disable-unit-tests \
    --disable-examples \
    --disable-runtime_cpu_detect \
    ${enable_small}

  make clean
}

