<cfcomponent>
<!---     Get details of all contacts created by a user --->
    <cffunction  name="getAllContactDetails" returntype = "query">
        <cfargument name = "contactId" default = "">

        <cfif arguments.contactId EQ "">
            <cfset local.whereCondition = "cd._createdBy">
            <cfset local.whereValue = session.userId>
        <cfelse>
            <cfset local.whereCondition = "cd.contactId">
            <cfset local.whereValue = arguments.contactId>
        </cfif>

        <cfquery name = "local.qryContactDetails">
             SELECT 
                cd.contactId,
                cd.title,
                cd.firstName,
                cd.lastName,
                cd.gender,
                cd.DOB,
                cd.profileImage,
                cd.address,
                cd.streetName,
                cd.district,
                cd.STATE,
                cd.country,
                cd.pincode,
                cd.emailId,
                cd.phoneNumber,
                STRING_AGG(cr.roleId, ',') AS roleIds,
                STRING_AGG(r.name, ',') AS roleNames
            FROM 
                contactDetails AS cd
                LEFT JOIN contactRoles AS cr ON cd.contactId = cr.contactId
                LEFT JOIN roles AS r ON r.roleId = cr.roleId
            WHERE 
                #local.whereCondition# = <cfqueryparam value = '#local.whereValue#' cfsqltype = "cf_sql_INTEGER">
                AND cd.active = <cfqueryparam value = 1 cfsqltype = "cf_sql_integer">
                GROUP BY 
                    cd.contactId,
                    cd.title,
                    cd.firstName,
                    cd.lastName,
                    cd.gender,
                    cd.DOB,
                    cd.profileImage,
                    cd.address,
                    cd.streetName,
                    cd.district,
                    cd.STATE,
                    cd.country,
                    cd.pincode,
                    cd.emailId,
                    cd.phoneNumber;
        </cfquery>

        <cfreturn local.qryContactDetails>
    </cffunction>

<!---     Get roles of specific user --->
    <cffunction  name="getContactRoles" returnType = "query">
        <cfargument  name="contactId">
        
        <cfquery name="local.qryRoles">
            SELECT 
                cr.roleid,
                r.name
            FROM 
                contactRoles AS cr
                LEFT JOIN roles AS r ON cr.roleId = r.roleId
            WHERE 
                contactId = <cfqueryparam value = '#arguments.contactId#' cfsqltype = "CF_SQL_BIGINT">;
        </cfquery>
        
        <cfreturn local.qryRoles>
    </cffunction>

<!---     Get all roles for from role table --->
    <cffunction  name="getAllRoles" returntype="query">
        <cfquery name = "local.contactRoles">
            SELECT 
                roleId,
                name
            FROM 
                roles;
        </cfquery>
        <cfreturn local.contactRoles>
    </cffunction>

<!---     Checker email or username already exists during signup --->
    <cffunction  name="emailAndUNameCheck" returnformat="JSON" access="remote">
        <cfargument  name = "email" type = "string"> 
        <cfargument  name = "userName" type="string" default="" required = "false"> 

        <cfset local.structResult = structNew()>

        <cfif arguments.email NEQ "">

            <cfquery name="local.qryEmailExist" >
                SELECT 
                    count('email') AS emailCount
                FROM 
                    userTable
                WHERE 
                    email = <cfqueryparam value = '#arguments.email#' cfsqltype = "cf_sql_varchar">;
            </cfquery>

            <cfif local.qryEmailExist.emailCount>
                <cfset local.structResult["emailError"] = "Email already exists">
            <cfelse>
                <cfset local.structResult["emailSuccess"] = "true">
            </cfif>

        </cfif>

        <cfif arguments.userName NEQ "">

            <cfquery name="local.qryUserNameExist" >
                SELECT 
                    count('userName') AS userNameCount
                FROM 
                    userTable
                WHERE 
                    username = <cfqueryparam value = '#arguments.userName#' cfsqltype = "cf_sql_varchar">;
            </cfquery>

            <cfif local.qryUserNameExist.userNameCount>
                <cfset local.structResult["userNameError"] = "UserName already exists">
            <cfelse>
                <cfset local.structResult["userNameSuccess"] = "true">
            </cfif>
        </cfif>

        <cfreturn local.structResult>
    </cffunction>
    
<!---     User login --->
    <cffunction  name="userLogin" returntype="struct">
        <cfargument  name="emailId" type="string">
        <cfargument  name="password" type="string">

        <cfset local.structResult = structNew()>
        <cfset local.hashedPassword = hash(arguments.password, "SHA-256")> 

        <cfquery name = "local.selectUser" >
            SELECT 
                userId,
                fullName
            FROM 
                userTable
            WHERE
                email = <cfqueryparam value = '#arguments.emailId#' cfsqltype = "cf_sql_varchar">
                AND password = <cfqueryparam value = '#local.hashedPassword#' cfsqltype = "cf_sql_varchar">;
        </cfquery>
        
        <cfif local.selectUser.recordcount>
            <cfset session.userId = local.selectUser.userId>
            <cfset session.userName = local.selectUser.fullName>
            <cfset local.structResult["success"] = "success">
            <cflocation  url="./home.cfm"> 
        <cfelse>
            <cfset local.structResult["error"] = "Please enter a valid email and password">
        </cfif>

        <cfreturn local.structResult>
    </cffunction>

<!---     User details for homepage --->
    <cffunction  name="userDetails">

        <cfquery name = "local.getUserDetails" >
            SELECT  
                fullName,
                profileImage,
                email
            FROM
                userTable
            WHERE 
                userId = <cfqueryparam value = '#session.userId#' cfsqltype = " CF_SQL_BIGINT">;
        </cfquery>

        <cfreturn local.getUserDetails>
    </cffunction>

<!---    logout --->
    <cffunction  name="logOut"  access="remote">

        <cfset structClear(session)>

        <cfreturn true>
    </cffunction>

<!---     Creating contact --->
    <cffunction  name="addContact" returntype="struct">
        <cfargument  name="structForm" type="struct">
        <cfset local.structResult = structNew()>
        <cfset local.createDate = dateformat(now(),"yyyy-mm-dd")>
        <cfset local.checkEmailResult = checkEmailExist(arguments.structForm["email"])>

        <cfset local.uploadDirectory = "./Assets/contactPictues/">
        <cfif structKeyExists(arguments.structForm, "profileImage") && len(arguments.structForm.profileImage)>
            <cffile action="upload"
            filefield="profileImage"
            destination="#expandPath(local.uploadDirectory)#"
            nameconflict="makeunique"
            result="fileDetails">
            <cfset local.imageSrc = local.uploadDirectory & fileDetails.serverfile>
        <cfelse>
            <cfset local.imageSrc = "">
        </cfif>

        <cfif structKeyExists(local.checkEmailResult, "phoneError") OR structKeyExists(local.checkEmailResult, "emailError")>
            <cfset local.structResult["error"] = "Error email or phone already exists">
        <cfelse>
            <cftry>
                <cfquery result = "local.insertResult">
                    INSERT INTO 
                        contactDetails (
                            title,
                            firstName,
                            lastName,
                            gender,
                            DOB,
                            profileImage,
                            address,
                            streetName,
                            district,
                            State,
                            country,
                            pincode,
                            emailId,
                            phoneNumber,
                            _createdBy,
                            _createdOn
                        )
                    VALUES (
                        <cfqueryparam value = '#arguments.structForm["title"]#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#arguments.structForm["firstName"]#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#arguments.structForm["lastName"]#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#arguments.structForm["gender"]#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#arguments.structForm["dateOfBirth"]#' cfsqltype = "cf_sql_date">,
                        <cfqueryparam value = '#local.imageSrc#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#arguments.structForm["address"]#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#arguments.structForm["streetName"]#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#arguments.structForm["district"]#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#arguments.structForm["state"]#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#arguments.structForm["country"]#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#arguments.structForm["pincode"]#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#arguments.structForm["email"]#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#arguments.structForm["phoneNumber"]#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#session.userId#' cfsqltype = " CF_SQL_BIGINT">,
                        <cfqueryparam value = '#local.createDate#' cfsqltype = "cf_sql_date">
                        );
                </cfquery>
            <cfcatch type="any">
                <cfset local.structResult["error"] = "Error while creating the contact">
            </cfcatch>
            </cftry>
            <cftry>
                <cfloop list="#arguments.structForm["role"]#" item="local.roleItem" delimiters = ",">
                    <cfquery>
                        INSERT INTO 
                            contactRoles(
                                roleId,
                                contactId
                        )
                        values(
                            <cfqueryparam value = '#local.roleItem#' cfsqltype = "CF_SQL_INTEGER">,
                            <cfqueryparam value = '#local.insertResult.generatedkey#' cfsqltype = "CF_SQL_INTEGER">
                        )
                        
                    </cfquery>
                </cfloop>
            <cfcatch type="any">
                <cfset local.structResult["error"] = "Error while inserting roles">
            </cfcatch>
            </cftry>
        </cfif>

        <cfreturn local.structResult>
    </cffunction>

<!---     Edit contact details --->
    <cffunction  name="editContact" returntype="struct">
        <cfargument  name="structForm" type="struct">

        <cfset local.uploadDirectory = "./Assets/contactPictues/">
        <cfset local.roleArray = listToArray(arguments.structForm["role"],",")>

        <cfif structKeyExists(arguments.structForm, "profileImage") && len(arguments.structForm.profileImage)>
            <cffile action="upload"
                    filefield="profileImage"
                    destination="#expandPath(local.uploadDirectory)#"
                    nameconflict="makeunique"
                    result="fileDetails">
            <cfset local.imageSrc = local.uploadDirectory & fileDetails.serverfile>
        <cfelseif structKeyExists(arguments.structForm,"profileDefault")>
            <cfset local.imageSrc = arguments.structForm.profileDefault>
        <cfelse>
            <cfset local.imageSrc = "">
        </cfif>

        <cfset local.currentRoles = getContactRoles(arguments.structForm["editContactId"])>
        <cfset local.structResult = structNew()>
        <cfset local.updateDate = dateformat(now(),"yyyy-mm-dd")>
        <cfset local.checkEmailResult = checkEmailExist(arguments.structForm["email"],
                                                        arguments.structForm["editContactId"]
                                                        )>

        <cfif structKeyExists(local.checkEmailResult, "phoneError") 
            OR structKeyExists(local.checkEmailResult, "emailError")>
            <cfset local.structResult["error"] = "Error email or phone already exists">
        <cfelse>
            <cftry>
                <cfquery>
                    UPDATE 
                        contactDetails
                    SET 
                        title = <cfqueryparam value = '#arguments.structForm["title"]#' cfsqltype = "cf_sql_varchar">,
                        firstName = <cfqueryparam value = '#arguments.structForm["firstName"]#' cfsqltype = "cf_sql_varchar">,
                        lastName = <cfqueryparam value = '#arguments.structForm["lastName"]#' cfsqltype = "cf_sql_varchar">,
                        gender = <cfqueryparam value = '#arguments.structForm["gender"]#' cfsqltype = "cf_sql_varchar">,
                        DOB = <cfqueryparam value = '#arguments.structForm["dateOfBirth"]#' cfsqltype = "cf_sql_date">,
                        profileImage = <cfqueryparam value = '#local.imageSrc#' cfsqltype = "cf_sql_varchar">,
                        address = <cfqueryparam value = '#arguments.structForm["address"]#' cfsqltype = "cf_sql_varchar">,
                        streetName = <cfqueryparam value = '#arguments.structForm["streetName"]#' cfsqltype = "cf_sql_varchar">,
                        district = <cfqueryparam value = '#arguments.structForm["district"]#' cfsqltype = "cf_sql_varchar">,
                        state = <cfqueryparam value = '#arguments.structForm["state"]#' cfsqltype = "cf_sql_varchar">,
                        country = <cfqueryparam value = '#arguments.structForm["country"]#' cfsqltype = "cf_sql_varchar">,
                        pincode = <cfqueryparam value = '#arguments.structForm["pincode"]#' cfsqltype = "cf_sql_varchar">,
                        emailId = <cfqueryparam value = '#arguments.structForm["email"]#' cfsqltype = "cf_sql_varchar">,
                        phoneNumber = <cfqueryparam value = '#arguments.structForm["phoneNumber"]#' cfsqltype = "cf_sql_varchar">,
                        _updatedBy = <cfqueryparam value = '#session.userId#' cfsqltype = " CF_SQL_BIGINT">,
                        _updatedOn = <cfqueryparam value = '#local.updateDate#' cfsqltype = "cf_sql_date">
                    WHERE
                        contactId = <cfqueryparam value = '#arguments.structForm["editContactId"]#' cfsqltype = "CF_SQL_BIGINT">
                        AND _createdby = <cfqueryparam value = '#session.userId#' cfsqltype = "CF_SQL_BIGINT">;
                </cfquery>
                <cfloop query="local.currentRoles">
                    <cfif arrayContains(local.roleArray, local.currentRoles.roleId)>
                        <cfset arrayDelete(local.roleArray, local.currentRoles.roleId)>
                    <cfelse>
                        <cfquery>
                            DELETE 
                            FROM 
                                contactRoles
                            WHERE 
                                contactId = <cfqueryparam value = '#arguments.structForm["editContactId"]#' cfsqltype = "CF_SQL_BIGINT">
                                AND roleId = <cfqueryparam value = '#local.currentRoles.roleId#' cfsqltype = "cf_sql_INTEGER">;
                        </cfquery>
                    </cfif>
                </cfloop>

                <cfloop array="#local.roleArray#" item="local.newRole">
                    <cfquery>
                        INSERT INTO 
                            contactRoles(
                                roleId,
                                contactId
                            )
                        values(
                            <cfqueryparam value = '#local.newRole#' cfsqltype = "CF_SQL_INTEGER">,
                            <cfqueryparam value = '#arguments.structForm["editContactId"]#' cfsqltype = "CF_SQL_BIGINT">
                        )
                        
                    </cfquery>
                </cfloop>

                <cfcatch type="any">
                    <cfset local.structResult["Error"] = "Error occured while updating">
                </cfcatch>
            </cftry>
        </cfif>

        <cfreturn local.structResult>
    </cffunction>

<!---     Delete contact from table --->
    <cffunction  name="deleteContact" access="remote" returnformat = "plain">
        <cfargument  name="deleteId" type="string">

        <cfquery>
            UPDATE 
                contactDetails
            SET 
                active = <cfqueryparam value = 0 cfsqltype = "cf_sql_integer">,
                deletedBy = <cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_integer">,
                deletedOn = <cfqueryparam value = '#dateformat(now(),"yyyy-mm-dd")#' cfsqltype = " cf_sql_date">
            WHERE
                 contactId = <cfqueryparam value = '#arguments.deleteId#' cfsqltype = "cf_sql_integer">;
        </cfquery>

        <cfreturn true>
    </cffunction>

<!---     single contact detail to ajax call for view modal--->
    <cffunction  name="getViewData" access="remote" returnformat="JSON">
        <cfargument  name="viewId" type="string">

        <cfset local.contactDetail = getAllContactDetails(arguments.viewId)>
        <cfset local.structResult = structNew("ordered")>

        <cfset local.structResult["Name"] = local.contactDetail.title & " " & local.contactDetail.firstName & " " & local.contactDetail.lastName> 
        <cfset local.structResult["Gender"] = local.contactDetail.gender>
        <cfset local.structResult["Date Of Birth"] = dateFormat(local.contactDetail.DOB,"dd-mm-yyyy")>
        <cfset local.structResult["profileImage"] = local.contactDetail.profileImage>
        <cfset local.structResult["Address"] = local.contactDetail.address & ", " & local.contactDetail.streetName & ", " & local.contactDetail.district & ", " & local.contactDetail.state & ", " &local.contactDetail.country>
        <cfset local.structResult["Pincode"] = local.contactDetail.pincode>
        <cfset local.structResult["Roles"] = local.contactDetail.roleNames>
        <cfset local.structResult["Email Id"] = local.contactDetail.emailId>
        <cfset local.structResult["Phone Number"] = local.contactDetail.phoneNumber>

        <cfreturn local.structResult>
    </cffunction>

<!---     single contact detail to ajax for edit modal --->
    <cffunction  name="getEditData" access="remote" returnformat="JSON">
        <cfargument  name="editId" type="string">

        <cfset local.contactDetail = getAllContactDetails(arguments.editId)>
        <cfset local.qryContactRole = getContactRoles(arguments.editId)>
        <cfset local.structResult = structNew("ordered")>

        <cfset local.structResult["title"] = local.contactDetail.title> 
        <cfset local.structResult["firstName"] = local.contactDetail.firstName> 
        <cfset local.structResult["lastName"] = local.contactDetail.lastName> 
        <cfset local.structResult["gender"] = local.contactDetail.gender>
        <cfset local.structResult["dateOfBirth"] = dateFormat(local.contactDetail.DOB,"yyyy-mm-dd")>
        <cfset local.structResult["profileImage"] = local.contactDetail.profileImage>
        <cfset local.structResult["address"] = local.contactDetail.address>
        <cfset local.structResult["streetName"] = local.contactDetail.streetName>
        <cfset local.structResult["pincode"] = local.contactDetail.pincode>
        <cfset local.structResult["district"] = local.contactDetail.district>
        <cfset local.structResult["state"] = local.contactDetail.state>
        <cfset local.structResult["country"] = local.contactDetail.country>
        <cfset local.structResult["email"] = local.contactDetail.emailId>
        <cfset local.structResult["phoneNumber"] = local.contactDetail.phoneNumber>
        <cfset local.structResult["role"] = local.contactDetail.roleIds>

        <cfreturn local.structResult>
    </cffunction>

<!---     Creating spreadsheet with user defiined name --->
    <cffunction  name="createSpreadsheet" access="remote" returnformat="json">
        <cfargument  name="contactData" required = "false">

        <cfset local.xlsData = getAllContactDetails()>
        <cfset local.structResult = structNew()>
        <cfset local.folderName = "../Assets/spreadsheetFiles/">
        <cfset local.filename = session.userName & "_" & dateTimeFormat(now(),"dd-mm-yyy-HH-nn-ss") & ".xls">

        <cfif NOT directoryExists(expandPath(local.folderName))>
            <cfset directoryCreate(expandPath(local.folderName))>
        </cfif>
        <cfset QueryDeleteColumn(local.xlsData,"contactId")>
        <cfset QueryDeleteColumn(local.xlsData,"profileImage")>
        <cfset QueryDeleteColumn(local.xlsData,"roleIds")>

        <cfset local.filePath = local.folderName  & local.filename>
        <cfset local.sheet = spreadsheetNew("name")>

        <cfset spreadsheetAddRow(local.sheet,'Title,First Name,Last Name,Gender,DOB,Address,Street Name,District,State,Country,Pincode,Email ID,Phone Number,Role')>
        <cfset spreadsheetFormatRow(local.sheet, {bold=true}, 1)>

        <cfif arguments.contactData>
            <cfset spreadsheetAddRows(local.sheet, local.xlsData)>
        </cfif>

        <cfspreadsheet  action="write"  
                        filename="#expandpath(local.filePath)#" 
                        name="local.sheet"
                        overwrite="true">
        <cfset local.structResult["spreadsheetUrl"] = "Assets/spreadsheetFiles/" & local.filename>
        <cfset local.structResult["spreadsheetName"] = local.filename>

        <cfreturn local.structResult>

    </cffunction>

<!---     Checking esistence of email before create or add contact --->
    <cffunction name="checkEmailExist" returnformat="JSON" access="remote">
        <cfargument name="email" type="string" default="">
        <cfargument name="contactId" type="string" default="">

        <cfset local.structResult = structNew()>

        <cfquery name="local.qryEmailOfUser" >
            SELECT
                email
            FROM 
                userTable
            WHERE 
                userId = <cfqueryparam value = '#session.userId#' cfsqltype = " CF_SQL_BIGINT">;
        </cfquery>

        <cfquery name="local.qryEmailInContacts" >
            SELECT 
                emailId,
                contactId
            FROM 
                contactDetails
            WHERE 
                _createdBy = <cfqueryparam value = '#session.userId#' cfsqltype = " CF_SQL_BIGINT">
                AND active = <cfqueryparam value = 1 cfsqltype = "cf_sql_integer" >;
        </cfquery>

        <!---         Check email --->
        <cfif local.qryEmailOfUser.email EQ arguments.email>
            <cfset local.structResult["emailError"] = "You cant use your own email">
        </cfif>

        <cfloop query="local.qryEmailInContacts">
            <cfif local.qryEmailInContacts.emailId EQ arguments.email 
                AND local.qryEmailInContacts.contactId NEQ arguments.contactId>
                <cfset local.structResult["emailError"] = "Email already exists for another contact">
            </cfif>
        </cfloop>

        <cfif NOT structKeyExists(local.structResult, "emailError")>
            <cfset local.structResult["emailSuccess"] = "true">
        </cfif>

        <cfreturn local.structResult>
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
        <cfset local.local.emailCheck=emailAndUNameCheck(arguments.oauthResult.other.email)>
        <cfif structKeyExists(local.local.emailCheck, "emailSuccess")>
            <!--- signup --->
            <cfset userSignup(  arguments.oauthResult.name,
                                arguments.oauthResult.other.email,
                                arguments.oauthResult.id,
                                "",
                                arguments.oauthResult.other.picture)>
        <cfelse>
            <!--- login --->
            <cfquery name = "local.selectUser" >
                SELECT 
                    userId,
                    fullName
                FROM
                    userTable
                WHERE 
                    email = <cfqueryparam value = '#arguments.oauthResult.other.email#' cfsqltype = "cf_sql_varchar">;
            </cfquery>
            
            <cfif local.selectUser.recordcount>
                <cfset session.userId = local.selectUser.userId>
                <cfset session.userName = local.selectUser.fullName>
                <cfset local.structResult["success"] = "success">
                <cflocation  url="./home.cfm"  addtoken = "no">
            <cfelse>
                <cflocation  url="./login.cfm?error=Error-occured" addtoken = "no">
            </cfif>
        </cfif>
    </cffunction>

    <cffunction  name="resumeBirthDaySchedule" returnType = "string">
        <cfargument  name="taskName">
        <cfschedule 
            action="resume" 
            task="#arguments.taskName#" 
            overwrite="true">
    </cffunction>

    <cffunction  name="pauseBirthDaySchedule" returnType = "string">
        <cfargument  name="taskName">
        <cfschedule 
            action="pause" 
            task="#arguments.taskName#"
            overwrite="true">
    </cffunction>

    <cffunction  name="getBDayData" returntype = "void">
        <cfargument  name="senderEmail" type="string">

        <cfquery name = "local.getUserId" >
            SELECT
                userId
            FROM
                userTable
            WHERE
                email = <cfqueryparam value = '#arguments.senderEmail#' cfsqltype = "cf_sql_varchar">;
        </cfquery>
        
        <cfquery name = "local.qryBDayData">
            SELECT  
                contactDetails.firstname,
                contactDetails.emailId,
                contactDetails.DOB
            FROM
                userTable
                INNER JOIN contactDetails ON userTable.userId = contactDetails._createdBy
            WHERE
                userTable.email =  <cfqueryparam value = '#arguments.senderEmail#' cfsqltype = "cf_sql_varchar">;
        </cfquery>

         <cfloop query="local.qryBDayData"> 
             <cfif dateFormat(local.qryBDayData.DOB,"dd-mm") EQ dateFormat(now(),"dd-mm")> 
                <cfmail
                    from = "abhijithtechversant@gmail.com"
                    to = "#local.qryBDayData.emailId#"
                    subject = "Birthday wishes #local.qryBDayData.firstname#"
                    type = "text">
                        Happy birthday #local.qryBDayData.firstname#
                        <cfmailparam file = "./Assets/images/birthday-poster.jpg" disposition="attachment">
                </cfmail>
             </cfif>
        </cfloop>

    </cffunction>

    <cffunction  name="getScheduleStatus" returntype = "any">
        <cfargument  name="taskName">
        <cfset local.statusStruct = structNew()>
        <cfschedule  action="list"  result = "local.result">
        <cfloop query="#local.result#">
            <cfif local.result.task EQ arguments.taskName>
                <cfset local.statusStruct["status"] = local.result.status>
            </cfif>
        </cfloop>
        <cfreturn local.statusStruct>
    </cffunction>

    <cffunction  name="userSignup" access="remote" returnformat = "JSON">
        <cfargument  name="fullName">
        <cfargument  name="emailId">
        <cfargument  name="userName">
        <cfargument  name="password">
        <cfargument  name="profileImage">

        <cfset local.uploadDirectory = "../Assets/uploads/">
        <cfif NOT directoryExists(expandPath(local.uploadDirectory))>
            <cfset directoryCreate(expandPath(local.uploadDirectory))>
        </cfif>
        <cfset local.structResult = structNew()>
        <cfset local.hashedPassword = hash(arguments.password, "SHA-256")> 

        <cfset local.emailCheck = emailAndUNameCheck(arguments.emailId,
                                            arguments.userName)>
        
        <cfset local.structResult = local.emailCheck>
        <cfif structKeyExists(local.emailCheck, "userNameSuccess") AND structKeyExists(local.emailCheck, "emailSuccess")>
            <cftry>
                <cffile action="upload"
                    destination="#expandPath(local.uploadDirectory)#"
                    nameconflict="makeunique"
                    result="local.fileDetails">

                <cfset local.profilelocal.ImageSrc = local.uploadDirectory & local.fileDetails.serverfile>

                <cfquery name="userInsert" result = "local.signupResult">
                    INSERT INTO 
                        userTable (
                            fullName,
                            email,
                            userName,
                            password,
                            profileImage
                        )
                    VALUES (
                        <cfqueryparam value = '#arguments.fullName#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#arguments.emailId#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#arguments.userName#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#local.hashedPassword#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#local.profilelocal.ImageSrc#' cfsqltype = "cf_sql_varchar">
                        );
                </cfquery>

            <cfcatch type="any">
                <cfset local.structResult["error"] = cfcatch.message>
            </cfcatch>

            </cftry>
            <cfif NOT structKeyExists(local.structResult, "error")>

                <cfschedule 
                    action="update" 
                    task="birthdayTask-#arguments.emailId#" 
                    operation="HTTPRequest" 
                    url="http://addressbook.org/birthdayMail.cfm?emailId=#arguments.emailId#"
                    startDate="#DateFormat(Now(), 'YYYY-MM-dd')#" 
                    starttime="00:00"
                    interval ="daily"
                    repeat = "0"
                    overwrite="true">

                <cfset session.userId = local.signupResult.generatedKey>
                <cfset session.userName = arguments.fullName>
            </cfif>
        </cfif>

        
        <cfreturn local.structResult>
    </cffunction>
    
    <cffunction  name="uploadContact" returnFormat = "JSON" access = "remote">
        <cfargument  name="inputFile" required = "True">

        <cfspreadsheet  action="read" 
                        src = "#arguments.inputFile#" 
                        headerrow="1" 
                        excludeHeaderRow = "true" 
                        query = "local.excelValues">

        <cfset local.resultStruct = structNew()>
        <cfset local.resultStruct["errorCount"] = 0>
        <cfset local.resultStruct["createCount"] = 0>
        <cfset local.resultStruct["updateCount"] = 0>
        <cfset local.structContactDetails = structNew()>
        <cfset local.qryExistingRoles = getAllRoles()>
        <cfset local.structExistingRoles = structNew()>

        <cfloop query="local.qryExistingRoles">
            <cfset local.structExistingRoles[local.qryExistingRoles.name] = local.qryExistingRoles.roleId>
        </cfloop>

        <cfquery name = "local.existingEmails">
            SELECT 
                contactId,emailId 
            FROM
                contactDetails
            WHERE 
                active = <cfqueryparam value = '1' cfsqltype = "cf_sql_integer">
                AND _createdBy = <cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_integer">
         </cfquery>

        <cfloop query="local.existingEmails">
            <cfset local.structExistingEmails[local.existingEmails.emailId] = local.existingEmails.contactId>
        </cfloop>

        <cfif structKeyExists(local.excelValues, "Result")>
            <cfset queryDeleteColumn(local.excelValues,"Result")>
        </cfif>
        <cfset local.headingArray = ["Title","First Name","Last Name","Gender","DOB","Address","Street Name","District","State","Country","Pincode","Email ID","Phone Number","Role"]>
        <cfset local.arrayExistingGender = ["Male","Female"]>
        <cfset local.arrayExistingTitle = ["mr","mrs"]>
        <cfset local.emailPattern = "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$">
        <cfset local.datePattern = "^\d{4}/\d{2}/\d{2}$">
        <cfset local.arrayResultColumn = arrayNew(1)>
        <cfset local.errorArray = arrayNew(1)>

        <cfloop query="local.excelValues">
            <cfset local.missingArray = arrayNew(1)>
            <cfset local.errorArray = arrayNew(1)>

            <cfloop array="#local.headingArray#" item="local.headingArrayItem">

                <cfif NOT structKeyExists(local.excelValues, local.headingArrayItem)>
                    <cfset local.resultStruct["error"] = "Missing Column #local.headingArrayItem#">
                    <cfreturn local.resultStruct>
                </cfif>

                <cfif local.excelValues[local.headingArrayItem].toString() EQ "">
                    <cfset arrayAppend(local.missingArray , local.headingArrayItem)>
                <cfelse>
                    <cfif (local.headingArrayItem EQ "Email Id" 
                                AND 
                                reFindNoCase(local.emailPattern, local.excelValues[local.headingArrayItem].toString()) EQ false)
                            OR ((local.headingArrayItem EQ "pincode" 
                                OR 
                                local.headingArrayItem EQ "Phone Number") 
                                AND 
                                isNumeric(local.excelValues[local.headingArrayItem].toString()) EQ false)
                            OR
                               (local.headingArrayItem EQ "pincode" 
                                AND 
                                local.excelValues[local.headingArrayItem].toString().len() NEQ 6)
                            OR
                                (local.headingArrayItem EQ "Phone Number" 
                                AND 
                                local.excelValues[local.headingArrayItem].toString().len() NEQ 10)
                            OR
                                (local.headingArrayItem EQ "Title" 
                                AND  
                                    arrayFindNoCase(local.arrayExistingTitle, 
                                    trim(local.excelValues[local.headingArrayItem].toString())) EQ false)
                            OR
                                (local.headingArrayItem EQ "Gender" 
                                AND 
                                    arrayFindNoCase(local.arrayExistingGender,
                                    trim(local.excelValues[local.headingArrayItem].toString())) EQ false)>
                                    
                        <cfset arrayAppend(local.errorArray, local.headingArrayItem)>

                    <cfelseif   local.headingArrayItem EQ "DOB" 
                                AND  
                                (reFindNoCase(local.datePattern, trim(local.excelValues[local.headingArrayItem].toString())) EQ false
                                OR
                                DateDiff("d", local.excelValues[local.headingArrayItem].toString(), now()) LT 0)>
                        <cfset arrayAppend(local.errorArray, local.headingArrayItem)>

                    <cfelseif local.headingArrayItem EQ "Role">
                        <cfloop list="#local.excelValues["Role"].toString()#" item="local.roleItem" delimiters = ",">
                            <cfif structKeyExists(local.structExistingRoles, trim(local.roleItem)) EQ false>
                                <cfset arrayAppend(local.errorArray, local.headingArrayItem)>
                                <cfbreak>
                            </cfif>
                        </cfloop>

                    </cfif>
                </cfif>
            </cfloop>

            <cfif NOT arrayIsEmpty(local.missingArray)>
                <cfset local.resultStruct["errorCount"] +=1>
                <cfset local.arrayResultColumn[local.excelValues.currentRow] = "Error -  Missing columns - " & arrayToList(local.missingArray,',')>
            <cfelseif NOT arrayIsEmpty(local.errorArray)>
                <cfset local.resultStruct["errorCount"] +=1>
                <cfset local.arrayResultColumn[local.excelValues.currentRow] = "Error values - " & arrayToList(local.errorArray,',')>
            <cfelse>

                <cfset local.roleIds = arrayNew(1)>
                <cfset local.structContactDetails["title"] = trim(local.excelValues["Title"].toString())> 
                <cfset local.structContactDetails["firstName"] = trim(local.excelValues["First Name"].toString())>
                <cfset local.structContactDetails["lastName"] = trim(local.excelValues["Last Name"].toString())>
                <cfset local.structContactDetails["gender"] = trim(local.excelValues["Gender"].toString())>
                <cfset local.structContactDetails["dateOfBirth"] = trim(local.excelValues["DOB"].toString())>
                <cfset local.structContactDetails["address"] = trim(local.excelValues["Address"].toString())>
                <cfset local.structContactDetails["streetName"] = trim(local.excelValues["Street Name"].toString())>
                <cfset local.structContactDetails["pincode"] = trim(local.excelValues["Pincode"].toString())>
                <cfset local.structContactDetails["district"] = trim(local.excelValues["District"].toString())>
                <cfset local.structContactDetails["state"] = trim(local.excelValues["State"].toString())>
                <cfset local.structContactDetails["country"] = trim(local.excelValues["Country"].toString())>
                <cfset local.structContactDetails["email"] = trim(local.excelValues["Email Id"].toString())>
                <cfset local.structContactDetails["phoneNumber"] = trim(local.excelValues["Phone Number"].toString())>
                <cfset local.structContactDetails["profileImage"] = "">

                <cfloop list="#local.excelValues["role"].toString()#" item="local.roleItem">
                    <cfset arrayAppend(local.roleIds, local.structExistingRoles[trim(local.roleItem)])>
                </cfloop>
                <cfset local.structContactDetails["role"] = arrayToList(local.roleIds,',')>

                <cfif structKeyExists(local.structExistingEmails, local.excelValues["email Id"].toString())>

                    <!---   Email already exists(update contact) --->

                    <cfset local.structContactDetails["editContactId"] = local.structExistingEmails[local.excelValues["email Id"].toString()]> 

                    <cfset local.updateResult = editContact(structForm = structContactDetails)>

                    <cfif structKeyExists(local.updateResult, "Error")>
                        <cfset local.resultStruct["errorCount"] +=1>
                        <cfset local.arrayResultColumn[local.excelValues.currentRow] = "Error while updating">
                    <cfelse>
                        <cfset local.resultStruct["updateCount"] +=1>
                        <cfset local.arrayResultColumn[local.excelValues.currentRow] = "Updated">
                    </cfif>

                <cfelse>

                    <!---   Create new contact --->
                    <cfset local.createResult = addContact(structContactDetails)>
                    
                    <cfif structKeyExists(local.createResult, "Error")>
                        <cfset local.arrayResultColumn[local.excelValues.currentRow] = "Error while creating">
                        <cfset local.resultStruct["errorCount"] +=1>
                    <cfelse>
                        <cfset local.resultStruct["createCount"] +=1>
                        <cfset local.arrayResultColumn[local.excelValues.currentRow] = "Added">
                    </cfif>

                </cfif>
            </cfif>
        </cfloop>
        <cfset queryAddColumn(local.excelValues, "Result", local.arrayResultColumn)>
        <cfset querySort(local.excelValues, sortExcelResult)>

        <cfset local.folderName = "../Assets/spreadsheetFiles/">
        <cfset local.filename = "upload_result_" & dateTimeFormat(now(),"dd-mm-yyy-HH-nn-ss") & ".xls">
        <cfset local.filePath = local.folderName  & local.fileName>
        <cfset local.sheet = spreadsheetNew("name")>
        
        <cfset spreadsheetAddRow(local.sheet,'Title,First Name,Last Name,Gender,DOB,Address,Street Name,District,State,Country,Pincode,Email ID,Phone Number,Role,Result')>
        <cfset spreadsheetFormatRow(local.sheet, {bold=true}, 1)>
        <cfset spreadsheetAddRows(local.sheet, local.excelValues)>
        <cfspreadsheet  action="write"  
                        filename="#expandpath(local.filePath)#" 
                        name="local.sheet"
                        overwrite="true">
        <cfif local.excelValues.recordCount>
            <cfset local.resultStruct["resultFileUrl"] = local.filePath>
            <cfset local.resultStruct["resultFileName"] = local.fileName>
        </cfif>

        <cfreturn local.resultStruct>
    </cffunction>

    <cffunction  name="sortExcelResult" returnType = "numeric">
        <cfargument  name="row1">
        <cfargument  name="row2">

        <cfset local.resultOrder = {"Updated": 2, "Added": 3}>
        <cfif NOT structKeyExists(local.resultOrder, arguments.row1.Result)>
            <cfset local.resultOrder[arguments.row1.Result] = 0>
        </cfif>
        <cfif NOT structKeyExists(local.resultOrder, arguments.row2.Result)>
            <cfset local.resultOrder[arguments.row2.Result] = 0>
        </cfif>

        <cfreturn compare(local.resultOrder[arguments.row1.Result],local.resultOrder[arguments.row2.Result])>
    </cffunction>

    <cffunction  name="editContactTest" access = "remote" returnFormat = "json">
        <cfargument  name="structForm">



        <cfdump  var="#arguments#">
    </cffunction>
</cfcomponent>