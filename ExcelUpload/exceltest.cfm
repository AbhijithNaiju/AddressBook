<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <cfset addressBookObj = createObject("component","components.addressBook")>
    <form method="post" enctype="multipart/form-data">
        <input type="file" name = "inputFile"> 
        <button name = "submit">Upload</button>
    </form>
    <cfif structKeyExists(form, "submit") AND len(form.inputFile)>
        <cfset result = addressBookObj.formatExcel(inputFile = form.inputFile)>
    </cfif>
</body>
</html>