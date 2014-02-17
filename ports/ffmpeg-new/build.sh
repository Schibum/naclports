#!/bin/bash
# Copyright (c) 2012 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

source pkg_info
source ../../build_tools/common.sh


ConfigureStep() {
  export PKG_CONFIG_PATH=${NACLPORTS_LIBDIR}/pkgconfig
  export PKG_CONFIG_LIBDIR=${NACLPORTS_LIBDIR}
  export PATH=${NACL_BIN_PATH}:${PATH};
  MakeDir ${NACL_PACKAGES_REPOSITORY}/${PACKAGE_NAME}/${NACL_BUILD_SUBDIR}
  ChangeDir ${NACL_PACKAGES_REPOSITORY}/${PACKAGE_NAME}/${NACL_BUILD_SUBDIR}
  local extra_args=""
  if [ "${NACL_ARCH}" = pnacl ]; then
    extra_args="--cc=pnacl-clang --arch=pnacl"
    extra_args+=" --disable-ssse3 \
    --disable-asm \
    --disable-mmx \
    --disable-amd3dnow \
    --disable-amd3dnowext"

  fi

  if [[ "${NACL_GLIBC}" != "1" ]]; then
    # This is needed for sys/ioctl.h.
    # TODO(sbc): Remove once sys/ioctl.h is added to newlib SDK
    CFLAGS+=" -I${NACLPORTS_INCLUDE}/glibc-compat"
    export CFLAGS
    extra_args+=" --extra-libs=-lglibc-compat --extra-libs=-lpthread"
  fi

  ../configure \
    --cross-prefix=${NACL_CROSS_PREFIX}- \
    --arch="${NACL_ARCH}" \
    ${extra_args} \
    --target-os=linux \
    --disable-everything \
    --enable-muxer=webm \
    --enable-encoder=libvpx_vp8,libvorbis \
    --enable-filter=null,scale,resample \
    --disable-yasm \
    --disable-asm \
    --enable-static \
    --enable-cross-compile \
    --enable-protocol=file \
    --enable-libvorbis \
    --enable-libvpx \
    --disable-programs \
    --prefix=${NACLPORTS_PREFIX} \
    --libdir=${NACLPORTS_LIBDIR}
}


PostConfigureStep() {
  touch strings.h
}


BuildAndInstallStep() {
  DefaultBuildStep
  make install
}


PackageInstall() {
  PreInstallStep
  DownloadStep
  ExtractStep
  PatchStep
  ConfigureStep
  PostConfigureStep
  BuildAndInstallStep
}


PackageInstall
exit 0
