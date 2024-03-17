.PHONY: broken_access_control \
	cross_site_scripting \
	security_misconfiguration \
	server_side_injection \
	nosql_injection \
	clean

broken_access_control:
	@cd broken_access_control && make install
	@open http://localhost:10005

cross_site_scripting:
	@cd cross_site_scripting && make install
	@open http://localhost:10007

security_misconfiguration:
	@cd security_misconfiguration && make install
	@open http://localhost:10004

server_side_injection:
	@cd server_side_injection && make install
	@open http://localhost:10001

nosql_injection:
	@cd nosql_injection && make install
	@open http://localhost:10001

clean:
	@cd broken_access_control && make compose-down
	@cd cross_site_scripting && make compose-down
	@cd security_misconfiguration && make compose-down
	@cd server_side_injection && make compose-down
	@cd nosql_injection && make compose-down
