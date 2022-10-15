-- Checks if using LuaJIT, if does it'll uses LuaJIT's FFI library.
-- If not uses CFFI-Lua.
local ffi = require(
	not jit and 'cffi' or 'ffi'
)

ffi.cdef[[
// Define lua.h, lualib.h and lauxlib.h's function and types
typedef struct lua_State lua_State;
typedef long long lua_Integer;
typedef double lua_Number;

typedef void * (*lua_Alloc) (void *ud, void *ptr, size_t osize, size_t nsize);

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
lua_Alloc lua_getallocf (lua_State *L, void **ud);
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
]]

local C = ffi.C

local Lfunc = {}

function Lfunc:gsubL(s,p,r)
	return ffi.string(
		C.luaL_gsub(self._L,s,p,r)
	)
end

function Lfunc:lenL(ind)
	return C.luaL_len(self._L,ind)
end

function Lfunc:close()
	C.lua_close(self._L)
end

function Lfunc:openlibs()
	C.luaL_openlibs(self._L)
end

local llua = {}

function llua.newState()
	local Lapi = {}

	for i,v in pairs(Lfunc) do
		Lapi[i] = v
	end

	Lapi._L = C.luaL_newstate()

	return Lapi
end

local L = llua.newState()

local str = L:gsubL('Hello World!','World','Dunia')

print(str,L:lenL(1))

L:close()
