 <a href="./Components/addressBook.cfc?method=checkEmailAndNumberExist">Print</a> 

<!---
<cfoutput>

    <cfset local.myObject = createObject("component", "components.addressBook")>
    <cfset local.userdetails = local.myObject.getXlsData()>

    <cfset local.folderName = expandPath("./assets/Downloads/")> 
     <cfset local.filename = local.folderName & "/contact1.xls"> --->
<!---    <cfset local.sheet = spreadsheetNew("name")>

    <cfset spreadsheetAddRow(local.sheet, 'First Name,Last Name,Gender,DOB,Address,Street Name,Pincode,District,State,Country,Email ID,Phone Number')>
    <cfset spreadsheetFormatRow(local.sheet, {bold=true}, 1)>
    <cfset spreadsheetAddRows(local.sheet, local.userdetails)>

    <cfset local.filename = local.folderName & "contact11.xls">

    <cfif  FileExists(local.filename  )>
        <cfdump  var="#local.filename#">
    <cfelse>
        <cfspreadsheet  action="write"  
                        filename="#local.filename#" 
                        name="local.sheet"
                        overwrite=true>
        <cfdump  var="11111">
    </cfif>
     <cfset spreadsheetwrite(local.sheet, expandPath("./assets./Downloads/contact.xls"),true)> --->

<!--- </cfoutput> --->
