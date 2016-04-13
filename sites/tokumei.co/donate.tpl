<style>.ck-btn,.ck-btn:hover,.ck-btn:active,.ck-btn:focus { text-decoration:none; }</style>

<h1>Donate</h1>

<ul>
  <li><h2>Bitcoin (direct)</h2><a href="bitcoin:%($bitcoin%)" class="btn-large waves-effect waves-light pink white-text"><i class="mdi mdi-currency-btc left white-text"></i>%($bitcoin%)</a></li>
  <li><h2>PayPal</h2><form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
    <input type="hidden" name="cmd" value="_donations">
    <input type="hidden" name="business" value="%($paypal_business%)">
    <input type="hidden" name="lc" value="%($paypal_location%)">
    <input type="hidden" name="item_name" value="%($paypal_name%)">
    <input type="hidden" name="currency_code" value="%($paypal_currency%)">
    <input type="hidden" name="bn" value="PP-DonationsBF:btn_donateCC_LG.gif:NonHosted">
    <input type="image" src="/img/paypal.gif" border="0" name="submit" alt="PayPal">
  </form></li>
</ul>
