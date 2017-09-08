set url=%1
set load=%url:~12%
start http://localhost:8888/auth?authRequest=%load%
