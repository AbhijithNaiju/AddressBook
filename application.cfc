 <cfcomponent> 
    <cfset this.datasource = "addressBook">
    <cfset this.sessionManagement = true>
    <cfset this.sessiontimeout=#CreateTimeSpan(0,0,30,0)#>
    
    <cffunction name="onRequest" > 

        <cfargument  name="requestedpage">

        <cfset local.excludedPages=["/AddressBook/login.cfm","/AddressBook/signup.cfm"]>

        <cfif arrayFind(local.excludedPages,arguments.requestedpage)>
            <cfinclude  template="#arguments.requestedpage#">
        <cfelse>

            <cfif structKeyExists(session, "userId")>
                <cfinclude  template="#arguments.requestedpage#" >
            <cfelse>
                <cflocation  url="login.cfm">
            </cfif>

        </cfif>

    </cffunction> 
 </cfcomponent>