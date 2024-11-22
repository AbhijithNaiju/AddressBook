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

    if(emailError == "" || userNameError == "") {
        $.ajax({
            type:"POST",
            url:"./components/addressBook.cfc?method=emailAndUNameCheck",
            data: {email:email,userName:userName},
            success: function(result) {
                resultJson=JSON.parse(result);
                if(resultJson.phoneSuccess && resultJson.emailSuccess) {
                    // document.getElementById("submitButton").type="submit";
                    alert(submit)
                }
                else {
                    document.getElementById("submitButton").type="button";
                    event.preventDefault();
                    alert("test");
                    if(resultJson.emailError){
                        printOutput("emailError",resultJson.emailError);
                    }if(resultJson.userNameError){
                        printOutput("userNameError",resultJson.userNameError);
                    }
                }
            },
            error:function() {
                printOutput("emailError","Error occured");
                printOutput("userNameError","Error occured");
                document.getElementById("submitButton").type="button";
            }
        });
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