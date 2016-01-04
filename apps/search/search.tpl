<br />
<h5 style="display: inline">Trending:</h5>
% for(i in `{cat $sitedir/_werc/trending}) {
<div class="chip">
    <form action="/search" method="post">
        <input type="submit" name="search" value="%($i%)" class="fakelink">
    </form>
</div>
% }

% query=`{echo $post_arg_search | sed 's/[^A-Za-z0-9]//g' | tr A-Z a-z}
<h1 style="margin-bottom: 0">#%($query%)</h1>
<a href="/rss/%($query%)" class="waves-effect waves-light btn pink white-text"><i class="mdi mdi-rss left white-text"></i>RSS</a><br /><br />
% for(i in `{sed '1!G;h;$!d' < $sitedir/_werc/tags/$query})
%     txt_handler $sitedir/p/$i.txt
