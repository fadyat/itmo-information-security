.PHONY: broken_access_control clean

broken_access_control:
	@cd broken_access_control && make install
	@open http://localhost:10005

clean:
	@cd broken_access_control && make compose-down