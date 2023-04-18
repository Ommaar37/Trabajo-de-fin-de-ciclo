$csvPath = (Split-Path $MyInvocation.InvocationName)

$listaJuegos = $context.web.Lists.GetByTitle("Juegos");
$itemsJuegos = $listaJuegos.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery());
$context.Load($listaJuegos);
$context.Load($itemsJuegos);
$context.ExecuteQuery();

$JuegosSP = @{};

foreach ($itemJuego in $itemsJuegos) {
    
    $JuegosSP[$itemJuego["Title"]] = $itemJuego;

}


$csvJuegos = Import-Csv $csvPath"\02.Juegos.csv" ";" -Encoding UTF8;
$i = 0;
$needExecute = $false;
$csvJuegos  | ForEach-Object { 


    if ($null -eq $JuegosSP[$_.Nombre]) {
        
            $itemInfo  = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
            $item = $listaJuegos.AddItem($itemInfo)
            $item["Title"] = $_.Nombre;
            $item.Update();
            $needExecute = $true;
            Write-Host "|--- $($_.Nombre) preparado para crear" -foregroundcolor Green  
    }
    else {
            Write-Host "|--- $($_.Nombre) ya existe" -foregroundcolor Green
            $item = $JuegosSP[$_.Nombre];
            $needUpdate = $false;
            if ($item["J_Desc"] -ne $_.Descripcion) {
                $item["J_Desc"] = $_.Descripcion;
                $needExecute = $true;
                $needUpdate=$true;
            }
            $fechaCSV = Get-Date $_.FechaLanz;
            $fechaSP = $item.FieldValues.J_Lanz;

            if ($fechaCSV.Ticks -ne $fechaSP.Ticks) {
                $item["J_Lanz"] = $fechaCSV.ToUniversalTime();
                $needUpdate = $true;
                $needExecute = $true;
                
            }
            if ($item["J_Gen"] -ne $_.Genero) {
                $item["J_Gen"] = $_.Genero;
                $needExecute = $true;
                $needUpdate=$true;
            }

            if ($item["J_Dur"] -ne $_.Duracion) {
                $item["J_Dur"] = $_.Duracion;
                $needExecute = $true;
                $needUpdate=$true;
            }
         
            if ($needUpdate) {
                $item.Update();
                Write-Host "|--- $($_.Nombre) preparado para actualizar" -foregroundcolor Green
            
            }
    }

    if (($i % 100 -eq 0 -or $i -eq $csvJuegos.Count) -and $needExecute) {
            
        $context.ExecuteQuery();
        write-host "|--- Execute OK" -ForegroundColor Green

    }

}