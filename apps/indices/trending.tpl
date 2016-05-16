<h1>Trending Posts</h1>

%{
tpl_handler `{get_lib_file posts/edit.tpl apps/posts/edit.tpl}

# display the 5 most recent posts with >= 3 replies for each of the top 5
# trending tags
for(tag in `{sed 5q < $sitedir/_werc/trending}) {
    allposts=`{sed '1!G;h;$!d' < $sitedir/_werc/tags/$tag}
    popularposts=()
    i=1
    while(! ~ `{echo $"popularposts | wc -w} 5 &&
          ! ~ $i `{echo $#allposts | awk 'echo $1++'}) {
        if(test -f $sitedir/p/$allposts($i)^_werc/postnum)
            if(~ 1 `{awk '{print ($1 > 1)}' \
                     < $sitedir/p/$allposts($i)^_werc/postnum})
                popularposts=($"popularposts $allposts($i))
        i=`{echo $i | awk 'echo $1++'}
    }

    if(! ~ $#popularposts 0) {
        echo '<h2>#'$tag'</h2>'
        popularposts=`{echo $popularposts | sed 's/^ //'}
        for(post in $popularposts)
            txt_handler $sitedir/p/$post.txt
    }
}
%}
