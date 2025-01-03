<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="./style/index.css">
        <link rel="stylesheet" href="./style/bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <title>Sign UP</title>
    </head>
    <body>
        <div class="header">

            <a href="" class="logo">
                <img src="./Assets/images/contact_book_logo.png" alt="Image not found">
                <span>ADDRESS BOOK</span>
            </a>

            <div class="header_buttons">

                <a href="./signup.cfm">
                    <img src="./Assets/images/user_icon.png" alt="Image not found">
                    Sign Up
                </a>

                <a href="./login.cfm">
                    <img src="./Assets/images/login-2.png" alt="Image not found">
                    Login
                </a>

            </div>
        </div>
        <main class="main">
            <div class="main_body signup_padding">
                <div class="form_container">
                    <div class="form_left">
                        <img src="./Assets/images/contact_book_logo.png" alt="Image not found">
                    </div>
                    <form method="post" class="form_right signup_form" enctype="multipart/form-data">

                        <div class="form_heading">
                            SIGN UP
                        </div>

                        <input type="text" placeholder="Full Name" class="input_fields" name="fullName" id="fullName">
                        <div id="firstNameError" class="error_message"></div>

                        <input type="text" placeholder="Email ID" class="input_fields" name="emailId" id="emailId">
                        <div id="emailError" class="error_message"></div>

                        <input type="text" placeholder="Username" class="input_fields" name="userName" id="userName">
                        <div id="userNameError" class="error_message"></div>

                        <input  type="password'" 
                                placeholder="Password" 
                                class="input_fields" 
                                name="password" 
                                id="password"
                                onkeyup="checkPassword()">
                        <div id="passwordError" class="error_message"></div>

                        <input  type="password" 
                                placeholder="Confirm Password" 
                                class="input_fields" 
                                id="confirmPassword"
                                onkeyup="checkPassword()">
                        <div id="confirmPasswordError" class="error_message"></div>
                        
                        <div class="form-group imageInput">
                            <label for="profileImage" class="profile_image_label">Choose profile image</label>
                            <input type="file" class="profile_image form-control" name="profileImage" id="profileImage" >
                        </div>
                        <div id="profileImageError" class="error_message"></div>

                        <input type="button" onclick="signUpValidate(event)" id = "submitButton" name="submitButton"  class="submit_btn" value="REGISTER">

                        <div class="register_link">
                            Already have an account? <a href="login.cfm">Login</a> 
                        </div>
                        <div class = "text-center text-danger" id="signupError"></div>
                    </form>
                </div>
            </div>
        </main>
        <script src="./JS/Jquery/jquery-3.7.1.js"></script>
        <script src="./JS/index.js"></script>
    </body>
</html>