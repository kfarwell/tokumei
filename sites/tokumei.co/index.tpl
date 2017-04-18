<div id="index-banner">
  <div class="section no-pad-bot">
    <div class="container">
      <br /><br />
      <img src="/img/logo-home.png" class="header center pink-text" style="width: 100%; margin-bottom: 3em" />
      <div class="row center">
        <a href="/p/timeline" class="btn-large waves-effect waves-light pink white-text">Speak freely<i class="mdi mdi-message-text-outline white-text right"></i></a>
      </div>
      <br /><br />
    </div>
  </div>
</div>

<div class="container">
  <div class="section">
    <div class="row">
      <div class="col s12 m6">
        <div class="icon-block">
          <h2 class="center"><i class="mdi mdi-message-text-outline pink-text"></i></h2>
          <h5 class="center">Microblogging</h5>
          <p>Discover and share the most interesting 300-character thoughts on the net. Ask questions, speak your mind, discuss articles, or just chat.</p>
        </div>
      </div>
      <div class="col s12 m6">
        <div class="icon-block">
          <h2 class="center"><i class="mdi mdi-eye-off pink-text"></i></h2>
          <h5 class="center">Anonymous</h5>
          <p>We believe that what you have to say is more important than who you are. %($siteTitle%)'s strong anonymity means privacy and real, honest discussion. When all information is treated equally, only an interesting post or an accurate argument works.</p>
        </div>
      </div>
    </div>
  </div>
</div>

<div id="bg1" class="parallax-container valign-wrapper section no-pad-bot">
  <div class="container">
    <div class="slider">
      <ul class="slides">
        <li><img src="/img/post0.png" /></li>
        <li><img src="/img/post1.png" /></li>
        <li><img src="/img/post2.png" /></li>
        <li><img src="/img/post3.png" /></li>
      </ul>
    </div>
  </div>
</div>

<div class="container">
  <div class="section">
    <div class="row">
      <div class="col s12 m6">
        <div class="icon-block">
          <h2 class="center"><i class="mdi mdi-settings pink-text"></i></h2>
          <h5 class="center">Self-hosting</h5>
% if(~ $base_url *.onion) {
          <p>%($siteTitle%) is powered by <a href="http://tokumeiobg3bqngg.onion/" class="pink-text">Tokumei</a>. You can host your own Tokumei site with your own rules and your own audience. Developers are free to customize their site with complete source code access, while beginners can get their own community site or personal blog running in an hour with <a href="http://tokumeiobg3bqngg.onion/hosting/" class="pink-text">our simple tutorials</a>.</p>
% }
% if not if(~ $base_url *.i2p) {
          <p>%($siteTitle%) is powered by <a href="http://tokumei.i2p/" class="pink-text">Tokumei</a>. You can host your own Tokumei site with your own rules and your own audience. Developers are free to customize their site with complete source code access, while beginners can get their own community site or personal blog running in an hour with <a href="http://tokumei.i2p/hosting/" class="pink-text">our simple tutorials</a>.</p>
% }
% if not {
          <p>%($siteTitle%) is powered by <a href="https://tokumei.co/" class="pink-text">Tokumei</a>. You can host your own Tokumei site with your own rules and your own audience. Developers are free to customize their site with complete source code access, while beginners can get their own community site or personal blog running in an hour with <a href="https://tokumei.co/hosting/" class="pink-text">our simple tutorials</a>.</p>
% }
        </div>
      </div>
      <div class="col s12 m6">
        <div class="icon-block">
          <h2 class="center"><i class="mdi mdi-code-tags pink-text"></i></h2>
          <h5 class="center">Developers</h5>
          <p>Tokumei is <a href="http://www.gnu.org/philosophy/free-sw.html" class="pink-text">free, libre, open source software</a> written in <a href="http://rc.cat-v.org/" class="pink-text">rc</a> using <a href="http://werc.cat-v.org/" class="pink-text">werc</a> and released under the permissive ISC license. This means you're free to use, modify, and share Tokumei as you wish. Feel free to fork or contribute. You can find our git repo <a href="https://git.tokumei.co/tokumei/tokumei" class="pink-text">here</a>.</p>
          <p>We have a simple plain text API <a href="/api" class="pink-text">here</a>.</p>
        </div>
      </div>
    </div>
  </div>
</div>

<div id="bg2" class="parallax-container valign-wrapper section no-pad-bot">
  <div class="container">
    <div class="row">
      <div class="col s12 m6 center">
        <h5 class="header light">Get in touch</h5>
        <a href="mailto:%($email%)" class="btn-large waves-effect waves-light pink white-text"><i class="mdi mdi-email left white-text"></i>Contact</a>
      </div>
      <div class="col s12 m6 center">
        <h5 class="header light">Support free speech</h5>
        <a href="/donate" class="btn-large waves-effect waves-light pink white-text"><i class="mdi mdi-gift left white-text"></i>Donate</a>
      </div>
    </div>
    <div class="row center">
    </div>
  </div>
</div>
