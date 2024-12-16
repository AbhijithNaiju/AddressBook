function printOutput(printLocation,printValue)
{
	document.getElementById(printLocation).innerHTML = printValue;
}
function openEditModal(editId)
{
    document.getElementById("editModal").classList.remove("display_none");
    $(document).ready(function() {
        $('.selectpicker').selectpicker();
    });
    if(editId.value == "")
    {
        document.getElementById("modalFormSubmitButton").name="addContact";
        document.getElementById("modalHeading").innerHTML="CREATE CONTACT";
        document.getElementById("profileImageEdit").src = "./Assets/contactPictues/l60Hf.png";
    }
    else
    {
        document.getElementById("modalFormSubmitButton").name="editContact";
        document.getElementById("modalHeading").innerHTML="EDIT CONTACT";
        
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
                        document.getElementById("profileImageEdit").src = "./Assets/contactPictues/l60Hf.png";
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
        document.getElementById("editModal").classList.add("display_none");
        document.getElementById("createForm").reset();
        $('.error_message').text('');
        $('.selectpicker').selectpicker('refresh');

}
function openViewModal(viewId)
{
    viewModalBody=document.getElementById("viewModalBody")
    viewModalBody.innerHTML="";
    document.getElementById("viewModal").classList.remove("display_none");
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
                            document.getElementById("viewProfileImage").src = "./Assets/contactPictues/l60Hf.png";
                        }
                        else{
                            document.getElementById("viewProfileImage").src = resultJson[a];
                        }
                    }
                    else
                    {
                        var parentDiv = document.createElement("DIV");
                        parentDiv.classList.add("contact_details");
                        var contactItemName = document.createElement("DIV");
                        contactItemName.classList.add("contact_item_name");
                        contactItemName.innerHTML=a;
                        var contactItemValue = document.createElement("DIV");
                        contactItemValue.classList.add("contact_item_value");
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
    document.getElementById("viewModal").classList.add("display_none");
    $('.error_message').text('');
}

function formValidate(event)
{
    let title =  document.getElementById("title").value;
    let firstName =  document.getElementById("firstName").value;
    let lastName =  document.getElementById("lastName").value;
    let gender =  document.getElementById("gender").value;
    let role =  document.getElementById("role").value;
    let dateOfBirth =  document.getElementById("dateOfBirth").value;
    let address =  document.getElementById("address").value;
    let streetName =  document.getElementById("streetName").value;
    let pincode =  document.getElementById("pincode").value;
    let district =  document.getElementById("district").value;
    let state =  document.getElementById("state").value;
    let country =  document.getElementById("country").value;
    let phoneNumber =  document.getElementById("phoneNumber").value;
    let email =  document.getElementById("email").value;
    let profileImage = document.getElementById("profileImage").value;
    let submitButtonId = document.getElementById("modalFormSubmitButton").value;
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

    if(title.trim().length==0)
    {
        titleError = "Please enter title";
    }
    printOutput("titleError",titleError);

    if(firstName.trim().length==0)
    {
        firstNameError = "Please enter first name";
    }
    printOutput("firstNameError",firstNameError);

    if(lastName.trim().length==0)
    {
        lastNameError = "Please enter last name";
    }
    printOutput("lastNameError",lastNameError);


    if(gender.trim().length==0)
    {
        genderError = "Please enter the gender";
    }
    printOutput("genderError",genderError);

    if(role.trim().length==0 )
    {
        roleError = "Please enter the role";
    }
    printOutput("roleError",roleError);

    if(dateOfBirth.trim().length==0)
    {
        dateOfBirthError = "Please enter the DOB";
    }
    printOutput("dateOfBirthError",dateOfBirthError);

    if(address.trim().length==0)
    {
        addressError = "Please enter the address";
    }
    printOutput("addressError",addressError);

    if(streetName.trim().length==0)
    {
        streetNameError = "Please enter the street name";
    }
    printOutput("streetNameError",streetNameError);

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
    printOutput("pincodeError",pincodeError);

    if(district.trim().length==0)
    {
        districtError = "Please enter the district";
    }
    printOutput("districtError",districtError);

    if(state.trim().length==0)
    {
        stateError = "Please enter the state";
    }
    printOutput("stateError",stateError);

    if(country.trim().length==0)
    {
        countryError = "Please enter the country";
    }
    printOutput("countryError",countryError);

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
    printOutput("phoneNumberError",phoneNumberError);


    if(!profileImage || allowedExtentions.includes(fileExtension))
    {
        profileImageError = "";
    }
    else
    {
        profileImageError = "Only JPG,JPEG and PNG files are allowed";
    }
    printOutput("profileImageError",profileImageError);

    if(email.trim().length==0)
    {
        emailError = "Please enter the email";
    }
    else if(email_match.test(email)!=true) {
        emailError = "Please enter a valid email";
    }
    printOutput("emailError",emailError);

    if(emailError == "" || phoneNumberError == "") {
        $.ajax({
            type:"POST",
            url:"./components/addressBook.cfc?method=checkEmailAndNumberExist",
            data: {email:email,phoneNumber:phoneNumber,contactId:submitButtonId},
            success: function(result) {
                resultJson=JSON.parse(result);
                if(resultJson.phoneSuccess && resultJson.emailSuccess) {
                    document.getElementById("modalFormSubmitButton").type="submit";
                }
                else {
                    document.getElementById("modalFormSubmitButton").type="button";
                    if(resultJson.emailError){
                        printOutput("emailError",resultJson.emailError);
                        alert(resultJson.emailError);
                    }
                    else if(resultJson.phoneError)
                        alert(resultJson.phoneError);
                    if(resultJson.phoneError)
                        printOutput("phoneNumberError",resultJson.phoneError);
                }
            },
            error:function() {
                printOutput("emailError","Error occured");
                printOutput("phoneNumberError","Error occured");
                document.getElementById("modalFormSubmitButton").type="button";
            }
        });
    }
    
    if( titleError  != "" ||
        firstNameError  != "" ||
        lastNameError  != "" ||
        genderError  != "" ||
        dateOfBirthError  != "" ||
        addressError  != "" ||
        streetNameError != "" ||
        pincodeError != "" ||
        districtError != "" ||
        stateError != "" ||
        countryError != "" ||
        phoneNumberError != "" ||
        emailError != "" ||
        roleError != "" ||
        profileImageError != "")
        {
            event.preventDefault();
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
    var excelUploadError = ""
    const allowedExtentions = ["xlsx","xls"];
    var excelFile = document.getElementById("excelInput").files[0];
    if (excelFile) 
    {
        fileExtension = String(/[^.]+$/.exec(excelFile.name));
        if(allowedExtentions.includes(fileExtension.toLowerCase()))
        {
            const excelformData = new FormData();
            excelformData.append("excelFile",excelFile);
            
            $.ajax({
                type: "POST",
                url: "./components/addressBook.cfc?method=uploadContact",
                data: excelformData,
                processData: false,
                contentType: false,
                success: function(result) {
                    resultJson = JSON.parse(result);
                    alert(result)
                },
                error: function() {
                    printOutput("excelUploadError", "Excel Upload Error");
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
    printOutput("excelUploadError",excelUploadError);

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
    var spreadsheetlink = document.createElement("a");
    spreadsheetlink.setAttribute('download', fileName);
    spreadsheetlink.href = fileUrl;
    document.body.appendChild(spreadsheetlink);
    spreadsheetlink.click();
    spreadsheetlink.remove();
}

function openExcelModal()
{
    document.getElementById("excelModal").classList.remove("display_none");
}
function closeExcelModal()
{
    document.getElementById("excelModal").classList.add("display_none");
    excelUploadError = "";
    printOutput("excelUploadError",excelUploadError);
    $("#excelInput").val("");
}