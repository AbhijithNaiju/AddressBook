<cfset local.myObject = createObject("component", "components.addressBook")>
<cfset local.pdfPrintData = local.myObject.getPdfData()>    

<cfset local.folderName = "./assets/pdfFiles/">
<cfif NOT directoryExists(expandPath("../#local.folderName#"))>
    <cfset directoryCreate(expandPath("../#local.folderName#"))>
</cfif>

<cfdocument  format="PDF" filename="#local.folderName#/contacts.pdf" overwrite="true">
    <table border="2" >
        <tr>
            <th>Image</th>
<!---       <th> NAME </th> --->
            <th>DOB</th>
            <th>ADDRESS</th>
            <th>PINCODE</th>
            <th>PHONE NUMBER</th>
            <th>EMAIL ID</th>
        </tr>
        <cfoutput>
            <cfloop query="local.pdfPrintData">
                <cfif local.pdfPrintData.profileImage EQ "">
                    <cfset local.contactProfileImage = "./Assets/contactPictues/l60Hf.png">
                <cfelse>
                    <cfset local.contactProfileImage = local.pdfPrintData.profileImage>
                </cfif>
                <tr>
<!---               <td>
                        <img src="#local.contactProfileImage#" alt="Image not found" width="100" height="100"> 
                    </td>   --->
                    <td>
                        #local.pdfPrintData.firstName# #local.pdfPrintData.lastName#
                    </td>
                    <td>
                        #local.pdfPrintData.DOB#
                    </td>
                    <td>
                        #local.pdfPrintData.address#,
                        #local.pdfPrintData.streetName#,
                        #local.pdfPrintData.district#,
                        #local.pdfPrintData.STATE#,
                        #local.pdfPrintData.country#
                    </td>
                    <td>
                        #local.pdfPrintData.pincode#
                    </td>
                    <td>
                        #local.pdfPrintData.phoneNumber#
                    </td>
                    <td>
                        #local.pdfPrintData.emailId#
                    </td>
                </tr>
            </cfloop>
        </cfoutput>
    </table>
</cfdocument>