% masterSiteTitle=`{cat sites/*/_werc/config | grep siteTitle | cut -d'''' -f 2}

% if(! ~ $req_path /) {
<nav class="pink" role="navigation">
  <div class="nav-wrapper container">
    <a id="logo-container" href="/" class="brand-logo white-text">
      <img src="/img/logoWhite.png" alt="%($siteTitle%)" />
      <span>%($siteTitle%)</span>
    </a>
      <form action="/search" method="post" class="right">
        <div class="input-field">
          <input id="search" name="search" type="search" placeholder="Search tags..." required>
          <label for="search"><i class="mdi mdi-magnify white-text"></i></label>
        </div>
      </form>
  </div>
</nav>
% }

<div id="main-copy"%(`{if(! ~ $req_path /) echo ' class="container"'}%)>

% run_handlers $handlers_body_head

% run_handler $handler_body_main

% run_handlers $handlers_body_foot

</div>

<script type="text/javascript" src="/_werc/js/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="/_werc/js/materialize.min.js"></script>

<script>
  $( document ).ready(function() {
    $(".button-collapse").sideNav();
    $('.parallax').parallax();
    $('.modal-trigger').leanModal();
  });
</script>
