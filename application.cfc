 <cfcomponent> 
    <cfset this.datasource = "addressBook">
    <cfset this.sessionManagement = true>
    <cfset this.sessiontimeout=#CreateTimeSpan(0,0,30,0)#>
    
    <cffunction name="onRequest" > 

        <cfargument  name="requestedpage">

        <cfset local.excludedPages=["/login.cfm","/signup.cfm","/ssologin.cfm"]>

        <cfif arrayFind(local.excludedPages,arguments.requestedpage) OR structKeyExists(session, "userId")>
                <cfinclude  template="#arguments.requestedpage#" >
        <cfelse>
                <cfinclude  template="login.cfm" >
        </cfif>

    </cffunction> 
 </cfcomponent>