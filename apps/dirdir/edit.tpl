% if(~ $#dirdir_users_only 0 || check_user $groups_allowed_posts) {
<noscript>
  <div>
    <form action="" method="POST">
      <div class="input-field">
        <textarea name="comment" id="comment" class="materialize-textarea validate" required="" length="%($charlimit%)" maxlength="%($charlimit%)"></textarea>
        <label for="comment">Message</label>
      </div>

      <div class="input-field">
        <input type="text" name="tags" id="tags">
        <label for="tags">Tags (comma separated)</label>
      </div>

      <!-- <div class="input-field file-field">
        <div class="btn pink">
          <span>File</span>
          <input type="file">
        </div>
        <div class="file-path-wrapper">
          <input class="file-path validate" type="text">
        </div>
      </div> -->

      <div class="input-field">
        <input type="text" placeholder="https://example.com/image.png" name="file" id="file">
        <label for="file">Attachment</label>
      </div>

      <div class="input-field">
        <input type="password" name="password" id="password">
        <label for="password">Deletion password</label>
      </div>

      <button type="submit" class="btn-large waves-effect waves-light pink">Post<i class="mdi mdi-send right"></i></button>
    </form>
  </div>
  <br />
</noscript>

<div id="modalpost" class="yesscript modal">
  <form action="" method="POST">
    <div class="modal-content">
      <div class="input-field">
        <textarea name="comment" id="comment" class="materialize-textarea validate" required="" length="%($charlimit%)" maxlength="%($charlimit%)"></textarea>
        <label for="comment">Message</label>
      </div>

      <div class="input-field">
        <input type="text" name="tags" id="tags" oninput="renderTags()">
        <label for="tags">Tags (comma separated)</label>
      </div>
      <div id="tag-preview"></div>

      <script type="text/javascript">
        function renderTags() {
          $('#tag-preview').empty();
          var tags=$('#tags').val().split(',');
          for(i = 0; i < tags.length; i++) {
            if (/\S/.test(tags[i])) {
              $('#tag-preview').append('<div class="chip pink lighten-4" style="margin-right:0.2em">' + tags[i] + '</div>');
            }
          }
        }

        function toggleAdvanced() {
          if(advanced.style.display == "initial") {
            advanced.style.display = "none";
            advancedArrow.className = "mdi mdi-chevron-down";
          } else {
            advanced.style.display = "initial";
            advancedArrow.className = "mdi mdi-chevron-up";
          }
        }
      </script>
      <br /><a onclick="toggleAdvanced()" class="waves-effect btn-flat" style="padding: 0 0.75rem">Advanced <i class="mdi mdi-chevron-down" id="advancedArrow"></i></a>
      <div id="advanced">
        <!-- <div class="input-field file-field">
          <div class="btn pink">
            <span>File</span>
            <input type="file">
          </div>
          <div class="file-path-wrapper">
            <input class="file-path validate" type="text">
          </div>
        </div> -->

        <br /><br />
        <div class="input-field">
          <input type="text" placeholder="https://example.com/image.png" name="file" id="file">
          <label for="file">Attachment</label>
        </div>

        <div class="input-field">
          <input type="password" name="password" id="password">
          <label for="password">Deletion password</label>
        </div>
      </div>
    </div>
    <div class="modal-footer">
      <button type="submit" class="modal-action waves-effect btn-flat">Post</button>
    </div>
  </form>
</div>

<div class="yesscript fixed-action-btn" style="bottom: 24px; right: 24px;">
  <a href="#modalpost" class="modal-trigger btn-floating btn-large pink tooltipped" data-position="left" data-delay="50" data-tooltip="Post something!">
    <i class="mdi mdi-pencil white-text"></i>
  </a>
</div>
% }
