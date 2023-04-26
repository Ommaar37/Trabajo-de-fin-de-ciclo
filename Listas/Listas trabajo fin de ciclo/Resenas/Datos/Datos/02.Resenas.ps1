$csvPath = (Split-Path $MyInvocation.InvocationName)

$listaResenas = $context.web.Lists.GetByTitle("Resenas");
$itemsResenas = $listaResenas.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery());
$listaJuegos = $context.web.Lists.GetByTitle("Juegos");
$itemsJuegos = $listaJuegos.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery());
$context.Load($listaJuegos);
$context.Load($itemsJuegos);
$context.Load($listaResenas);
$context.Load($itemsResenas);
$context.ExecuteQuery();

$ResenasSP = @{};

foreach ($itemResena in $itemsResenas) {
    $ResenasSP[$itemResena["Title"]] = $itemResena;
}


$juegosSP = $itemsJuegos | Group-Object {$_.FieldValues.Title} -AsHashTable -AsString;

$csvResenas = Import-Csv $csvPath"\02.Resenas.csv" ";" -Encoding UTF8;
$i = 0;
$needExecute = $false;
$csvResenas  | ForEach-Object { 

    $i++;

    #comprobamos si el juego existe en SP
    if ($null -ne $juegosSP[$_.JuegoResena]) {

        $juegoCSV = $juegosSP[$_.JuegoResena][0].Id;

        #comprobamos si el Resena ya existe en SP;
        if ($null -eq $ResenasSP[$_.TituloResena]) {
                $itemInfo  = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
                $item = $listaResenas.AddItem($itemInfo)
                $item["Title"] = $_.TituloResena;
                $item["R_Juego"] = $juegoCSV;
                $item.Update();
                $needExecute = $true;
                Write-Host "|--- $($_.TituloResena) preparado para crear" -foregroundcolor Green        
                if ($item["R_Res"] -ne $_.Resena) {
                    $item["R_Res"] = $_.Resena;
                    $needExecute = $true;
                    $needUpdate=$true;
                    $usuario = $web.SiteUsers | Where {$_.LoginName -like "*$($resena.UsuarioResena)*"}
                    if ($null -ne $usuario) {
                        $item["R_User"] = $usuario.Id;
                        $needExecute = $true;
                        $needUpdate=$true;
                    }
                }
                if ($needUpdate) {
                    $item.Update();
                    Write-Host "|---Preparado para actualizar" -foregroundcolor Green
                }
        }          
        else {
                Write-Host "|--- $($_.TituloResena) ya existe" -foregroundcolor Green
                $item = $ResenasSP[$_.TituloResena];
                $needUpdate = $false;



        }
     }
     else {
        write-host "El juego $($_.JuegoResena) no existe" -ForegroundColor Red
     }
    if (($i % 100 -eq 0 -or $i -eq $csvResenas.Count) -and $needExecute) {
            
        $context.ExecuteQuery();
        write-host "|--- Execute OK" -ForegroundColor Green

    }

}