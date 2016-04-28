<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
    <channel>
        <atom:link href="%($protocol%)://%($SERVER_NAME^$req_path%)" rel="self" type="application/rss+xml" />
%       if(~ $req_path /rss || ~ $req_path /rss/) {
        <title>%($siteTitle%)</title>
%       }
%       if not {
        <title>%($siteTitle '| #'`{echo $req_path | sed 's,/rss/,,'}%)</title>
%       }
        <link>%($protocol%)://%($SERVER_NAME^$req_path%)</link>
        <description>%($rssDesc%)</description>
        <language>en-us</language>
        <generator>Tom Duff's rc, and Kris Maglione's clever hackery</generator>
        <webMaster>%($webmaster%)</webMaster>
%{
        if(~ $req_path /rss || ~ $req_path /rss/)
            posts=`{ls -p $sitedir/p/*.txt | sort -nr | sed 25q |
                    sed 's/\.txt$//'}
        if not
            posts=`{sed '1!G;h;$!d' < $sitedir/_werc/tags/`{echo $req_path |
                                                            sed 's,/rss/,,'}}

        for(i in $posts) {
%}
        <item>
            <title>%(`{cat $sitedir/p/$i.txt}%)</title>
            <link>%($protocol%)://%($SERVER_NAME/p/$i%)</link>
            <description><![CDATA[%(`{sed $postfilter < $sitedir/p/$i.txt}%)]]></description>
%           for(tag in `{cat $sitedir/p/$i^_werc/tags}) {
            <category>%($tag%)</category>
%           }
            <guid isPermaLink="true">%($i%)</guid>
            <pubDate>%(`{/bin/date -Rd @`{stat -c %Y $sitedir/p/$i.txt}}%)</pubDate>
        </item>
%        }

    </channel>
</rss>
