% postd=`{echo $postf | sed 's/\.txt$//'}^_werc
% postn=`{basename $postf | sed 's/\.txt$//'}

<div class="card">
  <a href="/p/%($postn%)">
    <div class="card-content">
%     cat $postf | sed $postfilter
    </div>
  </a>
  <div class="card-action">

    <!-- tags -->
% for(i in `{ls $postd/tags}) {
%   i=`{basename $i}
    <form action="/search" method="post">
      <input name="search" type="hidden" value="%($i%)">
      <input type="submit" value="#%($i%)">
    </form>
% }

    <!-- buttons -->
    <span class="right">
      <!-- reply -->
      <a href="#!" onclick="Materialize.showStaggeredList('#staggered%($postn%)')" class="tooltipped" data-position="top" data-delay="50" data-tooltip="Reply">
        <i class="mdi mdi-reply"></i>
%       if(test -d $postd/replies) {
        <span style="position: absolute">%(`{ls $postd/replies | wc -l}%)</span>
%       }
      </a>
      <!-- share -->
      <a href="#modal%($postn%)" class="tooltipped modal-trigger" data-position="top" data-delay="50" data-tooltip="Share">
        <i class="mdi mdi-share-variant"></i>
      </a>
    </span>
  </div>
</div>

<!-- share modal -->
<div id="modal%($postn%)" class="modal">
  <div class="modal-content">
    <h4>Share</h4>
    <p class="break-word">
%     cat $postf | sed $postfilter
    </p>
    <div class="collection">
%     shareurl=$base_url/p/$postn
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
        <span>VK
      </a>
    </div>
  </div>
  <div class="modal-footer">
    <a href="#!" class=" modal-action modal-close waves-effect waves-pink btn-flat">Close</a>
  </div>
</div>

<!-- replies -->
<ul id="staggered%($postn%)" class="staggered">
% if(test -d $postd/replies)
%     for(i in `{ls $postd/replies}) {
  <li class="card-panel">
%       cat $i | sed 's,$,<br />,'
  </li>
%     }
  <li class="card-panel">
%   postnum=$postn tpl_handler `{get_lib_file bridge/edit.tpl apps/bridge/edit.tpl}
  </li>
</ul>
