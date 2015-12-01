% postd=`{echo $postf | sed 's/\.txt$//'}^_werc
% postn=`{basename $postf | sed 's/\.txt$//'}

% if(~ $req_path /p/[0-9]*) echo '<br />'
<div class="card">
  <div class="card-content" onclick="window.location='/p/%($postn%)'">
%   cat $postf | sed $postfilter
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
      <a href="#modal%($postn%)" class="yesscript tooltipped modal-trigger" data-position="top" data-delay="50" data-tooltip="Share">
        <i class="mdi mdi-share-variant"></i>
      </a>
    </span>
  </div>
</div>

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
%       cat $i | sed $postfilter
  </li>
%     }
  <li class="card-panel">
%   postnum=$postn tpl_handler `{get_lib_file bridge/edit.tpl apps/bridge/edit.tpl}
  </li>
</ul>

<!-- share modal -->
% shareurl=$base_url/p/$postn

% if(~ $req_path /p/[0-9]*) {
<noscript>
  <div class="card-panel">
    <h4>Share</h4>
    <h5><a href="%($shareurl%)">%($shareurl%)</a></h5>
    <p class="break-word">
%     cat $postf | sed $postfilter
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
</noscript>
<div id="modal%($postn%)" class="yesscript modal">
  <div class="modal-content">
    <h4>Share</h4>
    <h5><a href="%($shareurl%)">%($shareurl%)</a></h5>
    <p class="break-word">
%     cat $postf | sed $postfilter
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
<div id="modal%($postn%)" class="modal">
  <div class="modal-content">
    <h4>Share</h4>
    <h5><a href="%($shareurl%)">%($shareurl%)</a></h5>
    <p class="break-word">
%     cat $postf | sed $postfilter
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


