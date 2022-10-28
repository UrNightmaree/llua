-- Checks if using LuaJIT, if does it'll uses LuaJIT's FFI library.
-- If not uses CFFI-Lua.
require 'lcpp'

local ffi = require(
	jit and 'ffi' or 'cffi'
)

ffi.cdef[[
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

// Define lua.h, lualib.h and lauxlib.h's function and types
typedef struct lua_State lua_State;
typedef long long lua_Integer;
typedef unsigned long long lua_Unsigned;
typedef double lua_Number;

// lua.h
int lua_absindex(lua_State *L, int idx);
void lua_arith(lua_State *L, int op);
void lua_call(lua_State *L, int nargs, int nresults);
int lua_checkstack(lua_State *L, int n);
void lua_close(lua_State *L);
void lua_closeslot(lua_State *L, int index);
int lua_compare(lua_State *L, int index1, int index2, int op);
void lua_concat(lua_State *L, int n);
void lua_copy(lua_State *L, int fromidx, int toidx);
void lua_createtable(lua_State *L, int narr, int nrec);
int lua_error(lua_State *L);
int lua_gc(lua_State *L, int what, ...);
int lua_getfield(lua_State *L, int index, const char *k);
void *lua_getextraspace(lua_State *L);
int lua_getglobal(lua_State *L, const char *name);
int lua_geti(lua_State *L, int index, lua_Integer i);
int lua_getmetatable(lua_State *L, int index);
int lua_gettable(lua_State *L, int index);
int lua_gettop(lua_State *L);
int lua_getiuservalue(lua_State *L, int index, int n);
void lua_insert(lua_State *L, int index);
int lua_isboolean(lua_State *L, int index);
int lua_iscfunction(lua_State *L, int index);
int lua_isfunction(lua_State *L, int index);
int lua_isinteger(lua_State *L, int index);
int lua_islightuserdata(lua_State *L, int index);
int lua_isnil(lua_State *L, int index);
int lua_isnone(lua_State *L, int index);
int lua_isnoneornil(lua_State *L, int index);
int lua_isnumber(lua_State *L, int index);
int lua_isstring(lua_State *L, int index);
int lua_istable(lua_State *L, int index);
int lua_isuserdata(lua_State *L, int index);
int lua_isyieldable(lua_State *L, int index);
void lua_len(lua_State *L, int index);
void lua_newtable(lua_State *L);
lua_State *lua_newthread(lua_State *L);
void *lua_newuserdatauv(lua_State *L, size_t size, int nvalue);
int lua_next(lua_State *L, int index);
int lua_pcall(lua_State *L, int nargs, int nresults, int msgh);
void lua_pop(lua_State *L, int b);
void lua_pushboolean(lua_State *L, int b);
const char *lua_pushfstring(lua_State *L, const char *fmt, ...);
int lua_rawequal(lua_State *L, int index1, int index2);
int lua_rawget(lua_State *L, int index);
int lua_rawgeti(lua_State *L, int index, lua_Integer n);
int lua_rawgetp(lua_State *L, int index, const void *p);
lua_Unsigned lua_rawlen(lua_State *L, int index);
void lua_rawset(lua_State *L, int index);
void lua_rawseti(lua_State *L, int index, lua_Integer i);
void lua_rawsetp(lua_State *L, int index, const void *p);
void lua_remove(lua_State *L, int index);
void lua_replace(lua_State *L, int index);
int lua_resetthread(lua_State *L);
int lua_resume(lua_State *L, lua_State *from, int nargs, int *nresults);
void lua_rotate(lua_State *L, int idx, int n);
void lua_setfield(lua_State *L, int index, const char *k);
void lua_setglobal(lua_State *L, const char *name);
const char *lua_setupvalue(lua_State *L, int funcindex, int n);
void *lua_upvalueid(lua_State *L, int funcindex, int n);
void lua_upvaluejoin(lua_State *L, int funcindex1, int n1,
										int funcindex2, int n2);

// lauxlib.h
lua_State *luaL_newstate();
]]

local C = ffi.C

local function toBoolean(n)
	local list = {
		false,true
	}

	return list[n]
end

---@class Lapi
local Lapi = {}

---@param idx integer The stack index
---@return number length The length of "idx" index
--<s>
--Using "#" operator (length) on "idx" index
function Lapi:rawlen(idx)
	return C.lua_rawlen(self._L,idx)
end

function Lapi:len(idx)
	return C.lua_len(self._L,idx)
end

function Lapi:newthread()
	---@type Lapi
	local L = {}

	for i,v in pairs(self) do
		L[i] = v
	end

	L._L = C.lua_newthread(self._L)

	return L
end

--Set L to-be-close variable
function Lapi:close()
	C.lua_close(self._L)
end

local llua = {}

function llua.NewState()
	---@type Lapi
	local L = {}

	for i,v in pairs(Lapi) do
		L[i] = v
	end

	L._L = C.luaL_newstate()

	return L
end

local L = llua.NewState()

print(L:rawlen(1))

local Lthread = L:newthread()

print(Lthread:len(1))

L:close()
