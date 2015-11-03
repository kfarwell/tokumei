<h1>Register an account</h1>

% if(! check_user) {
    <form action="" method="POST">
        <div class="input-field">
            <input type="text" name="register_user" id="user" required="" class="validate" value="%($"post_arg_register_user%)">
            <label for="user">Username</label>
        </div>
    
        <div class="input-field">
            <input type="email" name="register_email" id="email" required="" class="validate" value="%($"post_arg_register_email%)">
            <label for="email">E-mail</label>
        </div>
    
        <div class="input-field">
            <input type="text" name="register_school" id="school" value="%($"post_arg_register_school%)">
            <label for="school">School (optional)</label>
        </div>
    
        <div class="input-field">
            <textarea name="register_courses" id="courses" placeholder="Fine 202a | Painting, Fine 274 | Figure & Anatomy, Fine 220 | Oil Painting, Fine 222 | Principles of Sculpture" class="materialize-textarea">%($"post_arg_register_courses%)</textarea>
            <label for="courses">Courses (optional)</label>
        </div>
    
        <div class="input-field">
            <textarea name="register_bio" id="bio" class="materialize-textarea">%($"post_arg_register_bio%)</textarea>
            <label for="bio">Bio (optional)</label>
        </div>

        <div class="input-field">
            <input type="password" name="register_passwd" id="passwd" required="" class="validate" value="">
            <label for="passwd">Password</label>
        </div>
    
        <div class="input-field">
            <input type="password" name="register_passwd2" id="passwd2" required="" class="validate" value="">
            <label for="passwd2">Repeat password</label>
        </div>
    
        <p><button type="submit" name="register_submit" class="btn-large waves-effect waves-light black">Submit</button></p>
    </form>

    <p><a href="/login" class="waves-effect waves-dark btn-flat">Login</a></p>
% }
% if not {
    You are logged in as: <b>%($logged_user%)</b>
    <p><form method="POST" action=""><button name="logout" value="yes" class="btn-large waves-effect waves-light black">Logout</button></form></p>
% }
