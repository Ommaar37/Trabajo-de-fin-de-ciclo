$absolutePath = (Split-Path $MyInvocation.InvocationName)
cd $absolutePath;

$siteUrl = "https://onlinecomasis.sharepoint.com/sites/Omar"

Connect-PnPOnline -Url $siteUrl –UseWebLogin

$context = Get-PnpContext
$web = $context.Web;
$context.Load($web);
$context.ExecuteQuery();

#columnas de sitio
$fields = $web.Fields;
$context.Load($fields);
$context.ExecuteQuery();


invoke-expression -Command "$absolutePath\02.ListaEventos.ps1"
