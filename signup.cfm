
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
        <div class="main_body signup_padding">
            <div class="form_container">
                <div class="form_left">
                    <img src="./Assets/images/contact_book_logo.png" alt="Image not found">
                </div>
                <div class="form_right">
                    <div class="form_heading">
                        SIGN UP
                    </div>
                    <input type="text" placeholder="Full Name" class="input_fields" name="fullName" id="fullName">
                    <input type="text" placeholder="Email ID" class="input_fields" name="emailId" id="emailId">
                    <input type="text" placeholder="Username" class="input_fields" name="userName" id="userName">
                    <input type="text" placeholder="Password" class="input_fields" name="password" id="password">
                    <input type="text" placeholder="Confirm Password" class="input_fields" id="confirmPassword">
                    <div class="form-group">
                        <label for="profileImage" class="profile_image_label">Choose profile image</label>
                        <input type="file" class="profile_image form-control" name="profileImage" id="profileImage" >
                    </div>
                    <input type="submit" class="submit_btn" value="REGISTER">
                    <div class="register_link">
                        Already have an account? <a href="login.html">Register here</a> 
                    </div>
                </div>
            </div>
        </div>
    </main>
    <script src="./JS/index.js"></script>
</body>
</html>