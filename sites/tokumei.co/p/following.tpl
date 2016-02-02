% if (~ $REQUEST_METHOD POST) {
<script>
  location.replace(window.location.href);
</script>
% }

<h1>Followed Tags</h1>

% tpl_handler `{get_lib_file dirdir/edit.tpl apps/dirdir/edit.tpl}

% tags=`{get_cookie following}
% if(~ $"tags '') {
<p>Looks like you're not following any tags yet! Check out some trending tags to get started.</p>
%     for(i in `{cat $sitedir/_werc/trending}) {
<div class="chip">
    <form action="/search" method="post">
        <input type="submit" name="search" value="%($i%)" class="fakelink">
    </form>
</div>
%     }
% }
% if not {

%{
allposts=`{ls -t $sitedir/p/*.txt}
followedposts=()
i=1
while(! ~ $i 25) {
    if(test -f `{echo $allposts($i) | sed 's,\.txt$,_werc/tags,'})
        if(grep -s '^('$tags')$' \
           < `{echo $allposts($i) | sed 's,\.txt$,_werc/tags,'})
            followedposts=($"followedposts $allposts($i))
    i=`{echo $i | awk 'echo $1++'}
}

if(! ~ $#followedposts 0) {
%}
<br />
<h5 style="display: inline">Following:</h5>
% for(i in `{echo $tags | sed 's,\|, ,g'}) {
<div class="chip">
    <form action="/search" method="post">
        <input type="submit" name="search" value="%($i%)" class="fakelink">
    </form>
</div>
% }
%{
    followedposts=`{echo $followedposts | sed 's/^ //'}
    for(post in $followedposts)
        txt_handler $post
}

}
%}
