# Collect_Gateway_Interfaces

Simple scripts to collect the interface details from [simple-]gateways and [simple-]clusters via the R8X Management CLI version 2.0 and later from the management host.

Currently limited to 
- default limit and office (so 50 of each objects with offset zero [0])
- Security Management Server (SMS) hosts, no MDSM login specifics for domains yet
- limited subset of the currently available key values for "show interface" command as well as "show interfaces" command
