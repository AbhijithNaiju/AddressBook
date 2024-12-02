 <cfcomponent> 
    <cfset this.datasource = "addressBook">
    <cfset this.sessionManagement = true>
    <cfset this.sessiontimeout=#CreateTimeSpan(0,0,30,0)#>
    <cfset this.ormEnabled = true>
    
    <cffunction name="onRequest" > 

        <cfargument  name="requestedpage">

        <cfset local.excludedPages=["/login.cfm","/signup.cfm","/ssologin.cfm","/errorPage.cfm"]>

        <cfif arrayFind(local.excludedPages,arguments.requestedpage) OR structKeyExists(session, "userId")>
                <cfinclude  template="#arguments.requestedpage#" >
        <cfelseif arguments.requestedpage EQ "/birthdayMail.cfm" AND CGI.HTTP_USER_AGENT EQ "CFSCHEDULE">
                <cfinclude  template="#arguments.requestedpage#" >
        <cfelse>
                <cfinclude  template="login.cfm" >
        </cfif>

    </cffunction>

<!---     <cffunction  name = "onError"> --->
<!---         <cfargument  name = "exception"> --->
<!---         <cfargument  name = "eventName" type = "string"> --->

<!---         <cflocation  url="./errorPage.cfm?exception=?#arguments.exception#&eventName#arguments.eventName#"> --->
<!---     </cffunction> --->

 </cfcomponent>