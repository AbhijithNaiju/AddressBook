function printOutput(printLocation,printValue)
{
	document.getElementById(printLocation).innerHTML = printValue;
}
function signUpValidate(event)
{
    let firstName=document.getElementById("fullName").value;
    let email=document.getElementById("emailId").value;
    let userName=document.getElementById("userName").value;
	let password=document.getElementById("password").value;
	let confirmPassword=document.getElementById("confirmPassword").value;
    let profileImage=document.getElementById("profileImage").value;

	let email_match=/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
	let name_check=/[^a-zA-Z0-9\s]/;
	let match_space=/\s/;
    let allowedExtentions=["jpg","jpeg","png"];

    var firstNameError = "";
    var emailError = "";
    var userNameError = "";
    var passwordError = "";
    var confirmPasswordError = "";
    var profileImageError = "";

    if(firstName.trim().length==0) {
        firstNameError="Please enter your first name";
    }
    else if(name_check.test(firstName)) {
        firstNameError="Name should not contain any special charector";
    }

    printOutput("firstNameError",firstNameError);
    
    if(email.length == 0) {
        emailError = "Please enter the email";
    }
    else if(email_match.test(email)!=true) {
        emailError = "Please enter a valid email";
    }

    printOutput("emailError",emailError);

    if(emailError == "") {
        $.ajax({
            type:"POST",
            url:"./components/addressBook.cfc?method=emailExists",
            data: {email:email},
            success: function(result) {
                if(result) {
                    printOutput("emailError","Email already exists");
                    document.getElementById("submitButton").type="button";
                }
                else {
                    document.getElementById("submitButton").type="submit";
                }
            },
            error:function() {
                printOutput("emailError","Error");
                document.getElementById("submitButton").type="button";
            }
        });
    }

	if(userName.trim().length==0){
		userNameError= "Please enter your user name";
	}
	else if(name_check.test(userName)){
		userNameError = "Name should not contain any special charector";	
	}
	else if(match_space.test(userName)){
		userNameError = "User name should not contain any whitespace";	
	}

    printOutput("userNameError",userNameError);

    if(userNameError == "") {
        $.ajax({
            type:"POST",
            url:"./components/addressBook.cfc?method=userNameExists",
            data: {userName:userName},
            success: function(result) {
                if(result) {
                    printOutput("userNameError","Username already exists");
                    document.getElementById("submitButton").type="button";
                }
                else {
                    document.getElementById("submitButton").type="submit";
                }
            },
            error:function() {
                printOutput("userNameError","Error");
                document.getElementById("submitButton").type="button";
            }
        });
    }
    if(password.trim().length==0){
		passwordError = "Please enter the password";
	}
	else if(match_space.test(password)){
		passwordError = "Password should not contain any whitespace";	
	}
	else if(password.length<8){
		passwordError = "Password must be 8 charectors long";
	}
	else{
		passwordError = "";
	}

    printOutput("passwordError",passwordError);
    
	if(confirmPassword.length==0){
        confirmPasswordError = "Please confirm your password";
	}
	else if(confirmPassword != password){
        confirmPasswordError = "Passwords do not match";
	}
	else{
        confirmPasswordError = "";
	}

    printOutput("confirmPasswordError",confirmPasswordError);

    if(!profileImage)
    {
        profileImageError = "Please enter an image for profile picture";
    }
    else
    {
        fileExtension = String(/[^.]+$/.exec(profileImage));
        fileExtension=fileExtension.toLowerCase()
        if(allowedExtentions.includes(fileExtension))
        {
            profileImageError = "";
        }
        else
        {
            profileImageError = "Only JPG,JPEG and PNG files are allowed";
        }
    }

    printOutput("profileImageError",profileImageError);
    if(firstNameError != "" || emailError != ""|| userNameError != ""|| passwordError != ""|| confirmPasswordError != ""|| profileImageError != ""){
        event.preventDefault();
    }

}
function loginValidate(event)
{
    let userName=document.getElementById("userName").value;
	let password=document.getElementById("password").value;

    var userNameError = "";
    var passwordError = "";

    if(userName.trim().length==0){
		userNameError= "Please enter your user name";
	}
    printOutput("userNameError",userNameError)

    if(password.trim().length==0){
		passwordError= "Please enter your password";
	}
    printOutput("passwordError",passwordError)

    if(passwordError != "" || userNameError != ""){
        event.preventDefault();
    }
}

// if ( window.history.replaceState ) {
//     window.history.replaceState( null, null, window.location.href );
// }