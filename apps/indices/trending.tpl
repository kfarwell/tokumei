<h1>Trending Posts</h1>

%{
tpl_handler `{get_lib_file posts/edit.tpl apps/posts/edit.tpl}

# display the top 5 trending posts for each of the top 5 trending tags
# thanks to Keefer Rourke for the algorithm, based on Reddit's trending
# algorithm:
# https://moz.com/blog/reddit-stumbleupon-delicious-and-hacker-news-algorithms-exposed
for(tag in `{tr ' ' $NEW_LINE < $sitedir/_werc/trending | sed 5q}) {
    allposts=`{sed '1!G;h;$!d' < $sitedir/_werc/tags/$tag}
    scores=()
    i=1

    for(i in $allposts) {
        date=`{stat -c %Y $sitedir/p/$i.txt}
        if(test -d $sitedir/p/$i^_werc/replies) {
            numreplies=`{ls $sitedir/p/$i^_werc/replies | wc -l}
            hasreplies=1
        }
        if not {
            # numreplies must be at least 1 to take its log()
            numreplies=1
            hasreplies=0
        }

        # score0,postnum0, score1,postnum1, ...
        scores=($"scores `{echo|awk '{print (log('$numreplies') + '$hasreplies' * '$date' / '$trendinginterval')}'}^','$i)
    }

    # sort scores, get postnums from top 5
    popularposts=`{echo $scores | tr ' ' $NEW_LINE | sort -nr | sed '$d; 5q' | tr $NEW_LINE ' ' | sed 's/[0-9.]*,//g'}

    if(! ~ $#popularposts 0) {
        echo '<h2>#'$tag'</h2>'
        popularposts=`{echo $popularposts | sed 's/^ //'}
        for(post in $popularposts)
            txt_handler $sitedir/p/$post.txt
    }
}
%}
