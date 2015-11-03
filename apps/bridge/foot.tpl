% notices_handler
<form action="" method="post">
    <h2>Leave a comment</h2>
    <p><div class="input-field"><textarea name="comment_text" id="comment_text" class="materialize-textarea">%($"saved_comment_text%)</textarea></div></p>

% if(! check_user) {
%   if(~ $#allow_new_user_comments 1) {
    <label>New user name:
        <input type="text" name="comment_user" value="%($"post_arg_comment_user%)">
    </label>

    <label>Password:
        <input type="password" name="comment_passwd" value="">
    </label>

    <label>Repeat password:
        <input type="password" name="comment_passwd2" value="">
    </label>
    <div style="font-size: 70%">
    Enter your desired user name/password and after your comment has been reviewed by an admin it will be posted and your account will be enabled. If you are already registered please <a href="/login">login</a> before posting.
    </div>
%   }
%   if not if(~ $#bridge_anon_comments 1) {
    <p><label><b>Captcha:</b> Is <a href="http://glenda.cat-v.org">Glenda</a> a cute bunny?
        <select name='ima_robot'>
            <option value="yes">No</option>
            <option value="not">Yes</option>
            <option value="foobar">I hate bunnies!</option>
            <option value="robot">I'm a robot!</option>
        </select>
    </label></p>
%   }
% }
    <p><button type="submit" name="bridge_post" value="submit" class="btn-large waves-effect waves-light black">Submit</button></p>
</form>

% if(! ~ $"post_arg_bridge_preview '') {
            <h2>Preview:</h2>
            <div id="preview">
%               echo $post_arg_comment_text | $formatter
            </div>
% }

<pre>
% #env | escape_html
</pre>
