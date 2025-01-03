function openEditModal(editId)
{
    document.getElementById("editModal").classList.remove("displayNone");
    $(document).ready(function() {
        $('.selectpicker').selectpicker();
    });
    if(editId.value == "")
    {
        $("#modalHeading").text("CREATE CONTACT")
        document.getElementById("profileImageEdit").src = "./Assets/contactPictures/l60Hf.png";
    }
    else
    {
        $("#modalHeading").text("EDIT CONTACT")
        
        $.ajax({
        type:"POST",
        url:"./Components/addressBook.cfc?method=getEditData",
        data:{editId:editId.value},
        success: function(result) {
            if(result)
                {
                    resultJson=JSON.parse(result);
                    var roleArray = resultJson.role.trim().split(",");

                    $("#title").val(resultJson.title);
                    $("#firstName").val(resultJson.firstName);
                    $("#lastName").val(resultJson.lastName);
                    $("#gender").val(resultJson.gender);
                    $("#dateOfBirth").val(resultJson.dateOfBirth);
                
                    $("#role").val(roleArray);
                    $('.selectpicker').selectpicker('refresh');
                    
                    $("#profileDefault").val(resultJson.profileImage);
                    $("#address").val(resultJson.address);
                    $("#streetName").val(resultJson.streetName);
                    $("#pincode").val(resultJson.pincode);
                    $("#district").val(resultJson.district);
                    $("#state").val(resultJson.state);
                    $("#country").val(resultJson.country);
                    $("#phoneNumber").val(resultJson.phoneNumber);
                    $("#email").val(resultJson.email);
                    if(resultJson.profileImage == "")
                    {
                        document.getElementById("profileImageEdit").src = "./Assets/contactPictures/l60Hf.png";
                    }
                    else
                    {
                        document.getElementById("profileImageEdit").src = resultJson.profileImage;
                    }

                    $("#modalFormSubmitButton").val(editId.value);
                }
            },
            error:function()
            {
                alert("An error occured")
            }
        });
    }
}
function closeEditModal()
{
        document.getElementById("editModal").classList.add("displayNone");
        document.getElementById("createForm").reset();
        $('.error_message').text('');
        $('.selectpicker').selectpicker('refresh');

}
function openViewModal(viewId)
{
    viewModalBody=document.getElementById("viewModalBody")
    viewModalBody.innerHTML="";
    document.getElementById("viewModal").classList.remove("displayNone");
    $.ajax({
        type:"POST",
        url:"./Components/addressBook.cfc?method=getViewData",
        data:{viewId:viewId.value},
        success: function(result) {
            if(result)
            {                
                resultJson=JSON.parse(result);

                const jsonKeys=Object.keys(resultJson);
                for(i=0;i<jsonKeys.length;i++)
                {
                    a=jsonKeys[i];
                    if(a == "profileImage")
                    {
                        if(resultJson[a] == ""){
                            document.getElementById("viewProfileImage").src = "./Assets/contactPictures/l60Hf.png";
                        }
                        else{
                            document.getElementById("viewProfileImage").src = resultJson[a];
                        }
                    }
                    else
                    {
                        var parentDiv = document.createElement("DIV");
                        parentDiv.classList.add("contactDetails");
                        var contactItemName = document.createElement("DIV");
                        contactItemName.classList.add("contactItemName");
                        contactItemName.innerHTML=a;
                        var contactItemValue = document.createElement("DIV");
                        contactItemValue.classList.add("contactItemValue");
                        contactItemValue.innerHTML=resultJson[a];
                        parentDiv.appendChild(contactItemName);
                        parentDiv.appendChild(contactItemValue);
        
                        viewModalBody.appendChild(parentDiv);
                    }
                }
            }
        },
        error:function()
        {
            alert("An error occured")
        }
    });
}
function closeViewModal()
{
    document.getElementById("viewModal").classList.add("displayNone");
    $('.error_message').text('');
}

function submitEditModal(contactId)
{
    let title =$("#title").val();
    let firstName =$("#firstName").val();
    let lastName =$("#lastName").val();
    let gender =$("#gender").val();
    let role =$("#role").val();
    let dateOfBirth =$("#dateOfBirth").val();
    let address =$("#address").val();
    let streetName =$("#streetName").val();
    let pincode =$("#pincode").val();
    let district =$("#district").val();
    let state =$("#state").val();
    let country =$("#country").val();
    let phoneNumber =$("#phoneNumber").val();
    let email =$("#email").val();
    let profileImage =$("#profileImage").val();

    let allowedExtentions=["jpg","jpeg","png"];
    let fileExtension = String(/[^.]+$/.exec(profileImage)).toLowerCase();
	let email_match=/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    
    var titleError = "";
    var firstNameError = "";
    var lastNameError = "";
    var genderError = "";
    var roleError = "";
    var dateOfBirthError = "";
    var addressError = "";
    var streetNameError = "";
    var pincodeError = "";
    var districtError = "";
    var stateError = "";
    var countryError = "";
    var phoneNumberError = "";
    var emailError = "";
    var profileImageError = "";
    
    if(title.trim().length==0)
    {
        titleError = "Please enter title";
    }
    $("#titleError").text(titleError)

    if(firstName.trim().length==0)
    {
        firstNameError = "Please enter first name";
    }
    $("#firstNameError").text(firstNameError);

    if(lastName.trim().length==0)
    {
        lastNameError = "Please enter last name";
    }
    $("#lastNameError").text(lastNameError);


    if(gender.trim().length==0)
    {
        genderError = "Please enter the gender";
    }
    $("#genderError").text(genderError);

    if(role.toString().trim().length==0 )
    {
        roleError = "Please enter the role";
    }
    $("#roleError").text(roleError);

    if(dateOfBirth.trim().length==0)
    {
        dateOfBirthError = "Please enter the DOB";
    }
    $("#dateOfBirthError").text(dateOfBirthError);

    if(address.trim().length==0)
    {
        addressError = "Please enter the address";
    }
    $("#addressError").text(addressError);

    if(streetName.trim().length==0)
    {
        streetNameError = "Please enter the street name";
    }
    $("#streetNameError").text(streetNameError);

    if(pincode.trim().length==0)
    {
        pincodeError = "Please enter the pincode";
    }
    else if(isNaN(pincode)){
        pincodeError = "Please enter a valid number";
    }
    else if(pincode.trim().length != 6) {
        pincodeError = "Pincode must be 6 digits";
    }
    $("#pincodeError").text(pincodeError);

    if(district.trim().length==0)
    {
        districtError = "Please enter the district";
    }
    $("#districtError").text(districtError);

    if(state.trim().length==0)
    {
        stateError = "Please enter the state";
    }
    $("#stateError").text(stateError);

    if(country.trim().length==0)
    {
        countryError = "Please enter the country";
    }
    $("#countryError").text(countryError);

    if(phoneNumber.trim().length==0)
    {
        phoneNumberError = "Please enter the phone number";
    }
    else if(isNaN(phoneNumber))
    {
        phoneNumberError = "Please enter a valid number";
    }
    else if(phoneNumber.trim().length != 10)
    {
        phoneNumberError = "Phone number must be 10 digits";
    }
    $("#phoneNumberError").text(phoneNumberError);


    if(!profileImage || allowedExtentions.includes(fileExtension))
    {
        profileImageError = "";
    }
    else
    {
        profileImageError = "Only JPG,JPEG and PNG files are allowed";
    }
    $("#profileImageError").text(profileImageError);

    if(email.trim().length==0)
    {
        emailError = "Please enter the email";
    }
    else if(email_match.test(email)!=true) {
        emailError = "Please enter a valid email";
    }
    $("#emailError").text(emailError);
    
    if( titleError  == "" &&
        firstNameError  == "" &&
        lastNameError  == "" &&
        genderError  == "" &&
        dateOfBirthError  == "" &&
        addressError  == "" &&
        streetNameError == "" &&
        pincodeError == "" &&
        districtError == "" &&
        stateError == "" &&
        countryError == "" &&
        phoneNumberError == "" &&
        emailError == "" &&
        roleError == "" &&
        profileImageError == "")
    {
        if(contactId.value == "")
        {
            contactFunction = "addContact"
        }
        else
        {
            contactFunction = "editContact"
        }
        var formElement = document.getElementById("createForm");
        var formData = new FormData(formElement);
        formData.append("editContactId", contactId.value);
        $.ajax({
            type: "POST",
            url: "./components/addressBook.cfc?method="+contactFunction,
            data: formData,
            processData: false,
            contentType: false,
            success: function(result) {
            resultJson=JSON.parse(result);
                if(resultJson.error){
                    $("#editModalError").text(editModalError);
                }
                else if(resultJson.emailError){
                    $("#emailError").text(emailError);
                }
                else
                {
                    closeEditModal();
                    location.reload();
                }
            }
        });

    }
}

function logout()
{
	if(confirm("You will log out of this page and need to authenticate again to login"))
	{
		$.ajax({
			type:"POST",
			url:"./Components/addressBook.cfc?method=logOut",
			success: function() {
				location.reload();
			}
		});
	}
}

function deleteContact(deleteId)
{
    if(confirm("Confirm delete"))
        {
            $.ajax({
                type:"POST",
                url:"./Components/addressBook.cfc?method=deleteContact",
                data:{deleteId:deleteId.value},
                success: function(result) {
                    if(result)
                    {
                        deleteId.parentElement.parentElement.remove();
                    }
                },
                error:function()
                {
                    alert("An error occured")
                }
            });
        }
}

function createSpreadsheet(){
    if(confirm("Download as spredsheet"))
    $.ajax({
        type:"POST",
        url:"./Components/addressBook.cfc?method=createSpreadsheet",
        data: {contactData: true},
        success: function(result) {
            resultJson=JSON.parse(result);
            if(resultJson.spreadsheetUrl)
            {
                downloadFile(resultJson.spreadsheetUrl,resultJson.spreadsheetName)
            }
            else
            {
                alert("An Error occured")
            }
        },
        error:function()
        {
            alert("An error occured")
        }
    });
}

function uploadSpreadSheet(){
    $("#downloadLink").text("");
    $("#excelUploadError").text("");
    $("#excelUploadResult").text("");

    var excelUploadError = ""
    const allowedExtentions = ["xlsx","xls"];
    var inputFile = document.getElementById("excelInput").files[0];
    if (inputFile) 
    {
        fileExtension = String(/[^.]+$/.exec(inputFile.name));
        if(allowedExtentions.includes(fileExtension.toLowerCase()))
        {
            const excelformData = new FormData();
            excelformData.append("inputFile",inputFile);
            
            $.ajax({
                type: "POST",
                url: "./components/addressBook.cfc?method=uploadContact",
                data: excelformData,
                processData: false,
                contentType: false,
                success: function(result) {
                    resultJson = JSON.parse(result);
                    if(resultJson.error)
                    {  
                        $("#excelUploadError").text(resultJson.error);
                    }
                    else{
                        if(resultJson.resultFileUrl && resultJson.resultFileName)
                            {
                                var downloadLink = document.getElementById("downloadLink");
                                downloadLink.innerHTML = "Download result";
                                downloadLink.setAttribute('download', resultJson.resultFileName);
                                downloadLink.href = resultJson.resultFileUrl;
                            }
                        $("#createCount").text("Contacts created :"+resultJson.createCount);
                        $("#updateCount").text("Contacts updated:"+resultJson.updateCount);
                        $("#errorCount").text("Errors :" + resultJson.errorCount);
                    }
                },
                error: function() {
                    $("#excelUploadError").text("Excel Upload Error");
                }
            });
        }
        else
        {
            excelUploadError = "Only xlsx & xls files are allowed";
        }
    }
    else
    {
        excelUploadError = "Please enter a file"
    }
    $("#excelUploadError").text(excelUploadError);

}

function createPlainTemp(){
    if(confirm("Download as spredsheet"))
        $.ajax({
    type:"POST",
    data: {contactData: false},
    url:"./Components/addressBook.cfc?method=createSpreadsheet",
    success: function(result) {
        resultJson=JSON.parse(result);
            if(resultJson.spreadsheetUrl)
            {
                downloadFile(resultJson.spreadsheetUrl,"Plain_Template")
            }
            else
            {
                alert("An Error occured")
            }
        },
        error:function()
        {
            alert("An error occured")
        }
    });
}

function printPdf()
{
    if(confirm("Dowload as pdf"))
    {
        $.ajax({
            type:"POST",
            url:"./Components/addressBook.cfc?method=createPdf",
            success: function(result) {
                resultJson=JSON.parse(result);
                if(resultJson.pdfUrl)
                {
                    downloadFile(resultJson.pdfUrl,resultJson.pdfName)
                }
                else
                {
                    alert("An Error occured");
                }
            },
            error:function()
            {
                alert("An error occured")
            }
        });
    }
}

function printPage()
{
    var bodyDiv = document.body.innerHTML;
    var printDiv = document.getElementById("contactList").innerHTML;
    document.body.innerHTML = printDiv;
    $(".contactButtons").css({"display":"none"});
    window.print();
    document.body.innerHTML = bodyDiv;
}

function downloadFile(fileUrl, fileName) 
{
    var downloadLink = document.createElement("a");
    downloadLink.setAttribute('download', fileName);
    downloadLink.href = fileUrl;
    document.body.appendChild(downloadLink);
    downloadLink.click();
    downloadLink.remove();
}

function openExcelModal()
{
    document.getElementById("excelModal").classList.remove("displayNone");
}

function closeExcelModal()
{
    // document.getElementById("excelModal").classList.add("displayNone");
    // $("#downloadLink").text("");
    // $("#excelUploadError").text("");
    // $("#excelUploadResult").text("");
    // $("#excelInput").val("");
    location.reload();
}