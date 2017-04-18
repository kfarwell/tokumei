% if(! ~ $#replies_users_only 0 && ! check_user $groups_allowed_replies) {
<style>
  #reply-form {
    display: none;
  }
  #reply-form-disabled {
    display: initial;
  }
  #reply-form-container.hasreplies {
    display: none !important;
  }
</style>
% }

% if(! ~ $req_path /) {
<div class="navbar-fixed">
  <nav class="pink" role="navigation">
    <div class="nav-wrapper container">
      <a id="logo-container" href="/" class="brand-logo white-text left">
        <img src="/img/logo-nav.png" alt="%($siteTitle%)" />
        <span>%($siteTitle%)</span>
      </a>
      <ul class="right">
        <li %(`{if(~ $req_path /p/timeline || ~ $req_path /p/) echo 'class="active"'}%)><a href="/p/timeline" class="tooltipped" data-position="bottom" data-delay="50" data-tooltip="Timeline">
          <i class="mdi mdi-clock"></i>
        </a></li>
        <li %(`{if(~ $req_path /p/trending) echo 'class="active"'}%)><a href="/p/trending" class="tooltipped" data-position="bottom" data-delay="50" data-tooltip="Trending">
          <i class="mdi mdi-fire"></i>
        </a></li>
        <li %(`{if(~ $req_path /p/following) echo 'class="active"'}%)><a href="/p/following" class="tooltipped" data-position="bottom" data-delay="50" data-tooltip="Following">
          <i class="mdi mdi-eye"></i>
        </a></li>

        <li style="margin-left: 2em"><a href="#!" onclick="toggleSearch()" class="tooltipped" data-position="bottom" data-delay="50" data-tooltip="Search">
          <i class="mdi mdi-magnify"></i>
        </a></li>
      </ul>
      <br />
      <div id="search-bar">
        <form action="/search" method="post" class="left" id="search-form">
          <div class="input-field">
            <input id="search" name="search" type="search" placeholder="Search tags..." required>
            <label for="search"><i class="mdi mdi-magnify white-text"></i></label>
          </div>
        </form>
        <div style="height: 64px; overflow: hidden; padding-left: 16px" id="search-tags">
%         for(i in `{cat $sitedir/_werc/trending}) {
          <div class="chip">
            <form action="/search" method="post">
              <input type="submit" name="search" value="%(`{echo $i | sed 's/_/ /g'}%)" class="fakelink">
            </form>
          </div>
%         }
        </div>
      </div>
    </div>
  </nav>
</div>
% }

<div id="main-copy" %(`{if(! ~ $req_path /) echo 'class="container"'}%)>

% run_handlers $handlers_body_head

% run_handler $handler_body_main

% run_handlers $handlers_body_foot

</div>

<footer class="page-footer pink" style="%(`{if(~ $req_path /) echo 'margin-top: 0;'; if(! ~ $"sitePrivate '') echo 'padding-top: 0;'}%)">
% if(~ $"sitePrivate '') {
  <div class="container">
    <div class="row">
      <div class="col l6 s12">
        <p class="grey-text text-lighten-4">All trademarks and copyrights on this page are owned by their respective parties.
        Files uploaded are the responsibility of the Poster.
        Comments are owned by the Poster.</p>
      </div>
      <div class="col l2 offset-l1 s12">
        <ul>
          <li><a class="grey-text text-lighten-3" href="/settings">Settings</a></li>
          <li><a class="grey-text text-lighten-3" href="/privacy">Privacy Policy</a></li>
          <li><a class="grey-text text-lighten-3" href="/rules">Rules</a></li>
          <li><a class="grey-text text-lighten-3" href="/donate">Donate</a></li>
        </ul>
      </div>
      <div class="col l3 s12">
        <ul>
          <li><a class="grey-text text-lighten-3" href="/api">API</a></li>
          <li><a class="grey-text text-lighten-3" href="https://git.tokumei.co/tokumei/tokumei">Source Code</a></li>
          <li><a class="grey-text text-lighten-3" href="/rss">RSS</a></li>
          <li class="grey-text text-lighten-3"><a class="grey-text text-lighten-3" href="/sitemap">Sitemap</a> (<a class="grey-text text-lighten-3" href="/sitemap.gz">XML</a>)</li>
        </ul>
      </div>
    </div>
  </div>
% }
  <div class="footer-copyright">
    <div class="container">
    %($siteTitle%)
    <a class="grey-text text-lighten-4 right" href="mailto:%($email%)">%($email%)</a>
    </div>
  </div>
</footer>

<script type="text/javascript" src="/pub/js/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="/pub/js/materialize.min.js"></script>

<script>
  $( document ).ready(function() {
    $('.modal-trigger').leanModal();
    $('.parallax').parallax();
    $('.slider').slider({full_width: true, height: 200, indicators: false});
    $('select').material_select();
  });

  function toggleSearch() {
    if($('nav').height() === 64) {
      $('nav').height(128);
      $('.navbar-fixed').height(128);
      $('#search-bar').css('visibility', 'visible');
      $('#search-bar').css('opacity', 1);
    } else {
      $('nav').height(64);
      $('.navbar-fixed').height(64);
      $('#search-bar').css('visibility', 'hidden');
      $('#search-bar').css('opacity', 0);
    }
  }
</script>
