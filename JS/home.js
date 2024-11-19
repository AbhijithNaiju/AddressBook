function printOutput(printLocation,printValue)
{
	document.getElementById(printLocation).innerHTML = printValue;
}
function openEditModal()
{
    $("#myModal").removeClass("display_none");
}
function closeEditModal()
{
    $("#myModal").addClass("display_none");
}
function openViewModal()
{
    $("#viewModal").removeClass("display_none");
}
function closeViewModal()
{
    $("#viewModal").addClass("display_none");
}

function formValidate(event)
{
    let title =  document.getElementById("title").value;
    let firstName =  document.getElementById("firstName").value;
    let lastName =  document.getElementById("lastName").value;
    let gender =  document.getElementById("gender").value;
    let dateOfBirth =  document.getElementById("dateOfBirth").value;
    let profileImage =  document.getElementById("profileImage").value;
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
    let profileImageError = "";
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

    if(profileImage.trim().length==0)
    {
        profileImageError = "Please enter the profile image";
    }
    printOutput("profileImageError",profileImageError);

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

    if(titleError  == "" ||
       firstNameError  == "" ||
       lastNameError  == "" ||
       genderError  == "" ||
       dateOfBirthError  == "" ||
       profileImageError  == "" ||
       addressError  == "" ||
       streetNameError == "" ||
       pincodeError == "" ||
       districtError == "" ||
       stateError == "" ||
       countryError == "" ||
       phoneNumberError == "" ||
       emailError){
            event.preventDefault();
        }
}