# --------------------------------------------------------------
# xml-to-only-nodes.ps1
#   Writes only <Node …> elements (no <mrng:Connections> wrapper)
# --------------------------------------------------------------


$csvPath = "connections.csv"
$xmlOut  = "onlyNodes.xml"

# 1. Import CSV
$records = Import-Csv -Path $csvPath

# 2. Build the hierarchy (T/Type -> State -> Branch)
$hierarchy = @{}
foreach ($rec in $records) {
    # Use 'T' column as the Type (ED or HLT)
    $type = $rec.T
    
    if ($hierarchy[$type] -eq $null)                        { $hierarchy[$type] = @{} }
    if ($hierarchy[$type][$rec.State] -eq $null)            { $hierarchy[$type][$rec.State] = @{} }
    if ($hierarchy[$type][$rec.State][$rec.Branch] -eq $null) { $hierarchy[$type][$rec.State][$rec.Branch] = @() }
    $hierarchy[$type][$rec.State][$rec.Branch] += $rec
}

#ADD CUSTOM NAMES 
$serverTypeMapCountry1 = @{
    20  = "Security"
    15 = "AD-DC"
     7 = "FS"

}

#ADD CUSTOM NAMES 
$serverTypeMapCountry2 = @{
    20  = "Security"
    15 = "AD-DC"

}





# 3. Remove old file if it exists (with retry loop for file locks)
$retries = 5
while ($retries -gt 0) {
    try {
        if (Test-Path $xmlOut) { Remove-Item $xmlOut -Force -ErrorAction Stop }
        break
    } catch {
        Write-Warning "File locked, waiting 2s... ($retries retries left)"
        Start-Sleep -Seconds 2
        $retries--
    }
}

# 4. Create XmlWriter — Fragment mode
$settings = [System.Xml.XmlWriterSettings]@{
    ConformanceLevel    = [System.Xml.ConformanceLevel]::Fragment
    Indent              = $true
    IndentChars         = "`t"
    NewLineOnAttributes = $false
}

$writer = $null
try {
    $writer = [System.Xml.XmlWriter]::Create($xmlOut, $settings)

    # Top level: Type (ED, HLT from T column)
    foreach ($type in ($hierarchy.Keys | Sort-Object)) {
        $writer.WriteStartElement("Node")
        $writer.WriteAttributeString("Name", $type)
        $writer.WriteAttributeString("Type", "Container")
        $writer.WriteAttributeString("Expanded", "false")
        $writer.WriteAttributeString("Descr", "")
        $writer.WriteAttributeString("Icon", "mRemoteNG")
        $writer.WriteAttributeString("Panel", "General")
        $writer.WriteAttributeString("Id", [guid]::NewGuid().ToString())
        $writer.WriteAttributeString("Username", "")
        $writer.WriteAttributeString("Domain", "")
        $writer.WriteAttributeString("Password", "")
        $writer.WriteAttributeString("Hostname", "")
        $writer.WriteAttributeString("Protocol", "RDP")
        $writer.WriteAttributeString("PuttySession", "Default Settings")
        $writer.WriteAttributeString("Port", "3389")
        $writer.WriteAttributeString("ConnectToConsole", "false")
        $writer.WriteAttributeString("UseCredSsp", "true")
        $writer.WriteAttributeString("RenderingEngine", "IE")
        $writer.WriteAttributeString("ICAEncryptionStrength", "EncrBasic")
        $writer.WriteAttributeString("RDPAuthenticationLevel", "NoAuth")
        $writer.WriteAttributeString("RDPMinutesToIdleTimeout", "0")
        $writer.WriteAttributeString("RDPAlertIdleTimeout", "false")
        $writer.WriteAttributeString("LoadBalanceInfo", "")
        $writer.WriteAttributeString("Colors", "Colors16Bit")
        $writer.WriteAttributeString("Resolution", "FitToWindow")
        $writer.WriteAttributeString("AutomaticResize", "true")
        $writer.WriteAttributeString("DisplayWallpaper", "false")
        $writer.WriteAttributeString("DisplayThemes", "false")
        $writer.WriteAttributeString("EnableFontSmoothing", "false")
        $writer.WriteAttributeString("EnableDesktopComposition", "false")
        $writer.WriteAttributeString("CacheBitmaps", "false")
        $writer.WriteAttributeString("RedirectDiskDrives", "false")
        $writer.WriteAttributeString("RedirectPorts", "false")
        $writer.WriteAttributeString("RedirectPrinters", "false")
        $writer.WriteAttributeString("RedirectSmartCards", "false")
        $writer.WriteAttributeString("RedirectSound", "DoNotPlay")
        $writer.WriteAttributeString("SoundQuality", "Dynamic")
        $writer.WriteAttributeString("RedirectKeys", "false")
        $writer.WriteAttributeString("Connected", "false")
        $writer.WriteAttributeString("PreExtApp", "")
        $writer.WriteAttributeString("PostExtApp", "")
        $writer.WriteAttributeString("MacAddress", "")
        $writer.WriteAttributeString("UserField", "")
        $writer.WriteAttributeString("ExtApp", "")
        $writer.WriteAttributeString("VNCCompression", "CompNone")
        $writer.WriteAttributeString("VNCEncoding", "EncHextile")
        $writer.WriteAttributeString("VNCAuthMode", "AuthVNC")
        $writer.WriteAttributeString("VNCProxyType", "ProxyNone")
        $writer.WriteAttributeString("VNCProxyIP", "")
        $writer.WriteAttributeString("VNCProxyPort", "0")
        $writer.WriteAttributeString("VNCProxyUsername", "")
        $writer.WriteAttributeString("VNCProxyPassword", "")
        $writer.WriteAttributeString("VNCColors", "ColNormal")
        $writer.WriteAttributeString("VNCSmartSizeMode", "SmartSAspect")
        $writer.WriteAttributeString("VNCViewOnly", "false")
        $writer.WriteAttributeString("RDGatewayUsageMethod", "Never")
        $writer.WriteAttributeString("RDGatewayHostname", "")
        $writer.WriteAttributeString("RDGatewayUseConnectionCredentials", "Yes")
        $writer.WriteAttributeString("RDGatewayUsername", "")
        $writer.WriteAttributeString("RDGatewayPassword", "")
        $writer.WriteAttributeString("RDGatewayDomain", "")
        $writer.WriteAttributeString("InheritCacheBitmaps", "false")
        $writer.WriteAttributeString("InheritColors", "false")
        $writer.WriteAttributeString("InheritDescription", "false")
        $writer.WriteAttributeString("InheritDisplayThemes", "false")
        $writer.WriteAttributeString("InheritDisplayWallpaper", "false")
        $writer.WriteAttributeString("InheritEnableFontSmoothing", "false")
        $writer.WriteAttributeString("InheritEnableDesktopComposition", "false")
        $writer.WriteAttributeString("InheritDomain", "false")
        $writer.WriteAttributeString("InheritIcon", "false")
        $writer.WriteAttributeString("InheritPanel", "false")
        $writer.WriteAttributeString("InheritPassword", "false")
        $writer.WriteAttributeString("InheritPort", "false")
        $writer.WriteAttributeString("InheritProtocol", "false")
        $writer.WriteAttributeString("InheritPuttySession", "false")
        $writer.WriteAttributeString("InheritRedirectDiskDrives", "false")
        $writer.WriteAttributeString("InheritRedirectKeys", "false")
        $writer.WriteAttributeString("InheritRedirectPorts", "false")
        $writer.WriteAttributeString("InheritRedirectPrinters", "false")
        $writer.WriteAttributeString("InheritRedirectSmartCards", "false")
        $writer.WriteAttributeString("InheritRedirectSound", "false")
        $writer.WriteAttributeString("InheritSoundQuality", "false")
        $writer.WriteAttributeString("InheritResolution", "false")
        $writer.WriteAttributeString("InheritAutomaticResize", "false")
        $writer.WriteAttributeString("InheritUseConsoleSession", "false")
        $writer.WriteAttributeString("InheritUseCredSsp", "false")
        $writer.WriteAttributeString("InheritRenderingEngine", "false")
        $writer.WriteAttributeString("InheritUsername", "false")
        $writer.WriteAttributeString("InheritICAEncryptionStrength", "false")
        $writer.WriteAttributeString("InheritRDPAuthenticationLevel", "false")
        $writer.WriteAttributeString("InheritRDPMinutesToIdleTimeout", "false")
        $writer.WriteAttributeString("InheritRDPAlertIdleTimeout", "false")
        $writer.WriteAttributeString("InheritLoadBalanceInfo", "false")
        $writer.WriteAttributeString("InheritPreExtApp", "false")
        $writer.WriteAttributeString("InheritPostExtApp", "false")
        $writer.WriteAttributeString("InheritMacAddress", "false")
        $writer.WriteAttributeString("InheritUserField", "false")
        $writer.WriteAttributeString("InheritExtApp", "false")
        $writer.WriteAttributeString("InheritVNCCompression", "false")
        $writer.WriteAttributeString("InheritVNCEncoding", "false")
        $writer.WriteAttributeString("InheritVNCAuthMode", "false")
        $writer.WriteAttributeString("InheritVNCProxyType", "false")
        $writer.WriteAttributeString("InheritVNCProxyIP", "false")
        $writer.WriteAttributeString("InheritVNCProxyPort", "false")
        $writer.WriteAttributeString("InheritVNCProxyUsername", "false")
        $writer.WriteAttributeString("InheritVNCProxyPassword", "false")
        $writer.WriteAttributeString("InheritVNCColors", "false")
        $writer.WriteAttributeString("InheritVNCSmartSizeMode", "false")
        $writer.WriteAttributeString("InheritVNCViewOnly", "false")
        $writer.WriteAttributeString("InheritRDGatewayUsageMethod", "false")
        $writer.WriteAttributeString("InheritRDGatewayHostname", "false")
        $writer.WriteAttributeString("InheritRDGatewayUseConnectionCredentials", "false")
        $writer.WriteAttributeString("InheritRDGatewayUsername", "false")
        $writer.WriteAttributeString("InheritRDGatewayPassword", "false")
        $writer.WriteAttributeString("InheritRDGatewayDomain", "false")

        # Second level: State
        foreach ($state in ($hierarchy[$type].Keys | Sort-Object)) {
            $writer.WriteStartElement("Node")
            $writer.WriteAttributeString("Name", $state)
            $writer.WriteAttributeString("Type", "Container")
            $writer.WriteAttributeString("Expanded", "false")
            $writer.WriteAttributeString("Descr", "")
            $writer.WriteAttributeString("Icon", "mRemoteNG")
            $writer.WriteAttributeString("Panel", "General")
            $writer.WriteAttributeString("Id", [guid]::NewGuid().ToString())
            $writer.WriteAttributeString("Username", "")
            $writer.WriteAttributeString("Domain", "")
            $writer.WriteAttributeString("Password", "")
            $writer.WriteAttributeString("Hostname", "")
            $writer.WriteAttributeString("Protocol", "RDP")
            $writer.WriteAttributeString("PuttySession", "Default Settings")
            $writer.WriteAttributeString("Port", "3389")
            $writer.WriteAttributeString("ConnectToConsole", "false")
            $writer.WriteAttributeString("UseCredSsp", "true")
            $writer.WriteAttributeString("RenderingEngine", "IE")
            $writer.WriteAttributeString("ICAEncryptionStrength", "EncrBasic")
            $writer.WriteAttributeString("RDPAuthenticationLevel", "NoAuth")
            $writer.WriteAttributeString("RDPMinutesToIdleTimeout", "0")
            $writer.WriteAttributeString("RDPAlertIdleTimeout", "false")
            $writer.WriteAttributeString("LoadBalanceInfo", "")
            $writer.WriteAttributeString("Colors", "Colors16Bit")
            $writer.WriteAttributeString("Resolution", "FitToWindow")
            $writer.WriteAttributeString("AutomaticResize", "true")
            $writer.WriteAttributeString("DisplayWallpaper", "false")
            $writer.WriteAttributeString("DisplayThemes", "false")
            $writer.WriteAttributeString("EnableFontSmoothing", "false")
            $writer.WriteAttributeString("EnableDesktopComposition", "false")
            $writer.WriteAttributeString("CacheBitmaps", "false")
            $writer.WriteAttributeString("RedirectDiskDrives", "false")
            $writer.WriteAttributeString("RedirectPorts", "false")
            $writer.WriteAttributeString("RedirectPrinters", "false")
            $writer.WriteAttributeString("RedirectSmartCards", "false")
            $writer.WriteAttributeString("RedirectSound", "DoNotPlay")
            $writer.WriteAttributeString("SoundQuality", "Dynamic")
            $writer.WriteAttributeString("RedirectKeys", "false")
            $writer.WriteAttributeString("Connected", "false")
            $writer.WriteAttributeString("PreExtApp", "")
            $writer.WriteAttributeString("PostExtApp", "")
            $writer.WriteAttributeString("MacAddress", "")
            $writer.WriteAttributeString("UserField", "")
            $writer.WriteAttributeString("ExtApp", "")
            $writer.WriteAttributeString("VNCCompression", "CompNone")
            $writer.WriteAttributeString("VNCEncoding", "EncHextile")
            $writer.WriteAttributeString("VNCAuthMode", "AuthVNC")
            $writer.WriteAttributeString("VNCProxyType", "ProxyNone")
            $writer.WriteAttributeString("VNCProxyIP", "")
            $writer.WriteAttributeString("VNCProxyPort", "0")
            $writer.WriteAttributeString("VNCProxyUsername", "")
            $writer.WriteAttributeString("VNCProxyPassword", "")
            $writer.WriteAttributeString("VNCColors", "ColNormal")
            $writer.WriteAttributeString("VNCSmartSizeMode", "SmartSAspect")
            $writer.WriteAttributeString("VNCViewOnly", "false")
            $writer.WriteAttributeString("RDGatewayUsageMethod", "Never")
            $writer.WriteAttributeString("RDGatewayHostname", "")
            $writer.WriteAttributeString("RDGatewayUseConnectionCredentials", "Yes")
            $writer.WriteAttributeString("RDGatewayUsername", "")
            $writer.WriteAttributeString("RDGatewayPassword", "")
            $writer.WriteAttributeString("RDGatewayDomain", "")
            $writer.WriteAttributeString("InheritCacheBitmaps", "false")
            $writer.WriteAttributeString("InheritColors", "false")
            $writer.WriteAttributeString("InheritDescription", "false")
            $writer.WriteAttributeString("InheritDisplayThemes", "false")
            $writer.WriteAttributeString("InheritDisplayWallpaper", "false")
            $writer.WriteAttributeString("InheritEnableFontSmoothing", "false")
            $writer.WriteAttributeString("InheritEnableDesktopComposition", "false")
            $writer.WriteAttributeString("InheritDomain", "false")
            $writer.WriteAttributeString("InheritIcon", "false")
            $writer.WriteAttributeString("InheritPanel", "false")
            $writer.WriteAttributeString("InheritPassword", "false")
            $writer.WriteAttributeString("InheritPort", "false")
            $writer.WriteAttributeString("InheritProtocol", "false")
            $writer.WriteAttributeString("InheritPuttySession", "false")
            $writer.WriteAttributeString("InheritRedirectDiskDrives", "false")
            $writer.WriteAttributeString("InheritRedirectKeys", "false")
            $writer.WriteAttributeString("InheritRedirectPorts", "false")
            $writer.WriteAttributeString("InheritRedirectPrinters", "false")
            $writer.WriteAttributeString("InheritRedirectSmartCards", "false")
            $writer.WriteAttributeString("InheritRedirectSound", "false")
            $writer.WriteAttributeString("InheritSoundQuality", "false")
            $writer.WriteAttributeString("InheritResolution", "false")
            $writer.WriteAttributeString("InheritAutomaticResize", "false")
            $writer.WriteAttributeString("InheritUseConsoleSession", "false")
            $writer.WriteAttributeString("InheritUseCredSsp", "false")
            $writer.WriteAttributeString("InheritRenderingEngine", "false")
            $writer.WriteAttributeString("InheritUsername", "false")
            $writer.WriteAttributeString("InheritICAEncryptionStrength", "false")
            $writer.WriteAttributeString("InheritRDPAuthenticationLevel", "false")
            $writer.WriteAttributeString("InheritRDPMinutesToIdleTimeout", "false")
            $writer.WriteAttributeString("InheritRDPAlertIdleTimeout", "false")
            $writer.WriteAttributeString("InheritLoadBalanceInfo", "false")
            $writer.WriteAttributeString("InheritPreExtApp", "false")
            $writer.WriteAttributeString("InheritPostExtApp", "false")
            $writer.WriteAttributeString("InheritMacAddress", "false")
            $writer.WriteAttributeString("InheritUserField", "false")
            $writer.WriteAttributeString("InheritExtApp", "false")
            $writer.WriteAttributeString("InheritVNCCompression", "false")
            $writer.WriteAttributeString("InheritVNCEncoding", "false")
            $writer.WriteAttributeString("InheritVNCAuthMode", "false")
            $writer.WriteAttributeString("InheritVNCProxyType", "false")
            $writer.WriteAttributeString("InheritVNCProxyIP", "false")
            $writer.WriteAttributeString("InheritVNCProxyPort", "false")
            $writer.WriteAttributeString("InheritVNCProxyUsername", "false")
            $writer.WriteAttributeString("InheritVNCProxyPassword", "false")
            $writer.WriteAttributeString("InheritVNCColors", "false")
            $writer.WriteAttributeString("InheritVNCSmartSizeMode", "false")
            $writer.WriteAttributeString("InheritVNCViewOnly", "false")
            $writer.WriteAttributeString("InheritRDGatewayUsageMethod", "false")
            $writer.WriteAttributeString("InheritRDGatewayHostname", "false")
            $writer.WriteAttributeString("InheritRDGatewayUseConnectionCredentials", "false")
            $writer.WriteAttributeString("InheritRDGatewayUsername", "false")
            $writer.WriteAttributeString("InheritRDGatewayPassword", "false")
            $writer.WriteAttributeString("InheritRDGatewayDomain", "false")


            
            # Third level: Branch
            foreach ($branch in ($hierarchy[$type][$state].Keys | Sort-Object)) {
                $writer.WriteStartElement("Node")
                $writer.WriteAttributeString("Name", $branch)
                $writer.WriteAttributeString("Type", "Container")
                $writer.WriteAttributeString("Expanded", "false")
                $writer.WriteAttributeString("Descr", "")
                $writer.WriteAttributeString("Icon", "mRemoteNG")
                $writer.WriteAttributeString("Panel", "General")
                $writer.WriteAttributeString("Id", [guid]::NewGuid().ToString())
                $writer.WriteAttributeString("Username", "")
                $writer.WriteAttributeString("Domain", "")
                $writer.WriteAttributeString("Password", "")
                $writer.WriteAttributeString("Hostname", "")
                $writer.WriteAttributeString("Protocol", "RDP")
                $writer.WriteAttributeString("PuttySession", "Default Settings")
                $writer.WriteAttributeString("Port", "3389")
                $writer.WriteAttributeString("ConnectToConsole", "false")
                $writer.WriteAttributeString("UseCredSsp", "true")
                $writer.WriteAttributeString("RenderingEngine", "IE")
                $writer.WriteAttributeString("ICAEncryptionStrength", "EncrBasic")
                $writer.WriteAttributeString("RDPAuthenticationLevel", "NoAuth")
                $writer.WriteAttributeString("RDPMinutesToIdleTimeout", "0")
                $writer.WriteAttributeString("RDPAlertIdleTimeout", "false")
                $writer.WriteAttributeString("LoadBalanceInfo", "")
                $writer.WriteAttributeString("Colors", "Colors16Bit")
                $writer.WriteAttributeString("Resolution", "FitToWindow")
                $writer.WriteAttributeString("AutomaticResize", "true")
                $writer.WriteAttributeString("DisplayWallpaper", "false")
                $writer.WriteAttributeString("DisplayThemes", "false")
                $writer.WriteAttributeString("EnableFontSmoothing", "false")
                $writer.WriteAttributeString("EnableDesktopComposition", "false")
                $writer.WriteAttributeString("CacheBitmaps", "false")
                $writer.WriteAttributeString("RedirectDiskDrives", "false")
                $writer.WriteAttributeString("RedirectPorts", "false")
                $writer.WriteAttributeString("RedirectPrinters", "false")
                $writer.WriteAttributeString("RedirectSmartCards", "false")
                $writer.WriteAttributeString("RedirectSound", "DoNotPlay")
                $writer.WriteAttributeString("SoundQuality", "Dynamic")
                $writer.WriteAttributeString("RedirectKeys", "false")
                $writer.WriteAttributeString("Connected", "false")
                $writer.WriteAttributeString("PreExtApp", "")
                $writer.WriteAttributeString("PostExtApp", "")
                $writer.WriteAttributeString("MacAddress", "")
                $writer.WriteAttributeString("UserField", "")
                $writer.WriteAttributeString("ExtApp", "")
                $writer.WriteAttributeString("VNCCompression", "CompNone")
                $writer.WriteAttributeString("VNCEncoding", "EncHextile")
                $writer.WriteAttributeString("VNCAuthMode", "AuthVNC")
                $writer.WriteAttributeString("VNCProxyType", "ProxyNone")
                $writer.WriteAttributeString("VNCProxyIP", "")
                $writer.WriteAttributeString("VNCProxyPort", "0")
                $writer.WriteAttributeString("VNCProxyUsername", "")
                $writer.WriteAttributeString("VNCProxyPassword", "")
                $writer.WriteAttributeString("VNCColors", "ColNormal")
                $writer.WriteAttributeString("VNCSmartSizeMode", "SmartSAspect")
                $writer.WriteAttributeString("VNCViewOnly", "false")
                $writer.WriteAttributeString("RDGatewayUsageMethod", "Never")
                $writer.WriteAttributeString("RDGatewayHostname", "")
                $writer.WriteAttributeString("RDGatewayUseConnectionCredentials", "Yes")
                $writer.WriteAttributeString("RDGatewayUsername", "")
                $writer.WriteAttributeString("RDGatewayPassword", "")
                $writer.WriteAttributeString("RDGatewayDomain", "")
                $writer.WriteAttributeString("InheritCacheBitmaps", "false")
                $writer.WriteAttributeString("InheritColors", "false")
                $writer.WriteAttributeString("InheritDescription", "false")
                $writer.WriteAttributeString("InheritDisplayThemes", "false")
                $writer.WriteAttributeString("InheritDisplayWallpaper", "false")
                $writer.WriteAttributeString("InheritEnableFontSmoothing", "false")
                $writer.WriteAttributeString("InheritEnableDesktopComposition", "false")
                $writer.WriteAttributeString("InheritDomain", "false")
                $writer.WriteAttributeString("InheritIcon", "false")
                $writer.WriteAttributeString("InheritPanel", "false")
                $writer.WriteAttributeString("InheritPassword", "true")
                $writer.WriteAttributeString("InheritPort", "false")
                $writer.WriteAttributeString("InheritProtocol", "false")
                $writer.WriteAttributeString("InheritPuttySession", "false")
                $writer.WriteAttributeString("InheritRedirectDiskDrives", "false")
                $writer.WriteAttributeString("InheritRedirectKeys", "false")
                $writer.WriteAttributeString("InheritRedirectPorts", "false")
                $writer.WriteAttributeString("InheritRedirectPrinters", "false")
                $writer.WriteAttributeString("InheritRedirectSmartCards", "false")
                $writer.WriteAttributeString("InheritRedirectSound", "false")
                $writer.WriteAttributeString("InheritSoundQuality", "false")
                $writer.WriteAttributeString("InheritResolution", "false")
                $writer.WriteAttributeString("InheritAutomaticResize", "false")
                $writer.WriteAttributeString("InheritUseConsoleSession", "false")
                $writer.WriteAttributeString("InheritUseCredSsp", "false")
                $writer.WriteAttributeString("InheritRenderingEngine", "false")
                $writer.WriteAttributeString("InheritUsername", "true")
                $writer.WriteAttributeString("InheritICAEncryptionStrength", "false")
                $writer.WriteAttributeString("InheritRDPAuthenticationLevel", "false")
                $writer.WriteAttributeString("InheritRDPMinutesToIdleTimeout", "false")
                $writer.WriteAttributeString("InheritRDPAlertIdleTimeout", "false")
                $writer.WriteAttributeString("InheritLoadBalanceInfo", "false")
                $writer.WriteAttributeString("InheritPreExtApp", "false")
                $writer.WriteAttributeString("InheritPostExtApp", "false")
                $writer.WriteAttributeString("InheritMacAddress", "false")
                $writer.WriteAttributeString("InheritUserField", "false")
                $writer.WriteAttributeString("InheritExtApp", "false")
                $writer.WriteAttributeString("InheritVNCCompression", "false")
                $writer.WriteAttributeString("InheritVNCEncoding", "false")
                $writer.WriteAttributeString("InheritVNCAuthMode", "false")
                $writer.WriteAttributeString("InheritVNCProxyType", "false")
                $writer.WriteAttributeString("InheritVNCProxyIP", "false")
                $writer.WriteAttributeString("InheritVNCProxyPort", "false")
                $writer.WriteAttributeString("InheritVNCProxyUsername", "false")
                $writer.WriteAttributeString("InheritVNCProxyPassword", "false")
                $writer.WriteAttributeString("InheritVNCColors", "false")
                $writer.WriteAttributeString("InheritVNCSmartSizeMode", "false")
                $writer.WriteAttributeString("InheritVNCViewOnly", "false")
                $writer.WriteAttributeString("InheritRDGatewayUsageMethod", "false")
                $writer.WriteAttributeString("InheritRDGatewayHostname", "false")
                $writer.WriteAttributeString("InheritRDGatewayUseConnectionCredentials", "false")
                $writer.WriteAttributeString("InheritRDGatewayUsername", "false")
                $writer.WriteAttributeString("InheritRDGatewayPassword", "false")
                $writer.WriteAttributeString("InheritRDGatewayDomain", "false")


                
                # Fourth level: Individual connections
                foreach ($conn in $hierarchy[$type][$state][$branch]) {
                    
                    # Extract last octet from hostname
                    $lastOctet = [int]($conn.Hostname -split '\.')[-1]
                    $map = if ($type -eq "Country1") { $serverTypeMapCountry1 } else { $serverTypeMapCountry2 }
                    $serverType = if ($map.ContainsKey($lastOctet)) { $map[$lastOctet] } else { "SRV" }

                    
                    # Determine inherit values based on last octet
                    $teamA = @(9, 16, 18, 21, 22)
                    $teamB = @(11, 12)
                    $teamC = @(4, 7, 5)
                    
                    if ($lastOctet -in $teamA) {
                        $inheritPassword = "true"
                        $inheritUsername = "true"
                        $inheritDomain   = "true"
                    } elseif ($lastOctet -in $teamB) {
                        $inheritPassword = "true"
                        $inheritUsername = "true"
                        $inheritDomain   = "false"
                    } elseif ($lastOctet -in $teamC) {
                        $inheritPassword = "false"
                        $inheritUsername = "false"
                        $inheritDomain   = "false"
                    } else {
                        $inheritPassword = "false"
                        $inheritUsername = "false"
                        $inheritDomain   = "false"
                    }
                    
                    # Set Icon based on last octet
                    $icon = switch ($lastOctet) {
                        9                             { "Anti Virus" }
                        3                             { "Domain Controller" }
                        12                            { "File Server" }
                        { $_ -in @(24, 23, 25, 29) } { "Backup" }
                        default                       { "mRemoteNG" }
                    }
                    
                    $writer.WriteStartElement("Node")
                    $writer.WriteAttributeString("Name",                              "$branch-$serverType-$lastOctet")
                    $writer.WriteAttributeString("Type",                              "Connection")
                    $writer.WriteAttributeString("Descr",                             "")
                    $writer.WriteAttributeString("Icon",                              $icon)
                    $writer.WriteAttributeString("Panel",                             "General")
                    $writer.WriteAttributeString("Id",                                [guid]::NewGuid().ToString())
                    $writer.WriteAttributeString("Username",                          $conn.Username)
                    $writer.WriteAttributeString("Domain",                            $conn.Domain)
                    $writer.WriteAttributeString("Password",                          $conn.Password)
                    $writer.WriteAttributeString("Hostname",                          $conn.Hostname)
                    $writer.WriteAttributeString("Protocol",                          "RDP")
                    $writer.WriteAttributeString("PuttySession",                      "Default Settings")
                    $writer.WriteAttributeString("Port",                              "3389")
                    $writer.WriteAttributeString("ConnectToConsole",                  "false")
                    $writer.WriteAttributeString("UseCredSsp",                        "true")
                    $writer.WriteAttributeString("RenderingEngine",                   "IE")
                    $writer.WriteAttributeString("ICAEncryptionStrength",             "EncrBasic")
                    $writer.WriteAttributeString("RDPAuthenticationLevel",            "NoAuth")
                    $writer.WriteAttributeString("RDPMinutesToIdleTimeout",           "0")
                    $writer.WriteAttributeString("RDPAlertIdleTimeout",               "false")
                    $writer.WriteAttributeString("LoadBalanceInfo",                   "")
                    $writer.WriteAttributeString("Colors",                            "Colors16Bit")
                    $writer.WriteAttributeString("Resolution",                        "FitToWindow")
                    $writer.WriteAttributeString("AutomaticResize",                   "true")
                    $writer.WriteAttributeString("DisplayWallpaper",                  "false")
                    $writer.WriteAttributeString("DisplayThemes",                     "false")
                    $writer.WriteAttributeString("EnableFontSmoothing",               "false")
                    $writer.WriteAttributeString("EnableDesktopComposition",          "false")
                    $writer.WriteAttributeString("CacheBitmaps",                      "false")
                    $writer.WriteAttributeString("RedirectDiskDrives",                "false")
                    $writer.WriteAttributeString("RedirectPorts",                     "false")
                    $writer.WriteAttributeString("RedirectPrinters",                  "false")
                    $writer.WriteAttributeString("RedirectSmartCards",                "false")
                    $writer.WriteAttributeString("RedirectSound",                     "DoNotPlay")
                    $writer.WriteAttributeString("SoundQuality",                      "Dynamic")
                    $writer.WriteAttributeString("RedirectKeys",                      "false")
                    $writer.WriteAttributeString("Connected",                         "false")
                    $writer.WriteAttributeString("PreExtApp",                         "")
                    $writer.WriteAttributeString("PostExtApp",                        "")
                    $writer.WriteAttributeString("MacAddress",                        "")
                    $writer.WriteAttributeString("UserField",                         "")
                    $writer.WriteAttributeString("ExtApp",                            "")
                    $writer.WriteAttributeString("VNCCompression",                    "CompNone")
                    $writer.WriteAttributeString("VNCEncoding",                       "EncHextile")
                    $writer.WriteAttributeString("VNCAuthMode",                       "AuthVNC")
                    $writer.WriteAttributeString("VNCProxyType",                      "ProxyNone")
                    $writer.WriteAttributeString("VNCProxyIP",                        "")
                    $writer.WriteAttributeString("VNCProxyPort",                      "0")
                    $writer.WriteAttributeString("VNCProxyUsername",                  "")
                    $writer.WriteAttributeString("VNCProxyPassword",                  "")
                    $writer.WriteAttributeString("VNCColors",                         "ColNormal")
                    $writer.WriteAttributeString("VNCSmartSizeMode",                  "SmartSAspect")
                    $writer.WriteAttributeString("VNCViewOnly",                       "false")
                    $writer.WriteAttributeString("RDGatewayUsageMethod",              "Never")
                    $writer.WriteAttributeString("RDGatewayHostname",                 "")
                    $writer.WriteAttributeString("RDGatewayUseConnectionCredentials", "Yes")
                    $writer.WriteAttributeString("RDGatewayUsername",                 "")
                    $writer.WriteAttributeString("RDGatewayPassword",                 "")
                    $writer.WriteAttributeString("RDGatewayDomain",                   "")
                    $writer.WriteAttributeString("InheritCacheBitmaps",               "false")
                    $writer.WriteAttributeString("InheritColors",                     "false")
                    $writer.WriteAttributeString("InheritDescription",                "false")
                    $writer.WriteAttributeString("InheritDisplayThemes",              "false")
                    $writer.WriteAttributeString("InheritDisplayWallpaper",           "false")
                    $writer.WriteAttributeString("InheritEnableFontSmoothing",        "false")
                    $writer.WriteAttributeString("InheritEnableDesktopComposition",   "false")
                    $writer.WriteAttributeString("InheritDomain",                     $inheritDomain)
                    $writer.WriteAttributeString("InheritIcon",                       "false")
                    $writer.WriteAttributeString("InheritPanel",                      "false")
                    $writer.WriteAttributeString("InheritPassword",                   $inheritPassword)
                    $writer.WriteAttributeString("InheritPort",                       "false")
                    $writer.WriteAttributeString("InheritProtocol",                   "false")
                    $writer.WriteAttributeString("InheritPuttySession",               "false")
                    $writer.WriteAttributeString("InheritRedirectDiskDrives",         "false")
                    $writer.WriteAttributeString("InheritRedirectKeys",               "false")
                    $writer.WriteAttributeString("InheritRedirectPorts",              "false")
                    $writer.WriteAttributeString("InheritRedirectPrinters",           "false")
                    $writer.WriteAttributeString("InheritRedirectSmartCards",         "false")
                    $writer.WriteAttributeString("InheritRedirectSound",              "false")
                    $writer.WriteAttributeString("InheritSoundQuality",               "false")
                    $writer.WriteAttributeString("InheritResolution",                 "false")
                    $writer.WriteAttributeString("InheritAutomaticResize",            "false")
                    $writer.WriteAttributeString("InheritUseConsoleSession",          "false")
                    $writer.WriteAttributeString("InheritUseCredSsp",                 "false")
                    $writer.WriteAttributeString("InheritRenderingEngine",            "false")
                    $writer.WriteAttributeString("InheritUsername",                   $inheritUsername)
                    $writer.WriteAttributeString("InheritICAEncryptionStrength",      "false")
                    $writer.WriteAttributeString("InheritRDPAuthenticationLevel",     "false")
                    $writer.WriteAttributeString("InheritRDPMinutesToIdleTimeout",    "false")
                    $writer.WriteAttributeString("InheritRDPAlertIdleTimeout",        "false")
                    $writer.WriteAttributeString("InheritLoadBalanceInfo",            "false")
                    $writer.WriteAttributeString("InheritPreExtApp",                  "false")
                    $writer.WriteAttributeString("InheritPostExtApp",                 "false")
                    $writer.WriteAttributeString("InheritMacAddress",                 "false")
                    $writer.WriteAttributeString("InheritUserField",                  "false")
                    $writer.WriteAttributeString("InheritExtApp",                     "false")
                    $writer.WriteAttributeString("InheritVNCCompression",             "false")
                    $writer.WriteAttributeString("InheritVNCEncoding",                "false")
                    $writer.WriteAttributeString("InheritVNCAuthMode",                "false")
                    $writer.WriteAttributeString("InheritVNCProxyType",               "false")
                    $writer.WriteAttributeString("InheritVNCProxyIP",                 "false")
                    $writer.WriteAttributeString("InheritVNCProxyPort",               "false")
                    $writer.WriteAttributeString("InheritVNCProxyUsername",           "false")
                    $writer.WriteAttributeString("InheritVNCProxyPassword",           "false")
                    $writer.WriteAttributeString("InheritVNCColors",                  "false")
                    $writer.WriteAttributeString("InheritVNCSmartSizeMode",           "false")
                    $writer.WriteAttributeString("InheritVNCViewOnly",                "false")
                    $writer.WriteAttributeString("InheritRDGatewayUsageMethod",       "false")
                    $writer.WriteAttributeString("InheritRDGatewayHostname",          "false")
                    $writer.WriteAttributeString("InheritRDGatewayUseConnectionCredentials", "false")
                    $writer.WriteAttributeString("InheritRDGatewayUsername",          "false")
                    $writer.WriteAttributeString("InheritRDGatewayPassword",          "false")
                    $writer.WriteAttributeString("InheritRDGatewayDomain",            "false")
                    $writer.WriteEndElement()  # </Node> connection
                }
                
                $writer.WriteEndElement()  # </Node> branch container
            }
            
            $writer.WriteEndElement()  # </Node> state container
        }
        
        $writer.WriteEndElement()  # </Node> type container
    }
    
    Write-Host "✅  <Node> hierarchy written to $xmlOut" -ForegroundColor Green
}
finally {
    if ($writer) {
        $writer.Flush()
        $writer.Close()
        $writer.Dispose()
    }
}