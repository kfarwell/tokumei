% if(~ $#dirdir_users_only 0 || check_user $groups_allowed_posts) {
<noscript>
  <div>
    <form action="" method="POST">
      <div class="input-field">
        <textarea name="comment" id="comment" class="materialize-textarea validate" required="" length="140" maxlength="140"></textarea>
        <label for="comment">Message</label>
      </div>

      <div class="input-field">
        <input type="text" name="tags" id="tags">
        <label for="tags">Tags (space separated)</label>
      </div>

      <!-- <div class="input-field file-field">
        <div class="btn pink">
          <span>File</span>
          <input type="file">
        </div>
        <div class="file-path-wrapper">
          <input class="file-path validate" type="text" placeholder="(optional)">
        </div>
      </div> -->

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
        <textarea name="comment" id="comment" class="materialize-textarea validate" required="" length="140" maxlength="140"></textarea>
        <label for="comment">Message</label>
      </div>

      <div class="input-field">
        <input type="text" name="tags" id="tags">
        <label for="tags">Tags (space separated)</label>
      </div>

      <script>
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
            <input class="file-path validate" type="text" placeholder="(optional)">
          </div>
        </div> -->

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
