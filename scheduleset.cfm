<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title></title>
        <link rel="stylesheet" href="./style/bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="./style/index.css">
    </head>
    <body>
        <main class="main">
            <cfset local.myObject = createObject("component","components.addressBook")>
            <div class="header">
                <a href="" class="logo">
                    <img src="./Assets/images/contact_book_logo.png" alt="Image not found">
                    <span>ADDRESS BOOK</span>
                </a>
            </div>
            <form method="post" class = "d-flex justify-content-around" >
                <button name="setSchedule" class="btn btn-primary">Set Schedule</button>
                <button name="resumeSchedule" class="btn btn-primary">Resume Schedule</button>
                <button name="pauseSchedule" class="btn btn-danger">Pause Scheduler</button>
            </form>
            <cfif structKeyExists(form, "setSchedule")>
                <cfset local.myObject.setBirthdaySchedule()>
            </cfif>
            <cfif structKeyExists(form, "resumeSchedule")>
                <cfset local.myObject.resumeBirthDaySchedule()>
            </cfif>
            <cfif structKeyExists(form, "pauseSchedule")>
                <cfset local.myObject.pauseBirthDaySchedule()>
            </cfif>
        </main>
    </body>
</html>