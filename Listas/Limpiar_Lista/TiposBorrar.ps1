 

        $contentTypes = $web.ContentTypes;

        $context.Load($web);
        $context.Load($contentTypes);

        $context.ExecuteQuery();

    


        $tiposdecontenido = "Juegos";
        $tiposBorrar = New-Object System.Collections.ArrayList($null);

        foreach($tipo in $tiposdecontenido) {

            foreach ($contentType in $contentTypes) {

                if ($contentType.Name -eq $tipo) {
                    $dontshow = $tiposBorrar.Add($contentType);
                }

            }
           
        }
        foreach($borrame in $tiposBorrar) {
            $borrame.DeleteObject();
        }
        try{
        $context.executeQuery()
            write-host "Los tipos de contenido han sido correctamente eliminados" -foregroundcolor green
        }
        catch{
            write-host "ERROR: $($_.Exception.Message)" -foregroundcolor red
            Write-Host "Prueba a vaciar la papelera y la segunda etapa de la papelera" -ForegroundColor DarkMagenta
        }


    

