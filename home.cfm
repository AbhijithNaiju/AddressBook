<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="./style/index.css">
        <link rel="stylesheet" href="./style/home_style.css">
        <link rel="stylesheet" href="./style/bootstrap-5.3.3-dist/css/bootstrap.min.css">

        <title>Home</title>
    </head>
    <body>
        <cfset addressBookObj = createObject("component", "components.addressBook")>
        <cfset userdetails = addressBookObj.userDetails()>
        <cfset statusStruct = addressBookObj.getScheduleStatus(taskName = "birthdayTask-#userDetails.email#")>
        <cfset uploadDirectory = "./Assets/contactPictures/">
        <cfset contactRoles = addressBookObj.getAllRoles()>

        <cfif NOT directoryExists(expandPath(uploadDirectory))>
            <cfset directoryCreate(expandPath(uploadDirectory))>
        </cfif>

            <div class="header">
                <a href="" class="logo">
                    <img src="./Assets/images/contact_book_logo.png" alt="Image not found">
                    <span>ADDRESS BOOK</span>
                </a>
                <div class="logout_button">
                    <button onclick="logout()">
                        <img src="./Assets/images/logout.png" alt="Image not found">
                        Logout
                    </button>
                </div>
            </div>
        <main class="main positionAbsolute">
            <div class="homeBody">
                <div class="homeHeader">
                    <div class="printOptions">
                        <button  name="printPdfBtn" onclick="printPdf()">
                            <img src="./Assets/images/acrobat.png" alt="Image not found">
                        </button>
                        <button type="button" onclick="createSpreadsheet()">
                            <img src="./Assets/images/excel.png" alt="Image not found">
                        </button>
                        <button onclick="printPage()" type="button">
                            <img src="./Assets/images/print.png" alt="Image not found">
                        </button>
                    </div>
                </div>
                <div class="homeElements">
                    <div class="profileBox">
                        <cfoutput>
                            <cfif userdetails.profileImage EQ "">
                                <cfset userProfileImage = "./Assets/contactPictures/l60Hf.png">
                            <cfelse>
                                <cfset userProfileImage = userdetails.profileImage>
                            </cfif>
                            <img src="#userProfileImage#" alt="image not found">
                            <div class="profileName">#userdetails.fullName#</div>
                        </cfoutput>
                        <button onclick="openEditModal(this)" class="createButton" value="">
                            CREATE CONTACT
                        </button>
                        <button onclick="openExcelModal()" class="openExcel btn">Upload Contact</button>
                    </div>

                    <div class = "contactListContainer" id="contactList">
                        <table class="contactList">
                            <tr class="contactListHeading">
                                <th class="listProfile">

                                </th>
                                <th class="list_name">
                                    NAME
                                </th>
                                <th class="listEmail">
                                    EMAIL ID
                                </th>
                                <th class="listPhone">
                                    PHONE NUMBER
                                </th>
                                <th class="listButton">
                                    
                                </th>
                            </tr>
                            <cfset ormReload()>
                            <cfset contactDetails = entityLoad("contactOrm",{_createdBy = session.userId,active = 1})>
                            <cfloop array="#contactDetails#" item = "contactItem">  
                                <cfoutput>
                                    <tr class="contactListItem">
                                        <td class="listProfile">
                                            <cfif contactItem.getprofileImage() EQ "">
                                                <cfset contactProfileImage = "./Assets/contactPictures/l60Hf.png">
                                            <cfelse>
                                                <cfset contactProfileImage = contactItem.getprofileImage()>
                                            </cfif>
                                            <img src="#contactProfileImage#" alt="Image not found">
                                        </td>
                                        <td class="listName">
                                            #contactItem.getfirstName()# #contactItem.getlastName()#
                                        </td>
                                        <td class="listEmail">
                                            #contactItem.getemailId()#
                                        </td>
                                        <td class="listPhone">
                                            #contactItem.getphoneNumber()#
                                        </td>
                                        <td class="listButton">
                                            <button type="button" 
                                                    value="#contactItem.getcontactId()#" 
                                                    onclick="openEditModal(this)" 
                                                    class = "contactButtons">
                                                EDIT
                                            </button>
                                            <button type="button" 
                                                    value="#contactItem.getcontactId()#" 
                                                    onclick="deleteContact(this)" 
                                                    class = "contactButtons">
                                                DELETE
                                            </button>
                                            <button type="button" 
                                                    value="#contactItem.getcontactId()#" 
                                                    onclick="openViewModal(this)" 
                                                    class = "contactButtons">
                                                VIEW
                                            </button>
                                        </td>
                                    </tr>
                                </cfoutput>
                            </cfloop>
                        </table>
                    </div>
                </div>
            </div>
        </main>
        <div class="editModal displayNone" id="editModal">
            <div class="editForm">
                <form method="post" class="editFormBody" id="createForm" enctype="multipart/form-data" autocomplete>
                    <div class="modal_heading" id="modalHeading"></div>

                    <div class="modalSubHeadng">
                        Personal contact
                    </div>

                    <div class="editModalElement">
                        <div class="width_20">
                            <label for="">Title *</label>
                            <select class="formElement" id="title" name="title">
                                <option value=""></option>
                                <option value="Mr">Mr</option>
                                <option value="Mrs">Mrs</option>
                            </select>
                            <div class="error_message" id="titleError"></div>
                        </div>
                        <div class="width_30">
                            <label for="">First name *</label>
                            <input type="text" placeholder=" First name" class="formElement" id="firstName" name="firstName">
                            <div class="error_message" id="firstNameError"></div>
                        </div>
                        <div class="width_30">
                            <label for="">Last name *</label>
                            <input type="text" placeholder=" Last name" class="formElement" id="lastName" name="lastName">
                            <div class="error_message" id="lastNameError"></div>
                        </div>
                    </div>

                    <div class="editModalElement">
                        <div class="width_45">
                            <label for="">Gender *</label>
                            <select class="formElement" id="gender" name="gender">
                                <option value=""></option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                            </select>
                            <div class="error_message" id="genderError"></div>
                        </div>
                        <div class="width_45">
                            <label for="">Role *</label>
                            <select class="selectpicker" multiple data-live-search="true" required id="role" name="role">
                                <cfoutput>
                                    <cfloop query="contactRoles">
                                        <option value="#contactRoles.roleId#">#contactRoles.name#</option>
                                    </cfloop>
                                </cfoutput>
                            </select>
                            <div class="error_message" id="roleError"></div>
                        </div>
                    </div>

                    <div class="editModalElement">
                        <div class="width_45">
                            <label for="">Upload Photo *</label>
                            <input type="file" class="formElement" id="profileImage" name="profileImage">
                            <input type="hidden" name="profileDefault" id="profileDefault">
                            <div class="error_message" id="profileImageError"></div>
                        </div>
                        <div class="width_45">
                            <label for="">Date of Birth *</label>
                            <cfoutput>
                                <input type="date" class="formElement" id="dateOfBirth" name="dateOfBirth" max="#dateformat(now(),"yyyy-mm-dd")#">
                            </cfoutput>
                            <div class="error_message" id="dateOfBirthError"></div>
                        </div>
                    </div>
                    <div class="modalSubHeadng">
                        Contact details
                    </div>

                    <div class="editModalElement">
                        <div class="width_45">
                            <label for="">Address *</label>
                            <input type="text" placeholder=" Address" class="formElement" name="address" id="address">
                            <div class="error_message" id="addressError"></div>
                        </div>
                        <div class="width_45">
                            <label for="">Street *</label>
                            <input type="text" placeholder=" Street Name" class="formElement" id="streetName" name="streetName">
                            <div class="error_message" id="streetNameError"></div>
                        </div>
                    </div>

                    <div class="editModalElement">
                    <div class="width_45">
                        <label for="">Pincode *</label>
                            <input type="text" placeholder=" Pincode" class="formElement" id="pincode" name="pincode">
                            <div class="error_message" id="pincodeError"></div>
                        </div>
                        <div class="width_45">
                            <label for="">District *</label>
                            <input type="text" placeholder=" District" class="formElement" id="district" name="district">
                            <div class="error_message" id="districtError"></div>
                        </div>
                    </div>

                    <div class="editModalElement">
                        <div class="width_45">
                            <label for="">State *</label>
                            <input type="text" placeholder=" State" class="formElement" name="state" id="state">
                            <div class="error_message" id="stateError"></div>
                        </div>
                        <div class="width_45">
                            <label for="">Country *</label>
                            <input type="text" placeholder=" Country" class="formElement" name="country" id="country">
                            <div class="error_message" id="countryError"></div>
                        </div>
                    </div>

                    <div class="editModalElement">
                        <div class="width_45">
                            <label for="">Phone *</label>
                            <input type="text" placeholder=" Phone" class="formElement" name="phoneNumber" id="phoneNumber">
                            <div class="error_message" id="phoneNumberError"></div>

                        </div>
                        <div class="width_45">
                            <label for="">Email *</label>
                            <input type="text" placeholder="Email" class="formElement" name="email" id="email">
                            <div class="error_message" id="emailError"></div>
                        </div>
                    </div>

                    <div class="modalButtons">
                        <button onclick="closeEditModal()" type="button">Cancel</button>
                        <button type="button" onclick="submitEditModal(this)" id="modalFormSubmitButton">Submit</button>
                    </div>
                    <div class="error_message" id="editModalError"></div>

                </form>
                <div class="editFormImage">
                    <img src="Assets\contactPictures\l60Hf.png" id="profileImageEdit" alt="Image not found">
                </div>
            </div>
        </div>
        <div class="viewModal displayNone" id="viewModal">
            <div class="editForm">
                <div class="editFormBody"  enctype="multipart/form-data">
                    <div class="modalHeading">
                        CONTACT DETAILS
                    </div>
                    <div id="viewModalBody">

                    </div>
                    <div class="modalButtons">
                        <button onclick="closeViewModal()" type="button">Close</button>
                    </div>
                </div>
                <div class="viewFormImage">
                    <img src="Assets\contactPictures\l60Hf.png" alt="Image not found" id = "viewProfileImage">
                </div>
            </div>
        </div>
        <div class="excelModal displayNone" id = "excelModal">
            <div class="excelModalBody">
                <div class="getExcelBtns">
                    <button class="dataTemplateBtn" onclick = "createSpreadsheet()">Template with data</button>
                    <button class="plainTemplateBtn" onclick = "createPlainTemp()">Plain template</button>
                </div>
                <div class = "excelModalContent">
                    <div class="excelModalHeading">
                        Upload Excel File
                    </div>
                    <div class="excelModalInput" id = "excelModalInput">
                        <label for="excelInput">Upload Excel *</label>
                        <input type="file"  class="" name="excelInput" id="excelInput">
                        <div class="error_message" id="excelUploadError"></div>
                    </div>
                        <div class="" id="createCount"></div>
                        <div class="" id="updateCount"></div>
                        <div class="" id="errorCount"></div>
                        <a href = "" id = "downloadLink"></a>
                    <div class="uploadExcel">
                        <button class="submitExcel" onclick = "uploadSpreadSheet()">SUBMIT</button>
                        <button class="closeExcelModal" onclick="closeExcelModal()">CLOSE</button>
                    </div>
                </div>
            </div>
        </div>

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-multiselect@0.9.15/dist/css/bootstrap-multiselect.css">

        <script src="./JS/Jquery/jquery-3.7.1.js"></script>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.min.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
        <script src="./JS/home.js"></script>
    </body>
</html>