<h1>#%($post_arg_search%)</h1>

% for(i in `{cat $sitedir/_werc/tags/$post_arg_search | sort -r})
%     txt_handler $sitedir/p/$i.txt
%     #cat $sitedir/p/$i.txt
