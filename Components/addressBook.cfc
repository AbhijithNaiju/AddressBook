<cfcomponent>

<!---     Check  email exist or not using Ajax --->
    <cffunction  name="emailExists" returntype="any" access="remote">
        <cfargument  name="email" type="string"> 

        <cfquery name="emailCheck" >
            SELECT count('email') 
            AS userCount 
            FROM userTable 
            WHERE email=<cfqueryparam value='#arguments.email#' cfsqltype="cf_sql_varchar">;
        </cfquery>

        <cfif emailCheck.userCount>
            <cfreturn true>
         </cfif> 
    </cffunction>

<!---     Check  username exist or not using Ajax --->
    <cffunction  name="userNameExists" returntype="any" access="remote">
        <cfargument  name="userName" type="string"> 

        <cfquery name="userNameCheck" >
            SELECT count('userName') 
            AS userCount 
            FROM userTable 
            WHERE username=<cfqueryparam value='#arguments.userName#' cfsqltype="cf_sql_varchar">;
        </cfquery>

        <cfif userNameCheck.userCount>
            <cfreturn true>
        </cfif> 
    </cffunction>

<!---     User signup --->
    <cffunction  name="userSignup" returntype="struct">

        <cfargument  name="fullName" type="string">
        <cfargument  name="emailId" type="string">
        <cfargument  name="userName" type="string">
        <cfargument  name="password" type="string">
        <cfargument  name="profileImageSrc" type="string">
        
        <cfset local.structResult = structNew()>
        <cfset local.hashedPassword = hash(arguments.password, "SHA-256")> 

        <cfquery name="emailCheck" >
            SELECT count('email') 
            AS userCount 
            FROM userTable 
            WHERE email=<cfqueryparam value='#arguments.emailId#' cfsqltype="cf_sql_varchar">;
        </cfquery>

        <cfquery name="userNameCheck" >
            SELECT count('userName') 
            AS userCount 
            FROM userTable 
            WHERE username=<cfqueryparam value='#arguments.userName#' cfsqltype="cf_sql_varchar">;
        </cfquery>

        <cfif emailCheck.userCount>
            <cfset local.structResult["error"] = "Email already exists">
        <cfelseif userNameCheck.usercount>
            <cfset local.structResult["error"] = "Username already exists">
        <cfelse>
            <cftry>

                <cfquery name="userInsert">
                    INSERT INTO userTable(fullName,
                                        email,
                                        userName,
                                        password,
                                        profileImage)
                    VALUES(<cfqueryparam value='#arguments.fullName#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#arguments.emailId#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#arguments.userName#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#local.hashedPassword#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#arguments.profileImageSrc#' cfsqltype="cf_sql_varchar">);
                </cfquery>

            <cfcatch type="exception">
                <cfset local.structResult["error"] = "Error">
            </cfcatch>

            </cftry>
        </cfif> 

<!---         redirecting to login if signup success --->
        <cfif NOT structKeyExists(local.structResult, "error")>
            <cfset userLogin(arguments.userName,arguments.password)>
        </cfif>

        <cfreturn local.structResult>
    </cffunction>

<!---     User login --->
    <cffunction  name="userLogin" returntype="struct">

        <cfargument  name="userName" type="string">
        <cfargument  name="password" type="string">

        <cfset local.structResult = structNew()>
        <cfset local.hashedPassword = hash(arguments.password, "SHA-256")> 

        <cfquery name = "selectUser" >
            SELECT userId
            FROM userTable
            WHERE userName = <cfqueryparam value='#arguments.userName#' cfsqltype="cf_sql_varchar">
            AND password = <cfqueryparam value='#local.hashedPassword#' cfsqltype="cf_sql_varchar">;
        </cfquery>
        
        <cfif selectUser.recordcount>
            <cfset session.userId = selectUser.userId>
            <cfset local.structResult["success"] = "success">
            <cflocation  url="./home.cfm">
        <cfelse>
            <cfset local.structResult["error"] = "Please enter a valid username and password">
        </cfif>

        <cfreturn local.structResult>
    </cffunction>

<!---     Remote login --->
    <cffunction  name="logOut"  access="remote">
        <cfset structClear(session)>
        <cfreturn true>
    </cffunction>

<!---     User details for homepage --->
    <cffunction  name="userDetails">
        <cfquery name = "getUserDetails" >
            SELECT fullName,profileImage
            FROM userTable
            WHERE userId = <cfqueryparam value='#session.userId#' cfsqltype="cf_sql_varchar">;
        </cfquery>
        <cfreturn getUserDetails>
    </cffunction>

<!---     Creating contact --->
    <cffunction  name="addContact" returntype="struct">

        <cfargument  name="structForm" type="struct">
        <cfargument  name="imageLink" type="string">

        <cfset local.structResult = structNew()>
        <cfset local.createDate = dateformat(now(),"yyyy-mm-dd")>

        <cftry>
            <cfquery>
                INSERT INTO contactDetails( title,
                                            firstName,
                                            lastName,
                                            gender,
                                            DOB,
                                            profileImage,
                                            address,
                                            streetName,
                                            district,
                                            state,
                                            country,
                                            pincode,
                                            emailId,
                                            phoneNumber,
                                            _createdBy,
                                            _createdOn,
                                            _updatedBy,
                                            _updatedOn)
                VALUES( <cfqueryparam value='#arguments.structForm["title"]#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#arguments.structForm["firstName"]#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#arguments.structForm["lastName"]#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#arguments.structForm["gender"]#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#arguments.structForm["dateOfBirth"]#' cfsqltype="cf_sql_date">,
                        <cfqueryparam value='#arguments.imageLink#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#arguments.structForm["address"]#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#arguments.structForm["streetName"]#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#arguments.structForm["district"]#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#arguments.structForm["state"]#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#arguments.structForm["country"]#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#arguments.structForm["pincode"]#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#arguments.structForm["email"]#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#arguments.structForm["phoneNumber"]#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#session.userId#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#local.createDate#' cfsqltype="cf_sql_date">,
                        <cfqueryparam value='#session.userId#' cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value='#local.createDate#' cfsqltype="cf_sql_date">)
            </cfquery>
        <cfcatch type="exception">
            <cfset local.structResult["error"] = "Error while creating">
        </cfcatch>
        </cftry>

        <cfreturn local.structResult>
    </cffunction>

<!---     Edit contact details --->
    <cffunction  name="editContact" returntype="struct">

        <cfargument  name="structForm" type="struct">
        <cfargument  name="imageLink" type="string">

        <!--- getting imagelink to delete --->
        <cfquery name = "getDeleteImage">
            SELECT profileImage
            FROM contactDetails
            WHERE contactId = <cfqueryparam value='#arguments.structForm["editContact"]#' cfsqltype="cf_sql_varchar">;
        </cfquery>

        <cfset local.structResult = structNew()>
        <cfset local.updateDate = dateformat(now(),"yyyy-mm-dd")>

        <cftry>
            <cfquery>
                UPDATE contactDetails 
                SET title = <cfqueryparam value='#arguments.structForm["title"]#' cfsqltype="cf_sql_varchar">,
                    firstName = <cfqueryparam value='#arguments.structForm["firstName"]#' cfsqltype="cf_sql_varchar">,
                    lastName = <cfqueryparam value='#arguments.structForm["lastName"]#' cfsqltype="cf_sql_varchar">,
                    gender = <cfqueryparam value='#arguments.structForm["gender"]#' cfsqltype="cf_sql_varchar">,
                    DOB = <cfqueryparam value='#arguments.structForm["dateOfBirth"]#' cfsqltype="cf_sql_date">,
                    profileImage = <cfqueryparam value='#arguments.imageLink#' cfsqltype="cf_sql_varchar">,
                    address = <cfqueryparam value='#arguments.structForm["address"]#' cfsqltype="cf_sql_varchar">,
                    streetName = <cfqueryparam value='#arguments.structForm["streetName"]#' cfsqltype="cf_sql_varchar">,
                    district = <cfqueryparam value='#arguments.structForm["district"]#' cfsqltype="cf_sql_varchar">,
                    state = <cfqueryparam value='#arguments.structForm["state"]#' cfsqltype="cf_sql_varchar">,
                    country = <cfqueryparam value='#arguments.structForm["country"]#' cfsqltype="cf_sql_varchar">,
                    pincode = <cfqueryparam value='#arguments.structForm["pincode"]#' cfsqltype="cf_sql_varchar">,
                    emailId = <cfqueryparam value='#arguments.structForm["email"]#' cfsqltype="cf_sql_varchar">,
                    phoneNumber = <cfqueryparam value='#arguments.structForm["phoneNumber"]#' cfsqltype="cf_sql_varchar">,
                    _updatedBy = <cfqueryparam value='#session.userId#' cfsqltype="cf_sql_varchar">,
                    _updatedOn = <cfqueryparam value='#local.updateDate#' cfsqltype="cf_sql_date">
                WHERE contactId = <cfqueryparam value='#arguments.structForm["editContact"]#' cfsqltype="cf_sql_varchar">;
            </cfquery>

            <!--- Deleting old image if new one is added --->
            <cfif getDeleteImage.profileImage NEQ arguments.imageLink>
                <cfset local.absolutePath = expandPath("../#getDeleteImage.profileImage#")>
                <cfif FileExists(local.absolutePath)>
                    <cffile  action = "delete" file = "#local.absolutePath#">
                </cfif>
            </cfif>

        <cfcatch type="exception">
                <cfset local.structResult["Error"] = "Error occured">
        </cfcatch>
        </cftry>

        <cfreturn local.structResult>
    </cffunction>

<!---     Contact list for home page --->
    <cffunction  name = "getAllContacts" returntype = "query">

        <cfquery name = "allContacts">
            SELECT contactId,firstName,lastName,profileImage,emailId,phoneNumber
            FROM contactDetails
            WHERE _createdBy = <cfqueryparam value='#session.userId#' cfsqltype="cf_sql_varchar">;
        </cfquery>

        <cfreturn allContacts>
    </cffunction>

<!---     Delete contact from table --->
    <cffunction  name="deleteContact" access="remote">
        <cfargument  name="deleteId" type="string">

        <!--- getting imagelink to delete --->
        <cfquery name = "getDeleteImage">
            SELECT profileImage
            FROM contactDetails
            WHERE contactId = <cfqueryparam value='#arguments.deleteId#' cfsqltype="cf_sql_varchar">;
        </cfquery>


        <cfquery>
            DELETE FROM contactDetails
            WHERE contactId = <cfqueryparam value='#arguments.deleteId#' cfsqltype="cf_sql_varchar">;
        </cfquery>
        
        <!---   Deleting image --->
        <cfset local.absolutePath = expandPath("../#getDeleteImage.profileImage#")>
        <cfif FileExists(local.absolutePath)>
            <cffile  action = "delete" file = "#local.absolutePath#">
        </cfif>

        <cfreturn true>

    </cffunction>

<!---     single contact detail to ajax call for view modal--->
    <cffunction  name="getContactData" access="remote" returnformat="JSON">
        <cfargument  name="viewId" type="string">

        <cfset local.structResult = structNew("ordered")>

        <cfquery name = "contactDetails">
            SELECT  title,
                    firstName,
                    lastName,
                    gender,
                    DOB,
                    profileImage,
                    address,
                    streetName,
                    district,
                    state,
                    country,
                    pincode,
                    emailId,
                    phoneNumber
            FROM contactDetails
            WHERE contactId = <cfqueryparam value='#arguments.viewId#' cfsqltype="cf_sql_varchar">;
        </cfquery>

        <cfset local.structResult["Name"] = contactDetails.title & " " & contactDetails.firstName & " " & contactDetails.lastName> 
        <cfset local.structResult["Gender"] = contactDetails.gender>
        <cfset local.structResult["Date Of Birth"] = dateFormat(contactDetails.DOB,"dd-mm-yyyy")>
        <cfset local.structResult["profileImage"] = contactDetails.profileImage>
        <cfset local.structResult["Address"] = contactDetails.address & ", " & contactDetails.streetName & ", " & contactDetails.district & ", " & contactDetails.state & ", " &contactDetails.country>
        <cfset local.structResult["Pincode"] = contactDetails.pincode>
        <cfset local.structResult["Email Id"] = contactDetails.emailId>
        <cfset local.structResult["Phone Number"] = contactDetails.phoneNumber>

        <cfreturn local.structResult>

    </cffunction>

<!---     single contact detail to ajax for edit modal --->
    <cffunction  name="getEditData" access="remote" returnformat="JSON">
        <cfargument  name="editId" type="string">

        <cfset local.structResult = structNew("ordered")>

        <cfquery name = "editData">
            SELECT  title,
                    firstName,
                    lastName,
                    gender,
                    DOB,
                    profileImage,
                    address,
                    streetName,
                    district,
                    state,
                    country,
                    pincode,
                    emailId,
                    phoneNumber
            FROM contactDetails
            WHERE contactId = <cfqueryparam value='#arguments.editId#' cfsqltype="cf_sql_varchar">;
        </cfquery>

        <cfset local.structResult["title"] = editData.title> 
        <cfset local.structResult["firstName"] = editData.firstName> 
        <cfset local.structResult["lastName"] = editData.lastName> 
        <cfset local.structResult["gender"] = editData.gender>
        <cfset local.structResult["dateOfBirth"] = dateFormat(editData.DOB,"yyyy-mm-dd")>
        <cfset local.structResult["profileImage"] = editData.profileImage>
        <cfset local.structResult["address"] = editData.address>
        <cfset local.structResult["streetName"] = editData.streetName>
        <cfset local.structResult["pincode"] = editData.pincode>
        <cfset local.structResult["district"] = editData.district>
        <cfset local.structResult["state"] = editData.state>
        <cfset local.structResult["country"] = editData.country>
        <cfset local.structResult["email"] = editData.emailId>
        <cfset local.structResult["phoneNumber"] = editData.phoneNumber>

        <cfreturn local.structResult>

    </cffunction>

    <cffunction  name="printPage">
        <cfhtmltopdf encryption="AES_128"
                     source = "C:\ColdFusion2021\cfusion\wwwroot\AddressBook\printDocument.cfm"
                     permissions="AllowPrinting" 
                     destination="usage_example.pdf" 
                     overwrite="yes">
        </cfhtmltopdf>
    </cffunction>

    <cffunction  name="createSpreadsheet" access="remote" returnformat="json">
        <cfargument  name="inputFileName" type="string">
        <cfset local.structResult = structNew()>

        <cfquery name = "xlsData">
            SELECT  firstName,
                    lastName,
                    gender,
                    DOB,
                    address,
                    streetName,
                    district,
                    state,
                    country,
                    pincode,
                    emailId,
                    phoneNumber
            FROM contactDetails
            WHERE _createdBy = <cfqueryparam value='#session.userId#' cfsqltype="cf_sql_varchar">;
        </cfquery>


        <cfset local.folderName = "c:\Users\Abhijith\Downloads\">
        <cfset local.sheet = spreadsheetNew("name")>

        <cfset spreadsheetAddRow(local.sheet, 'First Name,Last Name,Gender,DOB,Address,Street Name,Pincode,District,State,Country,Email ID,Phone Number')>
        <cfset spreadsheetFormatRow(local.sheet, {bold=true}, 1)>
        <cfset spreadsheetAddRows(local.sheet, xlsData)>

        <cfset local.fileName = local.folderName & arguments.inputFileName & ".xls">

        <cfif  FileExists(local.fileName)>
            <cfset local.structResult["error"] = "File already exists">
        <cfelse>
            <cfspreadsheet  action="write"  
                            filename="#local.fileName#" 
                            name="local.sheet"
                            overwrite=true>
            <cfreturn true>
        </cfif>
    </cffunction>
</cfcomponent>