
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="./style/index.css">
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
                <a href="./signup.html">
                    <img src="./Assets/images/user_icon.png" alt="Image not found">
                    Sign Up
                </a>
                <a href="./login.html">
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
                    <input type="text" placeholder="Username" class="input_fields">
                    <input type="text" placeholder="Password" class="input_fields">
                    <input type="submit" class="submit_btn" value="LOGIN">

                    <cfif>
                        
                    </cfif>
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
                        Don't have an account? <a href="signup.html">Register here</a> 
                    </div>
                </form>
            </div>
        </div>
    </main>
    <script src="./JS/index.js"></script>
</body>
</html>