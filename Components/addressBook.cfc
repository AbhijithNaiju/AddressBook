<cfcomponent>
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
                <cfset local.structResult["Error"] = "Error">
            </cfcatch>

            </cftry>
        </cfif> 

        <cfif NOT structKeyExists(local.structResult, "error")>
            <cfset userLogin(arguments.userName,arguments.password)>
        </cfif>

        <cfreturn local.structResult>
    </cffunction>

    <cffunction  name="userLogin" returntype="struct">

        <cfargument  name="userName" type="string">
        <cfargument  name="password" type="string">

        <cfset local.structResult = structNew()>
        <cfset local.hashedPassword = hash(arguments.password, "SHA-256")> 

        <cfquery name = "selectUser" >
            SELECT userId,fullname,profileImage
            FROM userTable
            WHERE userName = <cfqueryparam value='#arguments.userName#' cfsqltype="cf_sql_varchar">
            AND password = <cfqueryparam value='#local.hashedPassword#' cfsqltype="cf_sql_varchar">;
        </cfquery>
        
        <cfif selectUser.recordcount>

            <cfset session.userId = selectUser.userId>
            <cfset session.fullname = selectUser.fullname>
            <cfset session.profileImage = selectUser.profileImage>
            <cfset local.structResult["success"] = "success">

            <cflocation  url="./home.cfm">

        <cfelse>
            <cfset local.structResult["error"] = "Please enter a valid username and password">
        </cfif>

        <cfreturn local.structResult>
    </cffunction>
    
    <cffunction  name="logOut"  access="remote">
        <cfset structClear(session)>
        <cfreturn true>
    </cffunction>

</cfcomponent>