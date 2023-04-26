
    $listTitles = "Resenas"


    foreach ($listTitle in $listTitles) {
    
        $list = $web.Lists.GetByTitle($listTitle)

        $context.Load($list);
        $context.ExecuteQuery();

        $list.DeleteObject();
    
        try {
            $context.ExecuteQuery();
            #$list.Update();
            Write-Host "La lista $listTitle se ha eliminado correctamente" -foregroundcolor green
        }
        catch{
            write-host "info: $($_.Exception.Message)" -foregroundcolor red
        } 
    }

    

