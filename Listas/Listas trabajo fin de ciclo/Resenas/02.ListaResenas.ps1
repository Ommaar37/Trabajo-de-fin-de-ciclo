#[guid]::NewGuid()

#Columnas
    

#La columna donde se guardará el título de la reseña será la columna título.
$listTitle = "Juegos"
$list = $web.Lists.GetByTitle($listTitle)
$context.Load($list);
$context.executeQuery()

$fieldAsXML = '<Field ID="{d3807c72-39c8-42e1-b14e-50b34e5a34b2}"
                Name="R_Juego"
                StaticName="R_Juego"
                DisplayName="Juego"
                Type="Lookup"
                List="'+$list.ID+'"
                ShowField="Title"
                Required="TRUE"
                Group="Comasis"/>'

$fieldOption = [Microsoft.SharePoint.Client.AddFieldOptions]::DefaultValue
$field = $fields.AddFieldAsXml($fieldAsXML, $true, $fieldOption)
$context.load($field);


#Columna que contiene el nombre del juego.

$fieldAsXml = '<Field Type="User"
    DisplayName="Usuario"
    Name="R_User"
    ID = "{5feaabdd-e85b-4eb9-a2e6-c4089e770e00}"
    Group="Comasis"
    Required = "TRUE" />'

$fieldOption = [Microsoft.SharePoint.Client.AddFieldOptions]::DefaultValue
$field = $fields.AddFieldAsXML($fieldAsXml, $true, $fieldOption)
$context.load($field);


#Columa de lookup que contiene el usuario que realizó la reseña.

#Columna con la reseña del juego.
$fieldAsXml = '<Field Type="Note"
    DisplayName="Reseña"
    Name="R_Res"
    ID = "{a603128b-4df4-4d91-8579-30e3c4db9ce3}"
    Group="Comasis"
    Required = "TRUE" />'

$fieldOption = [Microsoft.SharePoint.Client.AddFieldOptions]::DefaultValue
$field = $fields.AddFieldAsXML($fieldAsXml, $true, $fieldOption)
$context.load($field);


#Línea para ejecutar el añadir las columnas
$context.ExecuteQuery();
#




#Tipo de contenido
$contentTypeGroup = "Comasis";
$contentTypeName = "Resenas";

#Añadir los internal names de las columnas que compondrán el tipo de contenido
$columns = "R_Juego", "R_User", "R_Res";

$parentContentTypeID = "0x01"

$fields = $web.Fields
$contentTypes = $web.ContentTypes
$context.load($fields)
$context.load($contentTypes)

#enviar la solicitud que contiene todas las operaciones al servidor.

 try{
        $context.executeQuery()
        write-host "info: Loaded Fields and Content Types" -foregroundcolor green
    }
    catch{
        write-host "info: $($_.Exception.Message)" -foregroundcolor red
    }

#carga del tipo de contenido del padre

$parentContentType = $contentTypes.GetByID($parentContentTypeID)
$context.load($parentContentType)

    try{
            $context.executeQuery()
            write-host "info: loaded parent Content Type" -foregroundcolor green
        }
     catch{
            write-host "info: $($_.Exception.Message)" -foregroundcolor red
        }

#crear Tipo de contenido usando ContentTypeCreationInformation object (ctci)

    $ctci = new-object Microsoft.SharePoint.Client.ContentTypeCreationInformation
    $ctci.name = $contentTypeName
    $ctci.ParentContentType = $parentContentType
    $ctci.group = $contentTypeGroup
    $ctci = $contentTypes.add($ctci)
    $context.load($ctci)

    try{
        $context.executeQuery()
        write-host "info: Created content type" -foregroundcolor green
    }
    catch{
        write-host "info: $($_.Exception.Message)" -foregroundcolor red
    }

#conseguir el nuevo tipo de contenido objeto
$newContentType = $context.web.contenttypes.getbyid($ctci.id)

# loop through all the columns that needs to be added
foreach ($column in $columns){
    $field = $fields.GetByInternalNameOrTitle($column)
    #create FieldLinkCreationInformation object (flci)
    $flci = new-object Microsoft.SharePoint.Client.FieldLinkCreationInformation
    $flci.Field = $field
    $addContentType = $newContentType.FieldLinks.Add($flci)
    #write-host "info: added $($column) to array" -foregroundcolor green
}        
$newContentType.Update($true)
try{
    $context.executeQuery()
    write-host "info: Added columns to content type" -foregroundcolor green
}
catch{
    write-host "ERROR: $($_.Exception.Message)" -foregroundcolor red
}

        
$context.Load($newContentType.FieldLinks);
try{
    $context.executeQuery()
}
catch{
    write-host "ERROR en fields: $($_.Exception.Message)" -foregroundcolor red
}

    
        
$newContentType.Update($true)
        

Write-Host "Tipo de contenido $contentTypeName creado correctamente." -ForegroundColor Green;





#Lista

$listTitle = "Resenas"
$listDescription = "Lista donde se guardan las reseñas de los juegos, se guardará Juego que se referencia, usuario que realiza la reseña y la reseña en si"
$listTemplate = 100

$lci = New-Object Microsoft.SharePoint.Client.ListCreationInformation
$lci.title = $listTitle
$lci.description = $listDescription
$lci.TemplateType = $listTemplate
$list = $context.web.lists.add($lci)
$context.load($list)

    try{
        $context.executeQuery()
        write-host "List $($listTitle) created" -foregroundcolor green
    }
    catch{
        write-host "ERROR: $($_.Exception.Message)" -foregroundcolor red
    }  


    $list.ContentTypesEnabled = $true
    $list.EnableFolderCreation = $false;
    $list.OnQuickLaunch = $false;
    $list.Update();

#añadir/eliminar tipos de contenidos
$contentTypes = $web.ContentTypes;

$context.Load($contentTypes);

$context.ExecuteQuery();


#añadir tipos de contenido
$tiposdecontenido = "Resenas"

    foreach ($contentType in $contentTypes) {
        foreach ($tipodecontenido in $tiposdecontenido) {
            if ($contentType.Name -eq $tipodecontenido) {
                $AddCT = $list.ContentTypes.AddExistingContentType($contentType)
                continue
            }
        }
    }

    $tiposenlista = $list.ContentTypes;
    $context.Load($list.ContentTypes);
    $context.ExecuteQuery();

#eliminar tipos de contenido
$tiposBorrar = New-Object System.Collections.ArrayList($null);

    foreach ($tipoenlista in $list.ContentTypes) {
        if ($tipoenlista.Name -eq "Elemento") {
            $dontshow = $tiposBorrar.Add($tipoenlista);
            
        }
    }
    foreach ($tipoBorrar in $tiposBorrar) {
        $tipoBorrar.DeleteObject();
        
    }
    $context.ExecuteQuery();

    $list.Update();  
    
    try{
        $context.executeQuery()
        write-host "content type $tipodecontenido added to the list" -foregroundcolor green
    }
    catch{
        write-host "ERROR: $($_.Exception.Message)" -foregroundcolor red
    }  



# ----- VISTA -----

#Meter en la variable de $list los elementos que estén en la lista que le pasamos como parámetro.

$list = $context.web.lists.getbytitle("Resenas")

$views = $list.Views;

$context.Load($views);

$context.executeQuery()

    foreach ($view in $views) {

        if ($view.Title -eq "Todos los elementos") { #Todos los elementos

            $vista = $view;

            continue

        }

    }

    if ($vista) {

        $viewFields = $vista.ViewFields;

        $context.Load($viewFields);

        $context.ExecuteQuery();

        foreach ($column in $columns) {

            $vista.ViewFields.Add($column);

        }

        $vista.ViewQuery = "<OrderBy><FieldRef Name='LinkTitle' Ascending='FALSE'/></OrderBy>"

        $vista.Update();

        try{

            $context.executeQuery()

            write-host "vista modificada correctamente" -foregroundcolor green

        }

        catch{

            write-host "info: $($_.Exception.Message)" -foregroundcolor red

        }  

    }

    else {

        Write-Host "ERROR: no localizamos la vista" -ForegroundColor Red

    }
