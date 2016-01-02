% postd=`{echo $postf | sed 's/\.txt$//'}^_werc
% postn=`{basename $postf | sed 's/\.txt$//'}

% if(~ $req_path /p/[0-9]*) echo '<br />'
% if(! test -f $postd/spam || ~ $req_path /p/[0-9]*) {
<div class="card">
  <div class="card-content" onclick="window.location='/p/%($postn%)'">
%   sed $postfilter < $postf
  </div>
  <div class="card-action">

    <!-- tags -->
% for(i in `{cat $postd/tags}) {
%   i=`{basename $i}
    <form action="/search" method="post">
      <input name="search" type="hidden" value="%($i%)">
      <input type="submit" value="#%($i%)">
    </form>
% }

    <!-- buttons -->
    <span class="right">
      <!-- date (not actually a button) -->
      <span class="date">
%       ls -l $postf | awk '{print $7 " " $8}'
%       ls -l $postf | awk '{print $9}' | grep [0-9][0-9][0-9][0-9]
      </span>
      <!-- reply -->
% if(! ~ $req_path /p/[0-9]*) {
      <noscript>
        <a href="/p/%($postn%)" title="Reply">
          <i class="mdi mdi-reply"></i>
%         if(test -d $postd/replies) {
          <span style="position: absolute">%(`{ls $postd/replies | wc -l}%)</span>
%         }
        </a>
      </noscript>
      <span class="yesscript">
        <a href="#!" onclick="Materialize.showStaggeredList('#staggered%($postn%)')" class="tooltipped" data-position="top" data-delay="50" data-tooltip="Reply">
          <i class="mdi mdi-reply"></i>
%         if(test -d $postd/replies) {
          <span style="position: absolute">%(`{ls $postd/replies | wc -l}%)</span>
%         }
        </a>
      </span>
% }
      <!-- share -->
      <a href="#sharemodal%($postn%)" class="yesscript tooltipped modal-trigger" data-position="top" data-delay="50" data-tooltip="Share">
        <i class="mdi mdi-share-variant"></i>
      </a>
      <!-- report -->
      <a href="#reportmodal%($postn%)" class="yesscript tooltipped modal-trigger" data-position="top" data-delay="50" data-tooltip="Report">
        <i class="mdi mdi-flag"></i>
      </a>
      <!-- delete -->
      <a href="#deletemodal%($postn%)" class="yesscript tooltipped modal-trigger" data-position="top" data-delay="50" data-tooltip="Delete">
        <i class="mdi mdi-delete"></i>
      </a>
    </span>
  </div>
</div>
% }
% if not {
<div class="card">
  <div class="card-content" onclick="window.location='/p/%($postn%)'">
    This post has been flagged as spam %(`{cat $postd/spam}%) times. <a href="/p/%($postn%)">View anyway</a>.
  </div>
</div>
% }

<!-- replies -->
% if(~ $req_path /p/[0-9]*) {
<ul>
% }
% if not {
<ul id="staggered%($postn%)" class="staggered">
% }
% if(test -d $postd/replies)
%     for(i in `{ls -tr $postd/replies}) {
  <li class="card-panel">
%         sed $postfilter < $i
  </li>
%     }
  <li class="card-panel">
%   postnum=$postn tpl_handler `{get_lib_file bridge/edit.tpl apps/bridge/edit.tpl}
  </li>
</ul>

<!-- share modal -->
% shareurl=https://$SERVER_NAME/p/$postn

% if(~ $req_path /p/[0-9]*) {
<noscript>
  <div class="card-panel">
    <h4>Share</h4>
    <h5><a href="%($shareurl%)">%($shareurl%)</a></h5>
    <div class="collection">
      <a class="collection-item" href="http://twitter.com/home/?status=%($shareurl%)">
        <i class="mdi mdi-twitter"></i>
        <span>Twitter</span>
      </a>
      <a class="collection-item" href="http://www.facebook.com/sharer.php?u=%($shareurl%)">
        <i class="mdi mdi-facebook"></i>
        <span>Facebook</span>
      </a>
      <a class="collection-item" href="https://plus.google.com/share?url=%($shareurl%)">
        <i class="mdi mdi-google-plus"></i>
        <span>Google+</span>
      </a>
      <a class="collection-item" href="https://pinterest.com/pin/create/bookmarklet/?url=%($shareurl%)">
        <i class="mdi mdi-pinterest"></i>
        <span>Pinterest</span>
      </a>
      <a class="collection-item" href="http://www.tumblr.com/share/link?url=%($shareurl%)">
        <i class="mdi mdi-tumblr"></i>
        <span>Tumblr</span>
      </a>
      <a class="collection-item" href="https://vk.com/share.php?url=%($shareurl%)">
        <i class="mdi mdi-vk"></i>
        <span>VK</span>
      </a>
      <a class="collection-item" href="http://www.reddit.com/submit?url=%($shareurl%)">
        <i class="mdi mdi-reddit"></i>
        <span>Reddit</span>
      </a>
    </div>
  </div>
</noscript>
<div id="sharemodal%($postn%)" class="yesscript modal">
  <div class="modal-content">
    <h4>Share</h4>
    <h5><a href="%($shareurl%)">%($shareurl%)</a></h5>
    <p class="break-word">
%     sed $postfilter < $postf
    </p>
    <div class="collection">
      <a class="collection-item" href="http://twitter.com/home/?status=%($shareurl%)">
        <i class="mdi mdi-twitter"></i>
        <span>Twitter</span>
      </a>
      <a class="collection-item" href="http://www.facebook.com/sharer.php?u=%($shareurl%)">
        <i class="mdi mdi-facebook"></i>
        <span>Facebook</span>
      </a>
      <a class="collection-item" href="https://plus.google.com/share?url=%($shareurl%)">
        <i class="mdi mdi-google-plus"></i>
        <span>Google+</span>
      </a>
      <a class="collection-item" href="https://pinterest.com/pin/create/bookmarklet/?url=%($shareurl%)">
        <i class="mdi mdi-pinterest"></i>
        <span>Pinterest</span>
      </a>
      <a class="collection-item" href="http://www.tumblr.com/share/link?url=%($shareurl%)">
        <i class="mdi mdi-tumblr"></i>
        <span>Tumblr</span>
      </a>
      <a class="collection-item" href="https://vk.com/share.php?url=%($shareurl%)">
        <i class="mdi mdi-vk"></i>
        <span>VK</span>
      </a>
      <a class="collection-item" href="http://www.reddit.com/submit?url=%($shareurl%)">
        <i class="mdi mdi-reddit"></i>
        <span>Reddit</span>
      </a>
    </div>
  </div>
  <div class="modal-footer">
    <a href="#!" class="modal-action modal-close waves-effect btn-flat">Close</a>
  </div>
</div>
% }
% if not {
<div id="sharemodal%($postn%)" class="modal">
  <div class="modal-content">
    <h4>Share</h4>
    <h5><a href="%($shareurl%)">%($shareurl%)</a></h5>
    <p class="break-word">
%     sed $postfilter < $postf
    </p>
    <div class="collection">
      <a class="collection-item" href="http://twitter.com/home/?status=%($shareurl%)">
        <i class="mdi mdi-twitter"></i>
        <span>Twitter</span>
      </a>
      <a class="collection-item" href="http://www.facebook.com/sharer.php?u=%($shareurl%)">
        <i class="mdi mdi-facebook"></i>
        <span>Facebook</span>
      </a>
      <a class="collection-item" href="https://plus.google.com/share?url=%($shareurl%)">
        <i class="mdi mdi-google-plus"></i>
        <span>Google+</span>
      </a>
      <a class="collection-item" href="https://pinterest.com/pin/create/bookmarklet/?url=%($shareurl%)">
        <i class="mdi mdi-pinterest"></i>
        <span>Pinterest</span>
      </a>
      <a class="collection-item" href="http://www.tumblr.com/share/link?url=%($shareurl%)">
        <i class="mdi mdi-tumblr"></i>
        <span>Tumblr</span>
      </a>
      <a class="collection-item" href="https://vk.com/share.php?url=%($shareurl%)">
        <i class="mdi mdi-vk"></i>
        <span>VK</span>
      </a>
      <a class="collection-item" href="http://www.reddit.com/submit?url=%($shareurl%)">
        <i class="mdi mdi-reddit"></i>
        <span>Reddit</span>
      </a>
    </div>
  </div>
  <div class="modal-footer">
    <a href="#!" class="modal-action modal-close waves-effect btn-flat">Close</a>
  </div>
</div>
% }

<!-- report modal -->
% if(~ $req_path /p/[0-9]*) {
<noscript>
  <div class="card-panel">
    <h4>Report</h4>
    <div class="collection">
      <form action="" method="post">
        <input name="spam" type="hidden" value="%($postn%)">
        <button type="submit" class="collection-item fakelinkcollection">
          <i class="mdi mdi-delete"></i>
          <span>Spam</span>
        </button>
      </form>
      <a class="collection-item" href="mailto:takedowns@tokumei.co?subject=%($shareurl%)">
        <i class="mdi mdi-gavel"></i>
        <span>Illegal content</span>
      </a>
    </div>
  </div>
</noscript>
<div id="reportmodal%($postn%)" class="yesscript modal">
  <div class="modal-content">
    <h4>Report</h4>
    <h5><a href="%($shareurl%)">%($shareurl%)</a></h5>
    <p class="break-word">
%     sed $postfilter < $postf
    </p>
    <div class="collection">
      <form action="" method="post">
        <input name="spam" type="hidden" value="%($postn%)">
        <button type="submit" class="collection-item fakelinkcollection">
          <i class="mdi mdi-delete"></i>
          <span>Spam</span>
        </button>
      </form>
      <a class="collection-item" href="mailto:takedowns@tokumei.co?subject=%($shareurl%)">
        <i class="mdi mdi-gavel"></i>
        <span>Illegal content</span>
      </a>
    </div>
  </div>
  <div class="modal-footer">
    <a href="#!" class="modal-action modal-close waves-effect btn-flat">Close</a>
  </div>
</div>
% }
% if not {
<div id="reportmodal%($postn%)" class="modal">
  <div class="modal-content">
    <h4>Report</h4>
    <h5><a href="%($shareurl%)">%($shareurl%)</a></h5>
    <p class="break-word">
%     sed $postfilter < $postf
    </p>
    <div class="collection">
      <form action="" method="post">
        <input name="spam" type="hidden" value="%($postn%)">
        <button type="submit" class="collection-item fakelinkcollection">
          <i class="mdi mdi-delete"></i>
          <span>Spam</span>
        </button>
      </form>
      <a class="collection-item" href="mailto:takedowns@tokumei.co?subject=%($shareurl%)">
        <i class="mdi mdi-gavel"></i>
        <span>Illegal content</span>
      </a>
    </div>
  </div>
  <div class="modal-footer">
    <a href="#!" class="modal-action modal-close waves-effect btn-flat">Close</a>
  </div>
</div>
% }

<!-- delete modal -->
% if(~ $req_path /p/[0-9]*) {
<noscript>
  <div class="card-panel">
      <h4>Delete</h4>
      <h5>If you wrote this post and set a password when you did, enter it below. If not, you're out of luck.</h5>
      <p class="break-word">
%       sed $postfilter < $postf
      </p>
      <form action="" method="post">
        <input type="hidden" name="postn" value="%($postn%)">
        <br /><div class="input-field">
          <input type="password" name="delete" id="delete%($postn%)">
          <label for="delete%($postn%)">Deletion password</label>
        </div>
        <button type="submit" class="btn-large waves-effect waves-light pink">Delete</button>
      </form>
  </div>
</noscript>
<div id="deletemodal%($postn%)" class="yesscript modal">
  <form action="" method="post">
    <input type="hidden" name="postn" value="%($postn%)">
    <div class="modal-content">
      <h4>Delete</h4>
      <h5>If you wrote this post and set a password when you did, enter it below. If not, you're out of luck.</h5>
      <p class="break-word">
%       sed $postfilter < $postf
      </p>
      <br /><div class="input-field">
        <input type="password" name="delete" id="delete%($postn%)">
        <label for="delete%($postn%)">Deletion password</label>
      </div>
    </div>
    <div class="modal-footer">
      <button type="submit" class="modal-action waves-effect btn-flat">Delete</button>
    </div>
  </form>
</div>
% }
% if not {
<div id="deletemodal%($postn%)" class="yesscript modal">
  <form action="" method="post">
    <input type="hidden" name="postn" value="%($postn%)">
    <div class="modal-content">
      <h4>Delete</h4>
      <h5>If you wrote this post and set a password when you did, enter it below. If not, you're out of luck.</h5>
      <p class="break-word">
%       sed $postfilter < $postf
      </p>
      <br /><div class="input-field">
        <input type="password" name="delete" id="delete%($postn%)">
        <label for="delete%($postn%)">Deletion password</label>
      </div>
    </div>
    <div class="modal-footer">
      <button type="submit" class="modal-action waves-effect btn-flat">Delete</button>
    </div>
  </form>
</div>
% }
