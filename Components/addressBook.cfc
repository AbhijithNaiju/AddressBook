<cfcomponent>

<!---     Checker email or username already exists during signup --->
    <cffunction  name="emailAndUNameCheck" returnformat="JSON" access="remote">
        <cfargument  name = "email" type = "string"> 
        <cfargument  name = "userName" type="string" default="" required = "false"> 

        <cfset local.structResult = structNew()>

        <cfif arguments.email NEQ "">

            <cfquery name="qryEmailExist" >
                SELECT count('email') AS emailCount
                FROM userTable
                WHERE email = < cfqueryparam value = '#arguments.email#' cfsqltype = "cf_sql_varchar" >;
            </cfquery>

            <cfif qryEmailExist.emailCount>
                <cfset local.structResult["emailError"] = "Email already exists">
            <cfelse>
                <cfset local.structResult["emailSuccess"] = "true">
            </cfif>

        </cfif>

        <cfif arguments.userName NEQ "">

            <cfquery name="qryUserNameExist" >
                SELECT count('userName') AS userNameCount
                FROM userTable
                WHERE username = < cfqueryparam value = '#arguments.userName#' cfsqltype = "cf_sql_varchar" >;
            </cfquery>

            <cfif qryUserNameExist.userNameCount>
                <cfset local.structResult["userNameError"] = "UserName already exists">
            <cfelse>
                <cfset local.structResult["userNameSuccess"] = "true">
            </cfif>
        </cfif>

        <cfreturn local.structResult>
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
            SELECT count('email') AS userCount
            FROM userTable
            WHERE email = < cfqueryparam value = '#arguments.emailId#' cfsqltype = "cf_sql_varchar" >;
        </cfquery>

        <cfquery name="userNameCheck" >
            SELECT count('userName') AS userCount
            FROM userTable
            WHERE username = < cfqueryparam value = '#arguments.userName#' cfsqltype = "cf_sql_varchar" >;
        </cfquery>

        <cfif emailCheck.userCount>
            <cfset local.structResult["error"] = "Email already exists">
        <cfelseif userNameCheck.usercount>
            <cfset local.structResult["error"] = "Username already exists">
        <cfelse>
            <cftry>

                <cfquery name="userInsert">
                    INSERT INTO userTable (
                        fullName
                        ,email
                        ,userName
                        ,password
                        ,profileImage
                        )
                    VALUES (
                        < cfqueryparam value = '#arguments.fullName#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#arguments.emailId#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#arguments.userName#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#local.hashedPassword#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#arguments.profileImageSrc#' cfsqltype = "cf_sql_varchar" >
                        );
                </cfquery>

            <cfcatch type="any">
                <cfset local.structResult["error"] = "Error occured while creating account.">
            </cfcatch>

            </cftry>
        </cfif> 

        <!---         redirecting to login if signup success --->
        <cfif NOT structKeyExists(local.structResult, "error")>
            <cfset userLogin(arguments.emailId,arguments.password)>
        </cfif>

        <cfreturn local.structResult>
    </cffunction>

<!---     User login --->
    <cffunction  name="userLogin" returntype="struct">
        <cfargument  name="emailId" type="string">
        <cfargument  name="password" type="string">

        <cfset local.structResult = structNew()>
        <cfset local.hashedPassword = hash(arguments.password, "SHA-256")> 

        <cfquery name = "selectUser" >
            SELECT userId
            FROM userTable
            WHERE email = < cfqueryparam value = '#arguments.emailId#' cfsqltype = "cf_sql_varchar" >
                AND password = < cfqueryparam value = '#local.hashedPassword#' cfsqltype = "cf_sql_varchar" >;
        </cfquery>
        
        <cfif selectUser.recordcount>
            <cfset session.userId = selectUser.userId>
            <cfset local.structResult["success"] = "success">
            <cflocation  url="./home.cfm">
        <cfelse>
            <cfset local.structResult["error"] = "Please enter a valid email and password">
        </cfif>

        <cfreturn local.structResult>
    </cffunction>

    <cffunction  name="adminLogin" returntype="struct">
        <cfargument  name="emailId" type="string">
        <cfargument  name="password" type="string">

        <cfset local.structResult = structNew()>
<!---         <cfset local.hashedPassword = hash(arguments.password, "SHA-256")>  --->

        <cfif arguments.emailId EQ "admin@gmail.com" AND arguments.password EQ "adminpass">
            <cfset session.adminLogin = "true">
            <cfset local.structResult["success"] = "success">
            <cflocation  url="./scheduleset.cfm">
        <cfelse>
            <cfset local.structResult["error"] = "Please enter a valid email and password">
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
            SELECT fullName
                ,profileImage
            FROM userTable
            WHERE userId = < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_varchar" >;
        </cfquery>

        <cfreturn getUserDetails>
    </cffunction>

<!---     Creating contact --->
    <cffunction  name="addContact" returntype="struct">
        <cfargument  name="structForm" type="struct">
        <cfargument  name="imageLink" type="string">

        <cfset local.structResult = structNew()>
        <cfset local.createDate = dateformat(now(),"yyyy-mm-dd")>
        <cfset local.checkEmailResult = checkEmailAndNumberExist(arguments.structForm["email"],arguments.structForm["phoneNumber"])>

        <cfif structKeyExists(local.checkEmailResult, "phoneError") OR structKeyExists(local.checkEmailResult, "emailError")>
            <cfset local.structResult["error"] = "Error email or phone alrady exists">
        <cfelse>
            <cftry>
                <cfquery>
                    INSERT INTO contactDetails (
                        title
                        ,firstName
                        ,lastName
                        ,gender
                        ,DOB
                        ,profileImage
                        ,address
                        ,streetName
                        ,district
                        ,STATE
                        ,country
                        ,pincode
                        ,emailId
                        ,phoneNumber
                        ,_createdBy
                        ,_createdOn
                        ,_updatedBy
                        ,_updatedOn
                        )
                    VALUES (
                        < cfqueryparam value = '#arguments.structForm["title"]#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#arguments.structForm["firstName"]#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#arguments.structForm["lastName"]#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#arguments.structForm["gender"]#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#arguments.structForm["dateOfBirth"]#' cfsqltype = "cf_sql_date" >
                        ,< cfqueryparam value = '#arguments.imageLink#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#arguments.structForm["address"]#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#arguments.structForm["streetName"]#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#arguments.structForm["district"]#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#arguments.structForm["state"]#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#arguments.structForm["country"]#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#arguments.structForm["pincode"]#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#arguments.structForm["email"]#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#arguments.structForm["phoneNumber"]#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#local.createDate#' cfsqltype = "cf_sql_date" >
                        ,< cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_varchar" >
                        ,< cfqueryparam value = '#local.createDate#' cfsqltype = "cf_sql_date" >
                        );
                </cfquery>
            <cfcatch type="any">
                <cfset local.structResult["error"] = "Error while creating the contact">
            </cfcatch>
            </cftry>
        </cfif>

        <cfreturn local.structResult>
    </cffunction>

<!---     Edit contact details --->
    <cffunction  name="editContact" returntype="struct">
        <cfargument  name="structForm" type="struct">
        <cfargument  name="imageLink" type="string">

        <cfset local.structResult = structNew()>
        <cfset local.updateDate = dateformat(now(),"yyyy-mm-dd")>
        <cfset local.checkEmailResult = checkEmailAndNumberExist(arguments.structForm["email"],arguments.structForm["phoneNumber"],arguments.structForm["editContact"])>

        <cfif structKeyExists(local.checkEmailResult, "phoneError") OR structKeyExists(local.checkEmailResult, "emailError")>
            <cfset local.structResult["error"] = "Error email or phone already exists">
        <cfelse>

            <!--- getting imagelink to delete --->
            <cfquery name = "getDeleteImage">
                SELECT profileImage
                FROM contactDetails
                WHERE contactId = < cfqueryparam value = '#arguments.structForm["editContact"]#' cfsqltype = "cf_sql_varchar" >;
            </cfquery>

            <cftry>
                <cfquery>
                    UPDATE contactDetails
                    SET title = < cfqueryparam value = '#arguments.structForm["title"]#' cfsqltype = "cf_sql_varchar" >
                        ,firstName = < cfqueryparam value = '#arguments.structForm["firstName"]#' cfsqltype = "cf_sql_varchar" >
                        ,lastName = < cfqueryparam value = '#arguments.structForm["lastName"]#' cfsqltype = "cf_sql_varchar" >
                        ,gender = < cfqueryparam value = '#arguments.structForm["gender"]#' cfsqltype = "cf_sql_varchar" >
                        ,DOB = < cfqueryparam value = '#arguments.structForm["dateOfBirth"]#' cfsqltype = "cf_sql_date" >
                        ,profileImage = < cfqueryparam value = '#arguments.imageLink#' cfsqltype = "cf_sql_varchar" >
                        ,address = < cfqueryparam value = '#arguments.structForm["address"]#' cfsqltype = "cf_sql_varchar" >
                        ,streetName = < cfqueryparam value = '#arguments.structForm["streetName"]#' cfsqltype = "cf_sql_varchar" >
                        ,district = < cfqueryparam value = '#arguments.structForm["district"]#' cfsqltype = "cf_sql_varchar" >
                        ,STATE = < cfqueryparam value = '#arguments.structForm["state"]#' cfsqltype = "cf_sql_varchar" >
                        ,country = < cfqueryparam value = '#arguments.structForm["country"]#' cfsqltype = "cf_sql_varchar" >
                        ,pincode = < cfqueryparam value = '#arguments.structForm["pincode"]#' cfsqltype = "cf_sql_varchar" >
                        ,emailId = < cfqueryparam value = '#arguments.structForm["email"]#' cfsqltype = "cf_sql_varchar" >
                        ,phoneNumber = < cfqueryparam value = '#arguments.structForm["phoneNumber"]#' cfsqltype = "cf_sql_varchar" >
                        ,_updatedBy = < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_varchar" >
                        ,_updatedOn = < cfqueryparam value = '#local.updateDate#' cfsqltype = "cf_sql_date" >
                    WHERE contactId = < cfqueryparam value = '#arguments.structForm["editContact"]#' cfsqltype = "cf_sql_varchar" >;
                </cfquery>

                <!--- Deleting old image if new one is added --->
                <cfif getDeleteImage.profileImage NEQ arguments.imageLink>
                    <cfset local.absolutePath = expandPath("../#getDeleteImage.profileImage#")>
                    <cfif FileExists(local.absolutePath)>
                        <cffile  action = "delete" file = "#local.absolutePath#">
                    </cfif>
                </cfif>

            <cfcatch type="any">
                <cfset local.structResult["Error"] = "Error occured while updating">
            </cfcatch>
            </cftry>
        </cfif>

        <cfreturn local.structResult>
    </cffunction>

<!---     Contact list for home page --->
    <cffunction  name = "getAllContacts" returntype = "query">

        <cfquery name = "allContacts">
            SELECT contactId
                ,firstName
                ,lastName
                ,profileImage
                ,emailId
                ,phoneNumber
            FROM contactDetails
            WHERE _createdBy = < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_varchar" >;
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
            WHERE contactId = < cfqueryparam value = '#arguments.deleteId#' cfsqltype = "cf_sql_varchar" >;
        </cfquery>

        <cfquery>
            DELETE
            FROM contactDetails
            WHERE contactId = < cfqueryparam value = '#arguments.deleteId#' cfsqltype = "cf_sql_varchar" >;
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

        <cfquery name = "qryViewContactDetails">
            SELECT title
                ,firstName
                ,lastName
                ,gender
                ,DOB
                ,profileImage
                ,address
                ,streetName
                ,district
                ,STATE
                ,country
                ,pincode
                ,emailId
                ,phoneNumber
            FROM contactDetails
            WHERE contactId = < cfqueryparam value = '#arguments.viewId#' cfsqltype = "cf_sql_varchar" >;
        </cfquery>

        <cfset local.structResult["Name"] = qryViewContactDetails.title & " " & qryViewContactDetails.firstName & " " & qryViewContactDetails.lastName> 
        <cfset local.structResult["Gender"] = qryViewContactDetails.gender>
        <cfset local.structResult["Date Of Birth"] = dateFormat(qryViewContactDetails.DOB,"dd-mm-yyyy")>
        <cfset local.structResult["profileImage"] = qryViewContactDetails.profileImage>
        <cfset local.structResult["Address"] = qryViewContactDetails.address & ", " & qryViewContactDetails.streetName & ", " & qryViewContactDetails.district & ", " & qryViewContactDetails.state & ", " &qryViewContactDetails.country>
        <cfset local.structResult["Pincode"] = qryViewContactDetails.pincode>
        <cfset local.structResult["Email Id"] = qryViewContactDetails.emailId>
        <cfset local.structResult["Phone Number"] = qryViewContactDetails.phoneNumber>

        <cfreturn local.structResult>
    </cffunction>

<!---     single contact detail to ajax for edit modal --->
    <cffunction  name="getEditData" access="remote" returnformat="JSON">
        <cfargument  name="editId" type="string">

        <cfset local.structResult = structNew("ordered")>

        <cfquery name = "qryEditData">
            SELECT title
                ,firstName
                ,lastName
                ,gender
                ,DOB
                ,profileImage
                ,address
                ,streetName
                ,district
                ,STATE
                ,country
                ,pincode
                ,emailId
                ,phoneNumber
            FROM contactDetails
            WHERE contactId = < cfqueryparam value = '#arguments.editId#' cfsqltype = "cf_sql_varchar" >;
        </cfquery>

        <cfset local.structResult["title"] = qryEditData.title> 
        <cfset local.structResult["firstName"] = qryEditData.firstName> 
        <cfset local.structResult["lastName"] = qryEditData.lastName> 
        <cfset local.structResult["gender"] = qryEditData.gender>
        <cfset local.structResult["dateOfBirth"] = dateFormat(qryEditData.DOB,"yyyy-mm-dd")>
        <cfset local.structResult["profileImage"] = qryEditData.profileImage>
        <cfset local.structResult["address"] = qryEditData.address>
        <cfset local.structResult["streetName"] = qryEditData.streetName>
        <cfset local.structResult["pincode"] = qryEditData.pincode>
        <cfset local.structResult["district"] = qryEditData.district>
        <cfset local.structResult["state"] = qryEditData.state>
        <cfset local.structResult["country"] = qryEditData.country>
        <cfset local.structResult["email"] = qryEditData.emailId>
        <cfset local.structResult["phoneNumber"] = qryEditData.phoneNumber>

        <cfreturn local.structResult>
    </cffunction>

<!---     Creating spreadsheet with user defiined name --->
    <cffunction  name="createSpreadsheet" access="remote" returnformat="json">

        <cfset local.structResult = structNew()>

        <cfquery name = "xlsData">
            SELECT firstName
                ,lastName
                ,gender
                ,DOB
                ,address
                ,streetName
                ,district
                ,STATE
                ,country
                ,pincode
                ,emailId
                ,phoneNumber
            FROM contactDetails
            WHERE _createdBy = < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_varchar" >;
        </cfquery>

        <cfset local.folderName = "../Assets/spreadsheetFiles/">
        <cfif NOT directoryExists(expandPath(local.folderName))>
            <cfset directoryCreate(expandPath(local.folderName))>
        </cfif>

        <cfset local.filename = "contacts.xls">
        <cfset local.filePath = local.folderName  & local.filename>
        <cfset local.sheet = spreadsheetNew("name")>

        <cfset spreadsheetAddRow(local.sheet,'First Name,
                                            Last Name,
                                            Gender,
                                            DOB,
                                            Address,
                                            Street Name,
                                            Pincode,
                                            District,
                                            State,
                                            Country,
                                            Email ID,
                                            Phone Number')>
        <cfset spreadsheetFormatRow(local.sheet, {bold=true}, 1)>
        <cfset spreadsheetAddRows(local.sheet, xlsData)>

        <cfspreadsheet  action="write"  
                        filename="#expandpath(local.filePath)#" 
                        name="local.sheet"
                        overwrite="true">
        <cfset local.structResult["spreadsheetUrl"] = "Assets/spreadsheetFiles/" & local.filename>
        <cfset local.structResult["spreadsheetName"] = local.filename>

    <cfreturn local.structResult>

    </cffunction>

<!---     Checking esistence of email and phonenumber before create or add contact --->
    <cffunction  name="checkEmailAndNumberExist" returnformat="JSON" access="remote">
        <cfargument  name="email" type="string" default="">
        <cfargument  name="phoneNumber" type="string" default="">
        <cfargument  name="contactId" type="string" default="">

        <cfset local.structResult = structNew()>

        <cfquery name="qryEmailOfUser" >
            SELECT email
            FROM userTable
            WHERE userId = < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_varchar" >;
        </cfquery>

        <cfquery name="qryEmailInContacts" >
            SELECT emailId
                ,contactId
            FROM contactDetails
            WHERE _createdBy = < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_varchar" >;
        </cfquery>

        <cfquery name="qryNumberInContacts" >
            SELECT phoneNumber
                ,contactId
            FROM contactDetails
            WHERE _createdBy = < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_varchar" >;
        </cfquery>

        <!---         Check email --->
        <cfif qryEmailOfUser.email EQ arguments.email>
            <cfset local.structResult["emailError"] = "You cant use your own email">
        </cfif>

        <cfloop query="qryEmailInContacts">
            <cfif qryEmailInContacts.emailId EQ arguments.email AND qryEmailInContacts.contactId NEQ arguments.contactId>
                <cfset local.structResult["emailError"] = "Email already exists for another contact">
            </cfif>
        </cfloop>

        <cfif NOT structKeyExists(local.structResult, "emailError")>
            <cfset local.structResult["emailSuccess"] = "true">
        </cfif>

        <!---         Check phone number --->
        <cfloop query="qryNumberInContacts">
            <cfif qryNumberInContacts.phoneNumber EQ arguments.phoneNumber AND qryNumberInContacts.contactId NEQ arguments.contactId>
                <cfset local.structResult["phoneError"] = "Phone number already exists for another contact">
            </cfif>
        </cfloop>

        <cfif NOT structKeyExists(local.structResult, "phoneError")>
            <cfset local.structResult["phoneSuccess"] = "true">
        </cfif>

        <cfreturn local.structResult>
    </cffunction>

    <cffunction  name="getPdfData">
        <cfargument  name="inputFileName" type="string">

        <cfset local.structResult = structNew()>

        <cfquery name = "qryPdfData">
            SELECT firstName
                ,lastName
                ,gender
                ,DOB
                ,profileImage
                ,address
                ,streetName
                ,district
                ,STATE
                ,country
                ,pincode
                ,emailId
                ,phoneNumber
            FROM contactDetails
            WHERE _createdBy = < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_varchar" >;
        </cfquery>

        <cfreturn qryPdfData>
    </cffunction>

    <cffunction  name="createPdf"  access="remote" returnformat="json">
        <cfset local.structResult = structNew()>

        <cfinclude  template="../printDocument.cfm">
        <cfset local.structResult["pdfUrl"] = "#local.folderName##local.filename#">
        <cfset local.structResult["pdfName"] = "#local.filename#">

        <cfreturn local.structResult> 
    </cffunction>

    <cffunction  name="ssoLogin" returntype = "void">
        <cfargument  name="oauthResult">
        <cfset local.emailCheck=emailAndUNameCheck(arguments.oauthResult.other.email)>
        <cfif structKeyExists(local.emailCheck, "emailSuccess")>
            <!--- signup --->
            <cfset userSignup(  arguments.oauthResult.name,
                                arguments.oauthResult.other.email,
                                arguments.oauthResult.id,
                                "",
                                arguments.oauthResult.other.picture)>
        <cfelse>
            <!--- login --->
            <cfquery name = "selectUser" >
                SELECT userId
                FROM userTable
                WHERE email = < cfqueryparam value = '#arguments.oauthResult.other.email#' cfsqltype = "cf_sql_varchar" >;
            </cfquery>
            
            <cfif selectUser.recordcount>
                <cfset session.userId = selectUser.userId>
                <cfset local.structResult["success"] = "success">
                <cflocation  url="./home.cfm"  addtoken = "no">
            <cfelse>
                <cflocation  url="./login.cfm?error=Error-occured" addtoken = "no">
            </cfif>
        </cfif>
    </cffunction>

    <cffunction  name="birthday">
        <cfmail
            from = "abhijithtechversant@gmail.com"
            to = "abhijithtechversant@gmail.com"
            subject = "Birthday wishes"
            type = "text">
                sss
        </cfmail>
    </cffunction>

    <cffunction  name = "setBirthdaySchedule" returnType = "string">
        <cfschedule 
            action="update" 
            task="birthdayTask" 
            operation="HTTPRequest" 
            url="http://addressbook.org/birthdayMail.cfm"
            startDate="#DateFormat(Now(), 'YYYY-MM-dd')#" 
            interval ="daily"
            repeat = "0"
            overwrite="true">

    </cffunction>

    <cffunction  name="resumeBirthDaySchedule" returnType = "string">
        <cfschedule 
            action="resume" 
            task="birthdayTask" 
            overwrite="true">
    </cffunction>

    <cffunction  name="pauseBirthDaySchedule" returnType = "string">
        <cfschedule 
            action="pause" 
            task="birthdayTask" 
            overwrite="true">
    </cffunction>

    <cffunction  name="getBDayData" returntype = "void">
        <cfquery name = "qryBDayData">
            SELECT firstname
                ,emailId
                ,DOB
            FROM contactDetails;
        </cfquery>
         <cfloop query="qryBDayData"> 
             <cfif dateFormat(qryBDayData.DOB,"dd-mm") EQ dateFormat(now(),"dd-mm")> 
                <cfmail
                    from = "abhijithtechversant@gmail.com"
                    to = "#qryBDayData.emailId#"
                    subject = "Birthday wishes #qryBDayData.firstname#"
                    type = "text">
                        Happy birthday #qryBDayData.firstname#
                        <cfmailparam file = "./Assets/images/birthday-poster.jpg" disposition="attachment">
                </cfmail>
             </cfif>
        </cfloop>
    </cffunction>
</cfcomponent>