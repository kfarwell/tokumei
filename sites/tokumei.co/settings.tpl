% if (~ $REQUEST_METHOD POST) {
<script>
  location.replace(window.location.href);
</script>
% }

<h1>Settings</h1>
<br />

<form action="" method="POST" onSubmit="javascript:location.reload();">
        <b>Ads:</b>
        <select name="ads">
                <option selected="selected" value="enabled">enabled</option>
                <option value="disabled">disabled</option>
        </select><br />

        <b>Radio:</b>
        <select name="radio">
                <option selected="selected" value="enabled">enabled</option>
                <option value="disabled">disabled</option>
        </select><br />

	<b>Style:</b>
	<select name="style">
		<option value="1995">1995</option>
		<option value="acme">acme</option>
		<option value="alcatel">alcatel</option>
		<option value="apple">apple</option>
		<option value="burichan">burichan</option>
		<option value="cat-v">cat-v</option>
		<option value="darkasmysoul">darkasmysoul</option>
		<option value="facebook">facebook</option>
		<option value="flesh">flesh</option>
		<option value="futaba">futaba</option>
		<option value="gmail">gmail</option>
		<option selected="selected" value="modern">modern</option>
		<option value="tomorrow">tomorrow</option>
		<option value="zenburn">zenburn</option>
	</select><br />

	<b>Mobile:</b>
	<select name="mobile">
		<option selected="selected" value="auto">auto</option>
		<option value="enabled">enabled</option>
		<option value="disabled">disabled</option>
	</select><br />

	<b>Number of recently bumped threads to show on thread indexes:</b>
	<select name="recent_num">
		<option value="1">1</option>
		<option value="2">2</option>
		<option selected="selected" value="3">3</option>
		<option value="4">4</option>
		<option value="5">5</option>
		<option value="6">6</option>
		<option value="7">7</option>
		<option value="8">8</option>
		<option value="9">9</option>
		<option value="10">10</option>
	</select><br />

	<b>Number of recent comments to show under recently bumped threads on thread indexes:</b>
	<select name="recent_comments_num">
		<option value="1">1</option>
		<option value="2">2</option>
		<option selected="selected" value="3">3</option>
		<option value="4">4</option>
		<option value="5">5</option>
		<option value="6">6</option>
		<option value="7">7</option>
		<option value="8">8</option>
		<option value="9">9</option>
		<option value="10">10</option>
	</select><br />

	<input type="submit" name="set_style" value="Save">
</form>
