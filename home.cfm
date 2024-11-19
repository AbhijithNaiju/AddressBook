
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="./style/index.css">
    <link rel="stylesheet" href="./style/home_style.css">
    <title>Home</title>
</head>
<body>
    <main class="main position_absolute">
        <div class="header">
            <a href="" class="logo">
                <img src="./Assets/images/contact_book_logo.png" alt="Image not found">
                <span>ADDRESS BOOK</span>
            </a>
            <div class="logout_button">
                <button onclick="logout()">
                    <img src="./Assets/images/logout.png" alt="Image not found">
                    Logout
                </button>
            </div>
        </div>
        <div class="home_body">
            <div class="home_header">
                <div class="print_options">
                    <button><img src="./Assets/images/acrobat.png" alt="Image not found"></button>
                    <button><img src="./Assets/images/excel.png" alt="Image not found"></button>
                    <button><img src="./Assets/images/print.png" alt="Image not found"></button>
                </div>
            </div>
            <div class="home_elements">
                <div class="profile_box">
                    <img src="./Assets/uploads/Screenshot (12).png" alt="image not found">
                    <div class="profile_name">Merlin Richard</div>
                    <button onclick="openModal()">CREATE CONTACT</button>
                </div>
                <div class="contact_list">
                    <div class="contact_list_heading">
                        <div class="list_profile">

                        </div>
                        <div class="list_name">
                            NAME
                        </div>
                        <div class="list_email">
                            EMAIL ID
                        </div>
                        <div class="list_phone">
                            PHONE NUMBER
                        </div>
                        <div class="list_button">
                            
                        </div>
                    </div>
                    <div class="contact_list_item">
                        <div class="list_profile">
                            <img src="./Assets/uploads/Screenshot (12).png" alt="Image not found">
                        </div>
                        <div class="list_name">
                            Anjana S
                        </div>
                        <div class="list_email">
                            anjana@gmail.com
                        </div>
                        <div class="list_phone">
                            9072237076
                        </div>
                        <div class="list_button">
                            <button>EDIT</button>
                            <button>DELETE</button>
                            <button>VIEW</button>
                        </div>
                    </div>
                    <div class="contact_list_item">
                        <div class="list_profile">
                            <img src="./Assets/uploads/Screenshot (12).png" alt="Image not found">
                        </div>
                        <div class="list_name">
                            Anjana S
                        </div>
                        <div class="list_email">
                            anjana@gmail.com
                        </div>
                        <div class="list_phone">
                            9072237076
                        </div>
                        <div class="list_button">
                            <button>EDIT</button>
                            <button>DELETE</button>
                            <button>VIEW</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <div class="edit_modal  " id="myModal">
        <div class="edit_form">
            <form method="post" class="edit_form_body" enctype="multipart/form-data">
                <div class="modal_heading">
                    CREATE CONTACT
                </div>
                <div class="modal_sub_headng">
                    Personal contact
                </div>
                <div class="edit_modal_element">
                    <div class="width_20">
                        <label for="">Title *</label>
                        <select class="form_element">
                            <option value=""></option>
                            <option value="Mr ">Mr</option>
                            <option value="Mrs ">Mrs</option>
                        </select>
                    </div>
                    <div class="width_30">
                        <label for="">First name *</label>
                        <input type="text" placeholder=" First name" class="form_element">
                    </div>
                    <div class="width_30">
                        <label for="">Last name *</label>
                        <input type="text" placeholder=" Last name" class="form_element">
                    </div>
                </div>
                <div class="edit_modal_element">
                    <div class="width_45">
                        <label for="">Gender *</label>
                        <select class="form_element">
                            <option value=""></option>
                            <option value="Mr ">Male</option>
                            <option value="Mrs ">Female</option>
                        </select>
                    </div>
                    <div class="width_45">
                        <label for="">Date of Birth *</label>
                        <input type="date" class="form_element">
                    </div>
                </div>
                <div class="edit_modal_element">
                    <div class="">
                        <label for="">Upload Photo *</label>
                        <input type="file" class="form_element">
                    </div>
                </div>
                <div class="modal_sub_headng">
                    Contact details
                </div>
                <div class="edit_modal_element">
                    <div class="width_45">
                        <label for="">Address *</label>
                        <input type="text" placeholder=" Address" class="form_element">
                    </div>
                    <div class="width_45">
                        <label for="">Street *</label>
                        <input type="text" placeholder=" Street Name" class="form_element">
                    </div>
                </div>
                <div class="edit_modal_element">
                <div class="width_45">
                    <label for="">Pincode *</label>
                        <input type="text" placeholder=" Pincode" class="form_element">
                    </div>
                    <div class="width_45">
                        <label for="">District *</label>
                        <input type="text" placeholder=" District" class="form_element">
                    </div>
                </div>
                <div class="edit_modal_element">
                    <div class="width_45">
                        <label for="">State *</label>
                        <input type="text" placeholder=" State" class="form_element">
                    </div>
                    <div class="width_45">
                        <label for="">Country *</label>
                        <input type="text" placeholder=" Country" class="form_element">
                    </div>
                </div>
                <div class="edit_modal_element">
                    <div class="width_45">
                        <label for="">Phone *</label>
                        <input type="text" placeholder=" Phone" class="form_element">
                    </div>
                    <div class="width_45">
                        <label for="">Email *</label>
                        <input type="text" placeholder="Email" class="form_element">
                    </div>
                </div>
                <div class="modal_buttons">
                    <button onclick="closeModal()" type="button">Cancel</button>
                    <button>Submit</button>
                </div>
            </form>
            <div class="edit_form_image">
                <img src="./Assets/uploads/Screenshot (12).png" alt="Image not found">
            </div>
        </div>
    </div>
    <script src="./JS/Jquery/jquery-3.7.1.js"></script>
    <script src="./JS/home.js"></script>
</body>
</html>