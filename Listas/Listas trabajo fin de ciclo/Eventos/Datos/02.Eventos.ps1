$csvPath = (Split-Path $MyInvocation.InvocationName)

$listaEventos = $context.web.Lists.GetByTitle("Eventos");
$itemsEventos = $listaEventos.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery());
$listaJuegos = $context.web.Lists.GetByTitle("Juegos");
$itemsJuegos = $listaJuegos.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery());
$context.Load($listaJuegos);
$context.Load($itemsJuegos);
$context.Load($listaEventos);
$context.Load($itemsEventos);
$context.ExecuteQuery();

$EventosSP = @{};

foreach ($itemEvento in $itemsEventos) {
    $EventosSP[$itemEvento["Title"]] = $itemEvento;
}


$juegosSP = $itemsJuegos | Group-Object {$_.FieldValues.Title} -AsHashTable -AsString;

$csvEventos = Import-Csv $csvPath"\02.Eventos.csv" ";" -Encoding UTF8;
$i = 0;
$needExecute = $false;
$csvEventos  | ForEach-Object { 

    $i++;

    #comprobamos si el juego existe en SP
    if ($null -ne $juegosSP[$_.TituloJuego]) {

        $juegoCSV = $juegosSP[$_.TituloJuego][0].Id;

        #comprobamos si el evento ya existe en SP;
        if ($null -eq $EventosSP[$_.TituloEvento]) {
                $itemInfo  = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
                $item = $listaEventos.AddItem($itemInfo)
                $item["Title"] = $_.TituloEvento;
                $item["E_Juego"] = $juegoCSV;
                $item.Update();
                $needExecute = $true;
                Write-Host "|--- $($_.TituloEvento) preparado para crear" -foregroundcolor Green  
        }
        else {
                Write-Host "|--- $($_.TituloEvento) ya existe" -foregroundcolor Green
                $item = $EventosSP[$_.TituloEvento];
                $needUpdate = $false;

                $fechaCSV = Get-Date $_.FechaEvento;
                $fechaSP = $item.FieldValues.E_Fech;

                if ($fechaCSV.Ticks -ne $fechaSP.Ticks) {
                    $item["E_Fech"] = $fechaCSV.ToUniversalTime();
                    $needUpdate = $true;
                    $needExecute = $true;
                }

                $fechaCSV = Get-Date $_.HoraInicio;
                $fechaSP = $item.FieldValues.E_Inicio;

                if ($fechaCSV.Ticks -ne $fechaSP.Ticks) {
                    $item["E_Inicio"] = $fechaCSV.ToUniversalTime();
                    $needUpdate = $true;
                    $needExecute = $true;
                
                }

                $fechaCSV = Get-Date $_.HoraFin;
                $fechaSP = $item.FieldValues.E_Fin;

                if ($fechaCSV.Ticks -ne $fechaSP.Ticks) {
                    $item["E_Fin"] = $fechaCSV.ToUniversalTime();
                    $needUpdate = $true;
                    $needExecute = $true;
                
                }
                if ($item["E_Desc"] -ne $_.Descripcion) {
                    $item["E_Desc"] = $_.Descripcion;
                    $needExecute = $true;
                    $needUpdate=$true;
                }

                if ($needUpdate) {
                    $item.Update();
                    Write-Host "|--- $($_.Nombre) preparado para actualizar" -foregroundcolor Green
                }

        }
     }
     else {
        write-host "El juego $($_.Titulo_Juego) no existe" -ForegroundColor Red
     }
    if (($i % 100 -eq 0 -or $i -eq $csvEventos.Count) -and $needExecute) {
            
        $context.ExecuteQuery();
        write-host "|--- Execute OK" -ForegroundColor Green

    }

}