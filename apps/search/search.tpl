<h1>#%($post_arg_search%)</h1>

% for(i in `{cat $sitedir/_werc/tags/$post_arg_search | sed '1!G;h;$!d'})
%     txt_handler $sitedir/p/$i.txt
