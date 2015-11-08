<div>
    <form action="" method="POST">
        <div class="input-field">
            <textarea name="comment" id="comment" class="materialize-textarea validate" required="" length="140" maxlength="140"></textarea>
            <label for="comment">Message</label>
        </div>

        <div class="input-field">
            <input type="text" name="tags" id="tags">
            <label for="tags">Tags (case sensitive, space separated)</label>
        </div></p>

        <div class="input-field file-field">
            <div class="btn pink">
                <span>File</span>
                <input type="file">
            </div>
            <div class="file-path-wrapper">
                <input class="file-path validate" type="text" placeholder="(optional)">
            </div>
        </div>

        <button type="submit" class="btn-large waves-effect waves-light pink">Post<i class="mdi mdi-send right"></i></button>
    </form>
</div>