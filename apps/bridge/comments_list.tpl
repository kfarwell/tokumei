<h2>Comments</h2>

<div>
% for(c in `{ls $comments_dir/}) {
%    if(test -s $c/body) {
        <div class="comment"><h5><a href="/user/%(`{cat $c/user}%)">
% echo '<img class="avatar" style="height: 1em; margin-right: 0.25em !important" src="https://secure.gravatar.com/avatar/'`{cat etc/users/`{cat $c/user}^/email | tr -d $NEW_LINE | md5sum}'" />'
          %(`{cat $c/user}%)</a></h5>
          <h6>%(`{cat $c/posted}%)</h6>
%         cat $c/body
        </div>
%    }
% }
</div>

