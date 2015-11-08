% masterSiteTitle=`{cat sites/*/_werc/config | grep siteTitle | cut -d'''' -f 2}

<nav class="pink" role="navigation">
  <div class="nav-wrapper container">
    <a id="logo-container" href="/" class="brand-logo black-text">
      <img src="/img/logo.png" alt="%($siteTitle%)" />
      <span>%($siteTitle%)</span>
    </a>
      <form action="/search" method="post" class="right">
        <div class="input-field">
          <input id="search" name="search" type="search" placeholder="Search tags..." required>
          <label for="search"><i class="mdi mdi-magnify black-text"></i></label>
        </div>
      </form>
  </div>
</nav>

% if(~ $siteTitle $masterSiteTitle) {
%   handlers_bar_left=0
<style>
  #side-bar div {
    border-bottom: none;
  }

  #main-copy {
    margin: 0 auto;
    border-left: none;
  }
</style>
% }

<div id="main-copy" class="container">

% run_handlers $handlers_body_head

% run_handler $handler_body_main

% run_handlers $handlers_body_foot

</div>

<footer class="page-footer white">
  <div class="footer-copyright">
    <div class="container">
      <span class="black-text">Tokumei</span>
      <span class="right">
        <a href="http://kfarwell.org/projects/_tokumei" class="black-text">Code</a>
        <a href="/privacy" class="black-text">Privacy</a>
        <a href="bitcoin:1Q31UMtim2ujr3VX5QcS3o95VF2ceiwzzc" class="black-text">Donate</a>
        <a href="mailto:hello@tokumei.co" class="black-text">Contact</a>
      </span>
    </div>
  </div>
</footer>

<script type="text/javascript" src="/_werc/js/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="/_werc/js/materialize.min.js"></script>

<script>
  $( document ).ready(function() {
    $(".button-collapse").sideNav();

    $(".dropdown-button").dropdown();

    $(".materialboxed").materialbox();

    $("select").material_select();

    $('.modal-trigger').leanModal();

    $(".scroll-top").on("click", function(e) {
      e.preventDefault();
      $("body, html").animate({
        scrollTop: 0
      }, "fast");
    });
    $(".scroll-bot").on("click", function(e) {
      e.preventDefault();
      $("body, html").animate({
        scrollBottom: $(document).height()
      }, "fast");
    });

    $(".thingiview").height($(".thingiview").width());
  });

  //window.addEventListener("resize", function(e) {
  //  $(".thingiview").height($(".thingiview").width());
  //  $(".thingiview").attr("src", function(i, val) { return val; });
  //});
</script>
