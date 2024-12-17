<cffunction  name="formatExcel">
    <cfargument  name="inputFile">
    <cfspreadsheet  action="read" src = "#arguments.inputFile#" headerrow="1" excludeHeaderRow = "true" query = "local.excelValues">
    <cfdump  var="#local.excelValues#">

    <cfset local.arrayErrorMessages = arrayNew(1)>
    <cfset local.errorArray = arrayNew(1)>
    <cfset local.headingArray = ["First Name","Last Name","Gender","DOB","Address","Street Name","District","State","Country","Pincode","Email ID","Phone Number","Role"]>
    <cfloop query="local.excelValues">
        <cfset local.missingArray = arrayNew(1)>
        <cfset local.errorArray = arrayNew(1)>

        <cfloop array="#local.headingArray#" item="local.headingArrayItem">

            <cfif local.excelValues[local.headingArrayItem].toString() EQ "">
                <cfset arrayAppend(local.missingArray , local.headingArrayItem)>
            <cfelse>

                <cfif (local.headingArrayItem EQ "pincode" OR local.headingArrayItem EQ "Phone Number") AND NOT isNumeric(local.excelValues[local.headingArrayItem].toString())>
                    <cfset arrayAppend(local.errorArray, local.headingArrayItem)>
                <cfelseif local.headingArrayItem EQ "pincode" AND local.excelValues[local.headingArrayItem].toString().len() NEQ 6>
                    <cfset arrayAppend(local.errorArray, local.headingArrayItem)>
                <cfelseif local.headingArrayItem EQ "Phone Number" AND local.excelValues[local.headingArrayItem].toString().len() NEQ 10>
                    <cfset arrayAppend(local.errorArray, local.headingArrayItem)>
                </cfif>

            </cfif>

        </cfloop>

        <cfif NOT arrayIsEmpty(local.missingArray)>
            <cfset local.arrayErrorMessages[local.excelValues.currentRow] = "Missing columns - " & arrayToList(local.missingArray,',')>
        <cfelseif NOT arrayIsEmpty(local.errorArray)>
            <cfset local.arrayErrorMessages[local.excelValues.currentRow] = "Error columns - " & arrayToList(local.errorArray,',')>
        <cfelse>
<!---             CONDITION TO EXECUTE IF THERE IS NO ERROR IN INPUTS --->
        </cfif>
    </cfloop>
    <cfset queryAddColumn(local.excelValues, "Result", local.arrayErrorMessages)>

    <cfdump  var="#local.excelValues#">
</cffunction>
 