<!--- <cfcomponent> 
    <cfset this.datasource = "cmsDataSource">
    <cfset this.sessionManagement = true>
    <cfset application.myObject = new createObject("component", "components.addressBook")>
    <cffunction name="onRequest" >

        <cfargument  name="requestedpage">

        <cfset local.excludedPages=["/addressBook/login.html","/addressBook/signUp.html"]>

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
 </cfcomponent> --->