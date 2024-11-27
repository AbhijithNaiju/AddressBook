<cfset local.myObject = createObject("component","components.addressBook")>
<cfif structKeyExists(session, "userId")>
    <cfdump  var="#session.userId#">
</cfif>
<cflogin> 
    <cfoauth
    type = "google"
    result = "oauthResult"
    scope="email profile openid">
</cflogin>

<cfif isDefined("oauthResult")>
    <cfset local.myobject.ssoLogin(oauthResult)>
</cfif>

