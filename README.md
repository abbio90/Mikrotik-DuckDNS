# Mikrotik-DuckDNS
DuckDNS script with the possibility of indicating two static public IPs in the event that two ISPs with static IPs are used, and in the logs it will indicate which ISP is being used upon IP change.

1. Import the file into the terminal: "DUCKDNS import to terminal"
2. Go to the system script menu and fill in the fields: ":local duckdnsSubDomain, :local duckdnsToken, :local TwoStaticIP, :local ISP1Name, :local ISP2Name, :local PublicIPISP1, :local PublicIPISP2"

3. If everything is completed correctly, as soon as ISP1 goes down, the logs indicate that we are using ISP 2. In the event that you do not have two static public IPs, set the item: << local TwoStaticIP "no" >>

Make sure the script is run in the /system schedule menu
