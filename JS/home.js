function printOutput(printLocation,printValue)
{
	document.getElementById(printLocation).innerHTML = printValue;
}
function openEditModal(editId)
{
    if(editId.value == "")
    {
        document.getElementById("modalFormSubmitButton").name="addContact";
        document.getElementById("modalHeading").innerHTML="CREATE CONTACT";
        document.getElementById("createForm").reset();
        document.getElementById("profileImageEdit").src = "./Assets/contactPictues/l60Hf.png";
        document.getElementById("editModal").classList.remove("display_none");
    }
    else
    {
        document.getElementById("modalFormSubmitButton").name="editContact";
        document.getElementById("modalHeading").innerHTML="EDIT CONTACT";
        document.getElementById("editModal").classList.remove("display_none");
        
        $.ajax({
        type:"POST",
        url:"./Components/addressBook.cfc?method=getEditData",
        data:{editId:editId.value},
        success: function(result) {
            if(result)
                {
                    resultJson=JSON.parse(result);
                    $("#title").val(resultJson.title);
                    $("#firstName").val(resultJson.firstName);
                    $("#lastName").val(resultJson.lastName);
                    $("#gender").val(resultJson.gender);
                    $("#dateOfBirth").val(resultJson.dateOfBirth);
                    $("#profileDefault").val(resultJson.profileImage);
                    $("#address").val(resultJson.address);
                    $("#streetName").val(resultJson.streetName);
                    $("#pincode").val(resultJson.pincode);
                    $("#district").val(resultJson.district);
                    $("#state").val(resultJson.state);
                    $("#country").val(resultJson.country);
                    $("#phoneNumber").val(resultJson.phoneNumber);
                    $("#email").val(resultJson.email);
                    document.getElementById("profileImageEdit").src = resultJson.profileImage;
                    
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
        $('.error_message').text('');
}
function openViewModal(viewId)
{
    viewModalBody=document.getElementById("viewModalBody")
    viewModalBody.innerHTML="";
    document.getElementById("viewModal").classList.remove("display_none");
    $.ajax({
        type:"POST",
        url:"./Components/addressBook.cfc?method=getContactData",
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
                        document.getElementById("viewProfileImage").src = resultJson[a];
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

}

function formValidate(event)
{
    let title =  document.getElementById("title").value;
    let firstName =  document.getElementById("firstName").value;
    let lastName =  document.getElementById("lastName").value;
    let gender =  document.getElementById("gender").value;
    let dateOfBirth =  document.getElementById("dateOfBirth").value;
    let address =  document.getElementById("address").value;
    let streetName =  document.getElementById("streetName").value;
    let pincode =  document.getElementById("pincode").value;
    let district =  document.getElementById("district").value;
    let state =  document.getElementById("state").value;
    let country =  document.getElementById("country").value;
    let phoneNumber =  document.getElementById("phoneNumber").value;
    let email =  document.getElementById("email").value;

	let email_match=/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

    let titleError = "";
    let firstNameError = "";
    let lastNameError = "";
    let genderError = "";
    let dateOfBirthError = "";
    let addressError = "";
    let streetNameError = "";
    let pincodeError = "";
    let districtError = "";
    let stateError = "";
    let countryError = "";
    let phoneNumberError = "";
    let emailError = "";

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

    if(email.trim().length==0)
    {
        emailError = "Please enter the email";
    }
    else if(email_match.test(email)!=true) {
        emailError = "Please enter a valid email";
    }
    printOutput("emailError",emailError);

    if(titleError  != "" ||
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
       emailError){
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
                        document.getElementById(deleteId.value).style.display="none";
                    }
                },
                error:function()
                {
                    alert("An error occured")
                }
            });
        }
}