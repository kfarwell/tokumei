<h1>Log In</h1>
% if(check_user) {
    You are logged in as: <b>%($logged_user%)</b>
    <p><form method="POST" action=""><button name="logout" value="yes" class="btn-large waves-effect waves-light black">Logout</button></form></p>
% }
% if not {
%    if (~ $REQUEST_METHOD POST)
%        echo '<div class="notify_errors">Login failed!</div>'
<form method="POST" action="">
    <div class="input-field">
        <input type="text" id="name" name="user_name" value="%($"post_arg_user_name%)"/>
        <label for="name">Username</label>
    </div>
    <div class="input-field">
        <input type="password" id="password" name="user_password">
        <label for="password">Password</label>
    </div>
    <button name="s" type="submit" class="btn-large waves-effect waves-light black">Login</button>
</form>
<p><a href="/register" class="waves-effect waves-dark btn-flat">Register</a></p>
% }

<br style="clear:left">
