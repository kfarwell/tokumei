% if (~ $REQUEST_METHOD POST) {
<script>
  location.replace(window.location.href);
</script>
% }

<h1>Followed Tags</h1>

% tpl_handler `{get_lib_file posts/edit.tpl apps/posts/edit.tpl}

% tags=`{get_cookie following}

% if(~ $"tags '') {
<noscript>
    <form action="" method="post">
        <div class="input-field">
            <input type="text" name="import" id="import">
            <label for="import">Follow code</label>
            <button type="submit" class="waves-effect waves-light btn pink">
                <i class="mdi mdi-import left"></i>
                Import
            </button>
        </div>
    </form>
</noscript>
<div id="modalimport" class="yesscript modal">
    <form action="" method="post">
        <div class="modal-content">
            <div class="input-field">
                <input type="text" name="import" id="import">
                <label for="import">Follow code</label>
            </div>
        </div>
        <div class="modal-footer">
            <button type="submit" class="modal-action waves-effect btn-flat">Import</button>
        </div>
    </form>
</div>
<div class="yesscript" style="display: inline">
    <a href="#modalimport" class="modal-trigger waves-effect waves-light btn pink white-text">
        <i class="mdi mdi-import white-text left"></i>
        Import
    </a>
    <br /><br />
</div>

<p>Looks like you're not following any tags yet! Check out some trending tags to get started.</p>
%     for(i in `{cat $sitedir/_werc/trending}) {
<div class="chip pink lighten-4">
    <form action="/search" method="post">
        <input type="submit" name="search" value="%($i%)" class="fakelink">
    </form>
</div>
%     }
% }
% if not {

%{
allposts=`{ls -p $sitedir/p/*.txt | sort -nr}
followedposts=()
i=1
while(! ~ $i 25) {
    if(test -f `{echo $sitedir/p/$allposts($i) | sed 's,\.txt$,_werc/tags,'})
        if(grep -s '^('$tags')$' \
           < `{echo $sitedir/p/$allposts($i) | sed 's,\.txt$,_werc/tags,'})
            followedposts=($"followedposts $sitedir/p/$allposts($i))
    i=`{echo $i | awk 'echo $1++'}
}
%}

% if(! ~ $#followedposts 0) {
<br />
<h5 style="display: inline">Following:</h5>
% for(i in `{echo $tags | sed 's,\|, ,g'}) {
<div class="chip pink lighten-4">
    <form action="/search" method="post">
        <input type="submit" name="search" value="%(`{echo $i | sed 's/_/ /g'}%)" class="fakelink">
    </form>
</div>
% }

<br /><br />
<form action="/backup" method="post" style="display: inline">
    <input type="hidden" name="export" value="%($tags%)">
    <button type="submit" class="waves-effect waves-light btn pink" style="display: inline">
        <i class="mdi mdi-export left"></i>
        Export
    </button>
</form>
<noscript>
    <form action="" method="post">
        <div class="input-field">
            <input type="text" name="import" id="import">
            <label for="import">Follow code</label>
            <button type="submit" class="waves-effect waves-light btn pink">
                <i class="mdi mdi-import left"></i>
                Import
            </button>
        </div>
    </form>
</noscript>
<div id="modalimport" class="yesscript modal">
    <form action="" method="post">
        <div class="modal-content">
            <div class="input-field">
                <input type="text" name="import" id="import">
                <label for="import">Follow code</label>
            </div>
        </div>
        <div class="modal-footer">
            <button type="submit" class="modal-action waves-effect btn-flat">Import</button>
        </div>
    </form>
</div>
<div class="yesscript" style="display: inline">
    <a href="#modalimport" class="modal-trigger waves-effect waves-light btn pink white-text">
        <i class="mdi mdi-import white-text left"></i>
        Import
    </a>
    <br /><br />
</div>

%{
    followedposts=`{echo $followedposts | sed 's/^ //'}
    for(post in $followedposts)
        txt_handler $post
}

}
%}
