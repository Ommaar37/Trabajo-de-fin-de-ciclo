#[guid]::NewGuid()

#Columnas
    

#La columna donde se guardará el nombre del juego será la columna título.

#Columna con la descripción del juego.
$fieldAsXml = '<Field Type="Note"
    DisplayName="Descripción"
    Name="J_Desc"
    ID = "{55259d02-1637-479a-93f8-be8c625fc652}"
    Group="Comasis"
    Required = "TRUE" />'

$fieldOption = [Microsoft.SharePoint.Client.AddFieldOptions]::DefaultValue
$field = $fields.AddFieldAsXML($fieldAsXml, $true, $fieldOption)
$context.load($field);


#Columna de seleccionador que guarda el género del juego.

$fieldAsXml = '<Field Type="Choice"
      DisplayName="Género del juego."
      Name="J_Gen"
      Indexed="True"
      ID = "{c89a3014-59d3-4600-bfed-69356102d7a1}"
      Group="Comasis"
      Required = "TRUE">
      <CHOICES>
        <CHOICE>Acción</CHOICE>
        <CHOICE>Plataforma</CHOICE>
        <CHOICE>Lucha</CHOICE>
        <CHOICE>Shooter</CHOICE>
        <CHOICE>Arcade</CHOICE>
        <CHOICE>Aventura</CHOICE>
        <CHOICE>Estrategia</CHOICE>
        <CHOICE>Deportes</CHOICE>
        <CHOICE>Simulación</CHOICE>
      </CHOICES>
      </Field>';
      
      
    

$fieldOption = [Microsoft.SharePoint.Client.AddFieldOptions]::DefaultValue
$field = $fields.AddFieldAsXML($fieldAsXml, $true, $fieldOption)
$context.load($field);
$context.ExecuteQuery();


#Columna de seleccionador que guarda la duración mínima del modo campaña (en caso de tenerlo, sino habrá una opción que así lo indique)

$fieldAsXml = '<Field Type="Choice"
      DisplayName="Duración de la campaña del juego."
      Name="J_Dur"
      Indexed="True"
      ID = "{b1808fe7-1d21-41fe-90cc-4f8bcdc03adb}"
      Group="Comasis"
      Required = "TRUE">
      <CHOICES>
                    <CHOICE>No tiene modo campaña.</CHOICE>
                    <CHOICE>De 10 a 20 horas.</CHOICE>
                    <CHOICE>De 20 a 30 horas.</CHOICE>
                    <CHOICE>De 30 a 40 horas.</CHOICE>
                    <CHOICE>De 40 a 50 horas.</CHOICE>
                    <CHOICE>De 50 a 60 horas.</CHOICE>
                    <CHOICE>Más de 60 horas.</CHOICE>
      </CHOICES>
      </Field>';
      
    

$fieldOption = [Microsoft.SharePoint.Client.AddFieldOptions]::DefaultValue
$field = $fields.AddFieldAsXML($fieldAsXml, $true, $fieldOption)
$context.load($field);
$context.ExecuteQuery();


#Columna de fecha que guarda la fecha de lanzamiento.

$fieldAsXml = '<Field Type="DateTime" Format="DateOnly"
      DisplayName="Fecha de lanzamiento."
      Name="J_Lanz"
      Indexed="True"
      ID = "{70e88633-fc6e-45aa-83a3-86021b2956a4}"
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
$contentTypeName = "Juegos";

#Añadir los internal names de las columnas que compondrán el tipo de contenido
$columns = "J_Desc", "J_Gen", "J_Dur", "J_Lanz"

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

$listTitle = "Juegos"
$listDescription = "Lista donde se guardan los nombres de los juegos y algunas características."
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
$tiposdecontenido = "Juegos"

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

$list = $context.web.lists.getbytitle("Juegos")

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
