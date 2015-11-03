<div>
% notices_handler
<form method="POST"><fieldset>
    <legend>Submit a new blog post</legend>
    <textarea cols="94" rows=16" name="body">%($"post_arg_body%)</textarea><br />
    <label>Title: <input size="64" type="text" name="title" value="%($"post_arg_title%)" /></label>
    <label>Id: <input size="8" type="text" name="id" value="%($"post_arg_id%)" /></label>
    <label>Date: <input size="10" maxlength="10" type="text" name="date" value="%($"post_date%)" /></label>
    <input type="submit" value="Post" />
</fieldset></form>
</div>
