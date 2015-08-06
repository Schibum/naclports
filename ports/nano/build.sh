# Copyright (c) 2013 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

export EXTRA_LIBS="-lncurses ${NACL_CLI_MAIN_LIB}"

if [ "${NACL_LIBC}" = "newlib" ]; then
  EXTRA_CONFIGURE_ARGS="--enable-tiny"
  NACLPORTS_CPPFLAGS+=" -I${NACLPORTS_INCLUDE}/glibc-compat"
  export EXTRA_LIBS+=" -lglibc-compat"
fi

PatchStep() {
  DefaultPatchStep
  cp ${START_DIR}/nano_pepper.c ${SRC_DIR}/src/
}

PublishStep() {
  MakeDir ${PUBLISH_DIR}

  # TODO(sbc): avoid duplicating the install step here.
  DESTDIR=${PUBLISH_DIR}/nanotar
  MAKEFLAGS="prefix="
  DefaultInstallStep

  ChangeDir ${PUBLISH_DIR}/nanotar
  local exe="../nano_${NACL_ARCH}${NACL_EXEEXT}"
  cp bin/nano${NACL_EXEEXT} ${exe}
  if [ "${NACL_ARCH}" = "pnacl" ]; then
    LogExecute ${PNACLFINALIZE} ${exe}
  fi
  rm -rf bin
  rm -rf share/man
  tar cf ${PUBLISH_DIR}/nano.tar .
  md5sum ${PUBLISH_DIR}/nano.tar > ${PUBLISH_DIR}/nano.tar.hash
  rm -rf ${PUBLISH_DIR}/nanotar
  cd ${PUBLISH_DIR}
  LogExecute python ${NACL_SDK_ROOT}/tools/create_nmf.py \
      nano_*${NACL_EXEEXT} \
      -s . \
      -o nano.nmf
  LogExecute python ${TOOLS_DIR}/create_term.py nano.nmf

  InstallNaClTerm ${PUBLISH_DIR}

  GenerateManifest ${START_DIR}/manifest.json ${PUBLISH_DIR}
  LogExecute cp ${START_DIR}/icon_16.png ${PUBLISH_DIR}
  LogExecute cp ${START_DIR}/icon_48.png ${PUBLISH_DIR}
  LogExecute cp ${START_DIR}/icon_128.png ${PUBLISH_DIR}
  ChangeDir ${PUBLISH_DIR}
  CreateWebStoreZip nano-${VERSION}.zip .
}
