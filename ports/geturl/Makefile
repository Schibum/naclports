# Copyright (c) 2014 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

GETURL = geturl_$(NACL_ARCH)$(NACL_EXEEXT)

CPPFLAGS += -Wall -Werror

all: $(GETURL)

EXTRA_LIBS = ${NACL_CLI_MAIN_LIB} -lppapi_simple_cpp -lnacl_io \
	   -lppapi -lppapi_cpp

$(GETURL): geturl.cc
	$(NACLCXX) $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) -o $@ $^ $(EXTRA_LIBS)

clean:
	rm -f $(GETURL)

.PHONY: clean all
