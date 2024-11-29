<cfset local.myObject = createObject("component","components.addressBook")>
<cfset local.myObject.birthday()>

<cfschedule 
    action = "update" 
    task = "birthdaywish" 
    operation = "HTTPRequest" 
    url = "http://addressbook.org/example.cfm"
    startTime = "6:17 PM" 
    startDate = "28/11/2024"
    interval = "100" >