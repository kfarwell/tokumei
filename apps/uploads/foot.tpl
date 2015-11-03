% notices_handler
<form action="/api.php?d=upload" method="post" enctype="multipart/form-data">
    <h2>Upload your work</h2>

    <input type="hidden" name="MAX_FILE_SIZE" value="150000000" />
    <p><div class="input-field file-field">
        <div class="btn black"><span>File</span><input type="file" name="file" id="file" /></div>
        <div class="file-path-wrapper"><input disabled class="file-path" type="text" spellcheck="false"></div>
    </div></p>

    <input type="hidden" name="user" value="%(`{get_cookie werc_user | sed 's/:.*//'}%)" />
    <input type="hidden" name="course" value="%(`{basename $local_path}%)" />
    <p><button type="submit" class="btn-large waves-effect waves-light black">Submit</button></p>
</form>
