function signUpValidate(event)
{
    let firstName = $("#fullName").val();
    let email = $("#emailId").val();
    let userName = $("#userName").val();
    let profileImage = $("#profileImage").val();
    console.log(firstName)
	const email_match = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
	const name_check = /[^a-zA-Z0-9\s]/;
	const match_space = /\s/;
    let allowedExtentions = ["jpg","jpeg","png"];

    let firstNameError = "";
    let emailError = "";
    let userNameError = "";
    let profileImageError = "";

    if(firstName.trim().length==0) {
        firstNameError="Please enter your first name";
    }
    else if(name_check.test(firstName)) {
        firstNameError="Name should not contain any special charector";
    }
    $("#firstNameError").text(firstNameError);
    
    if(email.length == 0) {
        emailError = "Please enter the email";
    }
    else if(email_match.test(email)!=true) {
        emailError = "Please enter a valid email";
    }
    $("#emailError").text(emailError);

	if(userName.trim().length==0){
		userNameError= "Please enter your user name";
	}
	else if(name_check.test(userName)){
		userNameError = "Name should not contain any special charector";	
	}
	else if(match_space.test(userName)){
		userNameError = "User name should not contain any whitespace";	
	}
    $("#userNameError").text(userNameError);

    if(!profileImage)
    {
        profileImageError = "Please upload profile picture";
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
    $("#profileImageError").text(profileImageError);

    if(checkPassword() == false ||
        firstNameError != "" ||
        emailError != ""|| 
        userNameError != ""|| 
        passwordError != ""|| 
        confirmPasswordError != ""|| 
        profileImageError != "" )
    {
        event.preventDefault();
    }
    else
    {
        const formData = new FormData();

        formData.append("fullName", firstName);
        formData.append("emailId", email);
        formData.append("userName", userName);
        formData.append("password", password);

        const profileImage = document.getElementById("profileImage").files[0];
        if (profileImage) {
            formData.append("profileImage", profileImage);
        }

        $.ajax({
            type: "POST",
            url: "./components/addressBook.cfc?method=userSignup",
            data: formData,
            processData: false,
            contentType: false,
            success: function(result) {
                resultJson = JSON.parse(result);
                if (resultJson.userNameSuccess && resultJson.emailSuccess) {
                    $("#emailError").text("");
                    $("#userNameError").text(userNameError);
                    location.href = "../home.cfm"
                }
                else if(resultJson.Error)
                {
                    $("#signupError").text(resultJson.Error);
                }
                else {
                    if (resultJson.emailError) {
                        $("#emailError").text(resultJson.emailError);
                    }
                    if (resultJson.userNameError) {
                        $("#userNameError").text(resultJson.userNameError);
                    }
                }
            },
            error: function() {
                $("#signupError").text(Error);
            }
        });

    }

}
function checkPassword()
{
    let confirmPassword=$("#confirmPassword").val();
    let password=$("#password").val();

    const passwordMatchSpecial=/[^a-zA-Z0-9]/;
	const match_space=/\s/;
	const passwordMatchDigit=/[0-9]/;
    let passwordError = ""
    let confirmPasswordError = ""

    if(password.trim().length==0){
		passwordError = "Please enter the password";
	}
	else if(match_space.test(password)){
		passwordError = "Password should not contain any whitespace";	
	}
	else if(password.length<8){
		passwordError = "Password must be 8 charectors long";
	}
	else if(!passwordMatchSpecial.test(password))
    {
        passwordError = "Password must contain 1 special charector";	
    }
    else if(!passwordMatchDigit.test(password))
    {
        passwordError = "Password must contain 1 digit";	
    }
    else
    {
        passwordError = "";
    }
    $("#passwordError").text(passwordError);
    
    if(confirmPassword.length==0){
        confirmPasswordError = "Please confirm your password";
	}
	else if(confirmPassword != password){
        confirmPasswordError = "Passwords do not match";
	}
	else
    {
        confirmPasswordError = "";
    }

    $("#confirmPasswordError").text(confirmPasswordError);
    
    if(confirmPasswordError != "" || passwordError != "")
        return false;
    else
        return true;
}
function loginValidate(event)
{
    let userName=$("#userName").val();
    let password=$("#password").val();


    let userNameError = "";
    let passwordError = "";

    if(userName.trim().length==0){
		userNameError= "Please enter your user name";
	}
    $("#userNameError").text(userNameError);

    if(password.trim().length==0){
		passwordError= "Please enter your password";
	}
    $("#passwordError").text(passwordError);

    if(passwordError != "" || userNameError != ""){
        event.preventDefault();
    }
}

// if ( window.history.replaceState ) {
//     window.history.replaceState( null, null, window.location.href );
// }