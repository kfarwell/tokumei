<br />
<h5 style="display: inline">Trending:</h5>
% for(i in `{cat $sitedir/_werc/trending}) {
<div class="chip">
    <form action="/search" method="post">
        <input type="submit" name="search" value="%($i%)" class="fakelink">
    </form>
</div>
% }

<h1>#%($post_arg_search%)</h1>
% for(i in `{cat $sitedir/_werc/tags/$post_arg_search | sed '1!G;h;$!d'})
%     txt_handler $sitedir/p/$i.txt
