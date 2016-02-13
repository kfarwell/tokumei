% if (~ $REQUEST_METHOD POST) {
<script>
  location.replace(window.location.href);
</script>
% }

<h1>Settings</h1>

<form action="" method="POST">
  <div class="input-field">
    <select name="theme" required="" class="validate">
      <option %(`{if(~ `{get_cookie theme} pink) echo 'selected=""'}%) value="pink">Pink</option>
      <option %(`{if(~ `{get_cookie theme} red) echo 'selected=""'}%) value="red">Red</option>
      <option %(`{if(~ `{get_cookie theme} purple) echo 'selected=""'}%) value="purple">Purple</option>
      <option %(`{if(~ `{get_cookie theme} deep-purple) echo 'selected=""'}%) value="deep-purple">Deep purple</option>
      <option %(`{if(~ `{get_cookie theme} indigo) echo 'selected=""'}%) value="indigo">Indigo</option>
      <option %(`{if(~ `{get_cookie theme} blue) echo 'selected=""'}%) value="blue">Blue</option>
      <option %(`{if(~ `{get_cookie theme} light-blue) echo 'selected=""'}%) value="light-blue">Light blue</option>
      <option %(`{if(~ `{get_cookie theme} cyan) echo 'selected=""'}%) value="cyan">Cyan</option>
      <option %(`{if(~ `{get_cookie theme} teal) echo 'selected=""'}%) value="teal">Teal</option>
      <option %(`{if(~ `{get_cookie theme} green) echo 'selected=""'}%) value="green">Green</option>
      <option %(`{if(~ `{get_cookie theme} light-green) echo 'selected=""'}%) value="light-green">Light green</option>
      <option %(`{if(~ `{get_cookie theme} lime) echo 'selected=""'}%) value="lime">Lime</option>
      <option %(`{if(~ `{get_cookie theme} yellow) echo 'selected=""'}%) value="yellow">Yellow</option>
      <option %(`{if(~ `{get_cookie theme} amber) echo 'selected=""'}%) value="amber">Amber</option>
      <option %(`{if(~ `{get_cookie theme} orange) echo 'selected=""'}%) value="orange">Orange</option>
      <option %(`{if(~ `{get_cookie theme} deep-orange) echo 'selected=""'}%) value="deep-orange">Deep orange</option>
      <option %(`{if(~ `{get_cookie theme} brown) echo 'selected=""'}%) value="brown">Brown</option>
      <option %(`{if(~ `{get_cookie theme} grey) echo 'selected=""'}%) value="grey">Grey</option>
      <option %(`{if(~ `{get_cookie theme} blue-grey) echo 'selected=""'}%) value="blue-grey">Blue-grey</option>
      <option %(`{if(~ `{get_cookie theme} black) echo 'selected=""'}%) value="black">Black</option>
    </select>
    <label>Theme</label>
  </div>
  <div class="input-field">
    <textarea name="css" id="css" class="materialize-textarea validate">%(`{
        if(! ~ `{get_cookie css} '')
            cat $sitedir/_werc/pub/custom/`{get_cookie css}^.css}%)</textarea>
    <label for="css">Custom CSS</label>
  </div>
  <button type="submit" value="Save" class="btn-large waves-effect waves-light pink">Save<i class="mdi mdi-content-save right"></i></button>
</form>
