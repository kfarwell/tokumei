% tpl_handler `{get_lib_file dirdir/edit.tpl apps/dirdir/edit.tpl}

%{
if(! ~ 0 $#post_arg_ppp)
    ppp=$post_arg_ppp
if not if(~ 1 `{get_cookie ppp | awk '{print ($1 > 0 && $1 < 100)}'})
    ppp=`{get_cookie ppp}
if not
    ppp=25

if(! ~ 0 $#post_arg_page)
    page=$post_arg_page
if not
    page=1

numposts=`{ls $sitedir/p/*.txt | wc -l}
if(~ 0 `{echo $numposts $ppp | awk '{print $1 % $2}'})
    numpages=`{echo $numposts $ppp | awk '{print int($1 / $2)}'}
if not
    numpages=`{echo $numposts $ppp | awk '{print int($1 / $2) + 1}'}
%}

% post_list /p/ $page $ppp

<ul class="pagination right">
%   if(! ~ $page 1) {
    <li class="waves-effect">
        <form action="" method="post">
            <input type="hidden" name="page" value="%(`{echo $page | awk 'echo $1--'}%)">
            <input type="hidden" name="ppp" value="%($ppp%)">
            <button type="submit" class="fakelink"><i class="mdi mdi-chevron-left"></i></button>
        </form>
    </li>
%   }
% for(i in `{seq $numpages}) {
%   if(~ $i $page) {
    <li class="waves-effect active pink white-text">
%   }
%   if not {
    <li class="waves-effect">
%   }
        <form action="" method="post">
            <input type="hidden" name="page" value="%($i%)">
            <input type="hidden" name="ppp" value="%($ppp%)">
            <button type="submit" class="fakelink">%($i%)</button>
        </form>
    </li>
% }
%   if(! ~ $page $numpages) {
    <li class="waves-effect">
        <form action="" method="post">
            <input type="hidden" name="page" value="%(`{echo $page | awk 'echo $1++'}%)">
            <input type="hidden" name="ppp" value="%($ppp%)">
            <button type="submit" class="fakelink"><i class="mdi mdi-chevron-right"></i></button>
        </form>
    </li>
%   }
</ul>

<form action="" method="post">
    <input type="text" id="ppp" name="ppp" value="%($ppp%)" maxlength="2" style="display: inline; width: 1.5em">
    <label for="ppp">posts per page</label>
    <button type="submit" id="btn-ppp" class="fakelink tooltipped" data-position="right" data-delay="50" data-tooltip="Save"><i class="mdi mdi-content-save"></i></button>
</form>
