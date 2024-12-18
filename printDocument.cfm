<cfset local.addressBookObj = createObject("component", "components.addressBook")>
<cfset local.pdfPrintData = local.addressBookObj.getAllContactDetails()>   

<cfset local.folderName = "./assets/pdfFiles/">
<cfif NOT directoryExists(expandPath("../#local.folderName#"))>
    <cfset directoryCreate(expandPath("../#local.folderName#"))>
</cfif>
<cfset local.filename = session.userName & "_" & dateTimeFormat(now(),"dd-mm-yyy-HH-nn-ss") & ".pdf">
<cfdocument  format="PDF" filename="#local.folderName##local.filename#" overwrite="true">
    <table border="2" >
        <tr>
            <th>Image</th>
<!---       <th> NAME </th> --->
            <th>DOB</th>
            <th>ADDRESS</th>
            <th>PINCODE</th>
            <th>PHONE NUMBER</th>
            <th>EMAIL ID</th>
            <th>Role</th>
        </tr>
        <cfoutput>
            <cfloop query="local.pdfPrintData">
                <cfset local.qryContactRole = local.addressBookObj.getContactRoles(local.pdfPrintData.contactId)>
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
                        #local.pdfPrintData.state#,
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
                    <td>
                        #local.pdfPrintData.roleNames#
                    </td>
                </tr>
            </cfloop>
        </cfoutput>
    </table>
</cfdocument>