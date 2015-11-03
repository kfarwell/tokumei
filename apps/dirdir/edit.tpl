% if(check_user) {
<div>
% if(~ `{echo $lp | tr -dc '/' | wc -c} 3) echo '<h1>Add Course</h1>'
% if not echo '<h1>Edit Course</h1>'
    <form action="" method="POST">
        <p><div class="input-field">
            <input id="name" type="text" name="name" required="" class="validate" value="%(`{if(~ $#post_arg_name 1) echo -n $post_arg_name}%)">
            <label for="name">Course name</label>
        </div>

        <div class="input-field">
            <select name="type" required="" class="validate">
                <option value="Fine Arts">Fine Arts</option>
                <option value="Other">Other</option>
            </select>
            <label>Type</label>
        </div>

        <div class="input-field">
            <select name="year0" required="" class="validate">
                <option value="4th year">4th year</option>
                <option value="3rd year">3rd year</option>
                <option value="2nd year">2nd year</option>
                <option value="1st year">1st year</option>
                <option value="Grade 12">Grade 12</option>
                <option value="Grade 11">Grade 11</option>
                <option value="Grade 10">Grade 10</option>
                <option value="Grade 9">Grade 9</option>
                <option value="Grade 8">Grade 8</option>
                <option value="Grade 7">Grade 7</option>
                <option value="Grade 6">Grade 6</option>
                <option value="Grade 5">Grade 5</option>
                <option value="Grade 4">Grade 4</option>
                <option value="Grade 3">Grade 3</option>
                <option value="Grade 2">Grade 2</option>
                <option value="Grade 1">Grade 1</option>
                <option value="Other">Other</option>
            </select>
            <select name="year1" required="" class="validate">
                <option value="2015">2015</option>
            </select>
            <label>Year</label>
        </div>

        <div class="input-field" required="" class="validate">
            <input id="school" type="text" name="school" value="%(`{if(~ $#post_arg_school 1) echo -n $post_arg_school}%)">
            <label for="school">School</label>
        </div>

        <div class="input-field" required="" class="validate">
            <input id="teacher" type="text" name="teacher" value="%(`{if(~ $#post_arg_teacher 1) echo -n $post_arg_teacher}%)">
            <label for="teacher">Teacher</label>
        </div>

        <div class="input-field">
            <input id="tags" type="text" name="tags" value="%(`{if(~ $#post_arg_tags 1) echo -n $post_arg_tags}%)">
            <label for="tags">Tags (comma separated)</label>
        </div></p>

        <p><button type="submit" class="btn-large waves-effect waves-light black">Submit</button></p>
    </form>
</div>
% }
% if not {
<div>
    <p>To add a course you need to <a href="/login">login</a> first.</p>
</div>
% }

% nav_tree_ext
