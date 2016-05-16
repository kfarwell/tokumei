<br />
<h5 style="display: inline">Trending:</h5>
% for(i in `{cat $sitedir/_werc/trending}) {
<div class="chip pink lighten-3">
    <form action="/search" method="post">
        <input type="submit" name="search" value="%(`{echo $i | sed 's/_/ /g'}%)" class="fakelink">
    </form>
</div>
% }

% query=`{echo $post_arg_search | sed 's/[^A-Za-z0-9 ]//g; s/ /_/g' |
%         tr A-Z a-z}
<h1>#%(`{echo $query | sed 's/_/ /g'}%)</h1>

% if(! ~ `{get_cookie following} *`{echo $query | sed 's/_/ /g'}^*) {
<form action="/p/following" method="post" style="display: inline">
    <input type="hidden" name="follow" value="%($query%)">
    <button type="submit" class="waves-effect waves-light btn pink">
        <i class="mdi mdi-eye left"></i>
        Follow
    </button>
</form>
% }
% if not {
<form action="/p/following" method="post" style="display: inline">
    <input type="hidden" name="unfollow" value="%($query%)">
    <button type="submit" class="waves-effect waves-light btn pink">
        <i class="mdi mdi-eye-off left"></i>
        Unfollow
    </button>
</form>
% }
<a href="/rss/%($query%)" class="waves-effect waves-light btn pink white-text">
    <i class="mdi mdi-rss left white-text"></i>
    RSS
</a>
<br /><br />

% for(i in `{sed '1!G;h;$!d' < $sitedir/_werc/tags/$query})
%     txt_handler $sitedir/p/$i.txt
