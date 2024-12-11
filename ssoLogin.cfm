<cfset myObject = createObject("component","components.addressBook")>
<cfif structKeyExists(session, "userId")>
    <cfset myObject.logOut()>
</cfif>

<cftry>
    <cflogin> 
        <cfoauth
        type = "google"
        result = "oauthResult"
        scope="email profile">
    </cflogin>
<cfcatch type="exception">
    <cflocation  url="./login.cfm?error=Error-occured">
</cfcatch>
</cftry>

<cfif isDefined("oauthResult")>
    <cfset myobject.ssoLogin(oauthResult = oauthResult)>
</cfif>

