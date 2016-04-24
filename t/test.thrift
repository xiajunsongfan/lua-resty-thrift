namespace java com.test.thrift
namespace cpp lua_test
namespace lua lua_test

service TestService {
  	string say(1:string request)
}
