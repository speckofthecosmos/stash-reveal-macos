on open location this_url
	-- CONFIGURATION
	-- Set your remote path prefix (what Stash sees)
	-- Example: "/data"
	set remote_path_prefix to "/data"
	
	-- Set your local mount prefix (where it is on your Mac)
	-- Example: "/Volumes/Media" or "/Users/username/Mounts/Server"
	set local_mount_prefix to "/Volumes/Media"
	
	-- END CONFIGURATION
	
	try
		-- Strip the protocol (stashreveal://)
		set prefix_length to length of "stashreveal://"
		set raw_path to text (prefix_length + 1) through -1 of this_url
		
		-- URL Decode (handle %20, etc.)
		set decoded_path to do shell script "python3 -c \"import sys, urllib.parse; print(urllib.parse.unquote(sys.argv[1]))\" " & quoted form of raw_path
		
		-- Replace remote prefix with local prefix
		if decoded_path starts with remote_path_prefix then
			set local_path to local_mount_prefix & text (length of remote_path_prefix + 1) through -1 of decoded_path
		else
			-- Fallback if prefix doesn't match exactly
			display dialog "Path does not match remote prefix: " & decoded_path & return & "Expected prefix: " & remote_path_prefix buttons {"OK"} default button "OK"
			return
		end if
		
		-- Reveal in Finder
		-- The -R flag reveals the file without opening it
		do shell script "open -R " & quoted form of local_path
		
	on error errMsg
		display dialog "Error revealing file: " & errMsg buttons {"OK"} default button "OK"
	end try
end open location