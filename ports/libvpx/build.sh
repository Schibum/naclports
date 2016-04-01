# Copyright 2015 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

OS_JOBS=1

if [[ ${NACL_LIBC} == newlib ]]; then
  NACLPORTS_CXXFLAGS+=" -std=gnu++11"
fi

if [[ ${NACL_ARCH} == arm && ${TOOLCHAIN} == glibc ]]; then
  # Force -O2 rather then -O3 to work around arm gcc bug
  EXTRA_CONFIGURE_ARGS="--enable-small"
fi

if [ "${NACL_SHARED}" = "1" ]; then
  NACLPORTS_CFLAGS+=" -fPIC"
  NACLPORTS_CXXFLAGS+=" -fPIC"
fi

SetOptFlags() {
  # libvps sets it own optimisation flags
  return
}

ConfigureStep() {
  SetupCrossEnvironment
  LogExecute ${SRC_DIR}/configure --target=generic-gnu --cpu=le32 \
      --disable-unit-tests --prefix=${PREFIX} \
      --enable-vp8 \
      --disable-examples \
      --extra-cflags="${NACLPORTS_CPPFLAGS}" ${EXTRA_CONFIGURE_ARGS:-}
}
