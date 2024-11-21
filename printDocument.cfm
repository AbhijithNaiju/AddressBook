<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="./style/index.css">
        <link rel="stylesheet" href="./style/home_style.css">
        <title>Home</title>
    </head>
    <body>
        <cfset local.myObject = createObject("component", "components.addressBook")>
        <cfset local.allContactList = local.myObject.getAllContacts()>
        <main class="main position_absolute">
            <div class="home_body">
                <div class="home_elements">
                    <div class="contact_list">
                        <div class="contact_list_heading">
                            <div class="list_profile">

                            </div>
                            <div class="list_name">
                                NAME
                            </div>
                            <div class="list_email">
                                EMAIL ID
                            </div>
                            <div class="list_phone">
                                PHONE NUMBER
                            </div>
                            <div class="list_button">
                                
                            </div>
                        </div>
                        <cfloop query="local.allContactList">
                            <cfoutput>
                                <div class="contact_list_item" id="#local.allContactList.contactId#">
                                    <div class="list_profile">
                                        <cfif local.allContactList.profileImage EQ "">
                                            <cfset local.contactProfileImage = "./Assets/contactPictues/l60Hf.png">
                                        <cfelse>
                                            <cfset local.contactProfileImage = local.allContactList.profileImage>
                                        </cfif>
                                        <img src="#local.contactProfileImage#" alt="Image not found">
                                    </div>
                                    <div class="list_name">
                                        #local.allContactList.firstName# #local.allContactList.lastName#
                                    </div>
                                    <div class="list_email">
                                        #local.allContactList.emailId#
                                    </div>
                                    <div class="list_phone">
                                        #local.allContactList.phoneNumber#
                                    </div>
                                </div>
                            </cfoutput>
                        </cfloop>
                    </div>
                </div>
            </div>
        </main>
    </body>
</html>