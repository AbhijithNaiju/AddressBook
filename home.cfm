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
        <cfset uploadDirectory = "./Assets/contactPictues/">
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
        <main class="main position_absolute">
            <div class="home_body">
                <div class="home_header">
                    <div class="print_options">
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
                <div class="home_elements">
                    <div class="profile_box">
                        <cfoutput>
                            <cfif userdetails.profileImage EQ "">
                                <cfset userProfileImage = "./Assets/contactPictues/l60Hf.png">
                            <cfelse>
                                <cfset userProfileImage = userdetails.profileImage>
                            </cfif>
                            <img src="#userProfileImage#" alt="image not found">
                            <div class="profile_name">#userdetails.fullName#</div>
                        </cfoutput>
                        <button onclick="openEditModal(this)" class="create_button" value="">
                            CREATE CONTACT
                        </button>
                        <button onclick="openExcelModal()" class="openExcel btn">Upload Contact</button>
                    </div>

                    <table class="contact_list" id="contactList">
                        <tr class="contact_list_heading">
                            <th class="list_profile">

                            </th>
                            <th class="list_name">
                                NAME
                            </th>
                            <th class="list_email">
                                EMAIL ID
                            </th>
                            <th class="list_phone">
                                PHONE NUMBER
                            </th>
                            <th class="list_button">
                                
                            </th>
                        </tr>
                        <cfset ormReload()>
                        <cfset contactDetails = entityLoad("contactOrm",{_createdBy = session.userId,active = 1})>
                        <cfloop array="#contactDetails#" item = "contactItem">  
                            <cfoutput>
                                <tr class="contact_list_item">
                                    <td class="list_profile">
                                        <cfif contactItem.getprofileImage() EQ "">
                                            <cfset contactProfileImage = "./Assets/contactPictues/l60Hf.png">
                                          <cfelse>
                                            <cfset contactProfileImage = contactItem.getprofileImage()>
                                        </cfif>
                                        <img src="#contactProfileImage#" alt="Image not found">
                                    </td>
                                    <td class="list_name">
                                        #contactItem.getfirstName()# #contactItem.getlastName()#
                                    </td>
                                    <td class="list_email">
                                        #contactItem.getemailId()#
                                    </td>
                                    <td class="list_phone">
                                        #contactItem.getphoneNumber()#
                                    </td>
                                    <td class="list_button">
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
        </main>
        <div class="edit_modal display_none" id="editModal">
            <div class="edit_form">
                <form method="post" class="edit_form_body" id="createForm" enctype="multipart/form-data" autocomplete>
                    <div class="modal_heading" id="modalHeading"></div>

                    <div class="modal_sub_headng">
                        Personal contact
                    </div>

                    <div class="edit_modal_element">
                        <div class="width_20">
                            <label for="">Title *</label>
                            <select class="form_element" id="title" name="title">
                                <option value=""></option>
                                <option value="Mr">Mr</option>
                                <option value="Mrs">Mrs</option>
                            </select>
                            <div class="error_message" id="titleError"></div>
                        </div>
                        <div class="width_30">
                            <label for="">First name *</label>
                            <input type="text" placeholder=" First name" class="form_element" id="firstName" name="firstName">
                            <div class="error_message" id="firstNameError"></div>
                        </div>
                        <div class="width_30">
                            <label for="">Last name *</label>
                            <input type="text" placeholder=" Last name" class="form_element" id="lastName" name="lastName">
                            <div class="error_message" id="lastNameError"></div>
                        </div>
                    </div>

                    <div class="edit_modal_element">
                        <div class="width_45">
                            <label for="">Gender *</label>
                            <select class="form_element" id="gender" name="gender">
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

                    <div class="edit_modal_element">
                        <div class="width_45">
                            <label for="">Upload Photo *</label>
                            <input type="file" class="form_element" id="profileImage" name="profileImage">
                            <input type="hidden" name="profileDefault" id="profileDefault">
                            <div class="error_message" id="profileImageError"></div>
                        </div>
                        <div class="width_45">
                            <label for="">Date of Birth *</label>
                            <cfoutput>
                                <input type="date" class="form_element" id="dateOfBirth" name="dateOfBirth" max="#dateformat(now(),"yyyy-mm-dd")#">
                            </cfoutput>
                            <div class="error_message" id="dateOfBirthError"></div>
                        </div>
                    </div>
                    <div class="modal_sub_headng">
                        Contact details
                    </div>

                    <div class="edit_modal_element">
                        <div class="width_45">
                            <label for="">Address *</label>
                            <input type="text" placeholder=" Address" class="form_element" name="address" id="address">
                            <div class="error_message" id="addressError"></div>
                        </div>
                        <div class="width_45">
                            <label for="">Street *</label>
                            <input type="text" placeholder=" Street Name" class="form_element" id="streetName" name="streetName">
                            <div class="error_message" id="streetNameError"></div>
                        </div>
                    </div>

                    <div class="edit_modal_element">
                    <div class="width_45">
                        <label for="">Pincode *</label>
                            <input type="text" placeholder=" Pincode" class="form_element" id="pincode" name="pincode">
                            <div class="error_message" id="pincodeError"></div>
                        </div>
                        <div class="width_45">
                            <label for="">District *</label>
                            <input type="text" placeholder=" District" class="form_element" id="district" name="district">
                            <div class="error_message" id="districtError"></div>
                        </div>
                    </div>

                    <div class="edit_modal_element">
                        <div class="width_45">
                            <label for="">State *</label>
                            <input type="text" placeholder=" State" class="form_element" name="state" id="state">
                            <div class="error_message" id="stateError"></div>
                        </div>
                        <div class="width_45">
                            <label for="">Country *</label>
                            <input type="text" placeholder=" Country" class="form_element" name="country" id="country">
                            <div class="error_message" id="countryError"></div>
                        </div>
                    </div>

                    <div class="edit_modal_element">
                        <div class="width_45">
                            <label for="">Phone *</label>
                            <input type="text" placeholder=" Phone" class="form_element" name="phoneNumber" id="phoneNumber">
                            <div class="error_message" id="phoneNumberError"></div>

                        </div>
                        <div class="width_45">
                            <label for="">Email *</label>
                            <input type="text" placeholder="Email" class="form_element" name="email" id="email">
                            <div class="error_message" id="emailError"></div>
                        </div>
                    </div>

                    <div class="modal_buttons">
                        <button onclick="closeEditModal()" type="button">Cancel</button>
                        <button type="button" onclick="submitEditModal(this)" id="modalFormSubmitButton">Submit</button>
                    </div>
                    <div class="error_message" id="editModalError"></div>

                </form>
                <div class="edit_form_image">
                    <img src="Assets\contactPictues\l60Hf.png" id="profileImageEdit" alt="Image not found">
                </div>
            </div>
        </div>
        <div class="view_modal display_none" id="viewModal">
            <div class="edit_form">
                <div class="edit_form_body"  enctype="multipart/form-data">
                    <div class="modal_heading">
                        CONTACT DETAILS
                    </div>
                    <div id="viewModalBody">

                    </div>
                    <div class="modal_buttons">
                        <button onclick="closeViewModal()" type="button">Close</button>
                    </div>
                </div>
                <div class="view_form_image">
                    <img src="Assets\contactPictues\l60Hf.png" alt="Image not found" id = "viewProfileImage">
                </div>
            </div>
        </div>
        <div class="excelModal display_none" id = "excelModal">
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
                        <div class="" id="excelUploadResult"></div>
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