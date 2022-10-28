local ffi = require 'cffi'
local lcpp = require 'lcpp'

table.insert(lcpp.INCLUDE_PATHS,'/usr/include')
table.insert(lcpp.INCLUDE_PATHS,'/usr/include/arm-linux-gnueabihf')
table.insert(lcpp.INCLUDE_PATHS,'/usr/include/linux')

lcpp.enable()

ffi.cdef[[
#define __ARM_PCS_VFP
#include <stdio.h>

int printf(const char* fmt, ...);
]]

ffi.C.printf'hi\n'
