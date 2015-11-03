% dir=etc/users/`{basename $req_path}

% check_user
% if(~ $logged_user `{basename $req_path}) {
<p><form method="POST" action=""><button name="logout" value="yes" class="btn-large waves-effect waves-light black">Logout</button></form></p>
% }

<h1>%(`{basename $req_path}%)'s Profile</h1>

%{
echo '<h4>'
cat $dir/school
echo '</h4>'

echo '<h5>'
cat $dir/courses | tr -d $NEW_LINE
echo '</h5>'

echo '<p>'
cat $dir/bio
echo '</p>'

echo '<ul>'
cat $dir/work
echo '</ul>'
%}

% if(~ $logged_user `{basename $req_path}) {
<h2>Edit Profile</h2>
<form action="" method="POST">
    <div class="input-field">
        <input type="email" name="profile_email" id="email" required="" class="validate" value="%(`{cat etc/users/$logged_user/email}%)">
        <label for="email">E-mail</label>
    </div>

    <div class="input-field">
        <input type="text" name="profile_school" id="school" value="%(`{cat etc/users/$logged_user/school}%)">
        <label for="school">School (optional)</label>
    </div>

    <div class="input-field">
        <textarea name="profile_courses" id="courses" placeholder="Fine 202a | Painting, Fine 274 | Figure & Anatomy, Fine 220 | Oil Painting, Fine 222 | Principles of Sculpture" class="materialize-textarea">%(`{cat etc/users/$logged_user/courses.md}%)</textarea>
        <label for="courses">Courses (optional)</label>
    </div>

    <div class="input-field">
        <textarea name="profile_bio" id="bio" class="materialize-textarea">%(`{cat etc/users/$logged_user/bio.md}%)</textarea>
        <label for="bio">Bio (optional)</label>
    </div>

    <div class="input-field">
        <input type="password" name="profile_passwdold" id="passwdold" required="" class="validate" value="">
        <label for="passwdold">Old password</label>
    </div>

    <div class="input-field">
        <input type="password" name="profile_passwd" id="passwd" value="">
        <label for="passwd">New password (optional)</label>
    </div>

    <div class="input-field">
        <input type="password" name="profile_passwd2" id="passwd2" value="">
        <label for="passwd2">Repeat new password (optional)</label>
    </div>

    <p><button type="submit" name="profile_submit" class="btn-large waves-effect waves-light black">Submit</button></p>
</form>
% }
