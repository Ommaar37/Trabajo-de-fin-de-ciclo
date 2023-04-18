$siteUrl = "https://onlinecomasis.sharepoint.com/sites/Omar"

 

Connect-PnPOnline -Url $siteUrl –UseWebLogin

 

Set-PnPClientSidePage -Identity "Juegos.aspx" -LayoutType SingleWebPartAppPage