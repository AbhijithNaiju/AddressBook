
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="./style/index.css">
        <link rel="stylesheet" href="./style/bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <title>Login</title>
    </head>
    <body>
        <main class="main">
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
            <div class="main_body">
                <div class="form_container">
                    <div class="form_left">
                        <img src="./Assets/images/contact_book_logo.png" alt="Image not found">
                    </div>
                    <form method="post" class="form_right">
                        <div class="form_heading">
                            LOGIN
                        </div>
                        <input type="text" placeholder="Username" name = "userName" class="input_fields" id="userName">
                        <div id="userNameError" class="error_message"></div>

                        <input type="password" placeholder="Password" name="password" class="input_fields" id="password">                    
                        <div id="passwordError" class="error_message"></div>

                        <input type="submit" onclick="loginValidate(event)" class="submit_btn" name="loginButton" value="LOGIN">


                        <div class="sign_options">
                            <span >
                                Or Sign in Using
                            </span>
                            <div>
                                <a href><img src="./Assets/images/facebook.png" alt="Image not found"></a>
                                <a href=""><img src="./Assets/images/Google.png" alt="Image not found"></a>
                            </div>
                        </div>
                        <div class="register_link">
                            Don't have an account? <a href="signup.cfm">Register here</a> 
                        </div>
                        <cfif structKeyExists(form, "loginButton")>
                            <cfset local.myObject = createObject("component","components.addressBook")>
                            <cfset local.result = local.myObject.userLogin(form.userName,form.password)>
                            <cfif structKeyExists(local.result,"error")> 
                                <cfoutput>
                                    <div class = "text-center text-danger" >#local.result["error"]#</div>
                                </cfoutput>
                            </cfif>
                        </cfif>
                    </form>
                </div>
            </div>
        </main>
        <script src="./JS/index.js"></script>
    </body>
</html>