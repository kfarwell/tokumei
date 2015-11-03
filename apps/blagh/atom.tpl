<?xml version="1.0" encoding="utf-8"?>

%{
# See for more info:http://www.tbray.org/ongoing/When/200x/2005/07/27/Atomic-RSS
fn statpost {
    f = $1

    updated = `{/bin/date --rfc-3339'=seconds' -r $f |tr ' ' 'T'} 
    post_uri=$base_url^`{cleanname `{echo $f | sed -e 's!^'$sitedir'!!'}}^'/'
    title=`{read $f/index.md}
    # Not used: date=`{/bin/date -Rd `{basename $f |sed 's/(^[0-9\-]*).*/\1/; s/-[0-9]$//'}}
    # TODO: use mtime(1) and ls(1) instead of lunix's stat(1)
    stat=`{stat -c '%Y %U' $f}
    #mdate=`{/bin/date -Rd `{mtime $f|awk '{print $1}' }} # Not used because it is unreliable
    by=$stat(2)
    #ifs=() { summary=`{cat $f/index.md | crop_text 1024 ... | $formatter } }
    ifs=() { summary=`{cat $f/index.md | strip_title_from_md_file | ifs=$difs {$formatter} } }
}
updated = `{/bin/date --rfc-3339'=seconds' |sed 's/ /T/'} 
%}

<feed xmlns="http://www.w3.org/2005/Atom"
    xmlns:thr="http://purl.org/syndication/thread/1.0">

% if(! ~ $"conf_blog_pubsubdub_hub '') {
%    echo '<link rel="hub" href="'$conf_blog_pubsubdub_hub'" />'
% }

    <link rel="self" href="%($base_url^$req_path%)"/>
    <id>%($base_url^$req_path%)</id>
    <icon>/favicon.ico</icon>

    <title>%($siteTitle%)</title>
    <subtitle>%($siteSubTitle%)</subtitle>

% # <updated>2008-09-24T12:47:00-04:00</updated>
    <updated>%($updated%)</updated>
    <link href="."/>

% for(f in `{get_post_list $blagh_root$blagh_dirs}) {
%    statpost $f

    <entry>
% # Maybe we should be smarter, see: http://diveintomark.org/archives/2004/05/28/howto-atom-id, example: <id>tag:intertwingly.net,2004:2899</id>
        <id>%($post_uri%)</id>
        <link href="%($post_uri%)"/>
        <title>%($title%)</title>
% # <link rel="replies" href="2899.atom" thr:count="0"/>
        <author><name>%($by%)</name></author>


        <content type="xhtml"><div xmlns="http://www.w3.org/1999/xhtml">
            %($summary%)
        </div></content>

        <updated>%($updated%)</updated>
    </entry>

% }

</feed>

% exit 

<feed xmlns="http://www.w3.org/2005/Atom"
  xmlns:thr="http://purl.org/syndication/thread/1.0">
  <link rel="self" href="http://intertwingly.net/blog/index.atom"/>
  <id>http://intertwingly.net/blog/index.atom</id>
  <icon>../favicon.ico</icon>

  <title>Sam Ruby</title>
  <subtitle>It’s just data</subtitle>
  <author>
    <name>Sam Ruby</name>
    <email>rubys@intertwingly.net</email>
    <uri>/blog/</uri>
  </author>
  <updated>2008-09-24T12:47:00-04:00</updated>
  <link href="/blog/"/>
  <link rel="license" href="http://creativecommons.org/licenses/BSD/"/>

  <entry>
    <id>tag:intertwingly.net,2004:2899</id>
    <link href="/blog/2008/09/11/RubyConf-2008"/>
    <link rel="replies" href="2899.atom" thr:count="0"/>
    <title>RubyConf 2008</title>
    <content type="xhtml"><div xmlns="http://www.w3.org/1999/xhtml">
    
<p>My <a href="http://www.rubyconf.org/talks/14">proposal</a> has been accepted for <a href="http://www.rubyconf.org/talks">RubyConf 2008</a>.  Because of the presence of Ruby implementers, this is going to be a bit challenging as it will likely turn into two talks at once.  One sharing experiences with fellow developers concerning things they may need to watch out for, and another with language designers about the impact of their changes.  It also is likely to be true, as it was at <a href="http://intertwingly.net/blog/2008/07/24/Ruby-1-9-What-to-Expect">OSCON</a>, that there will be members of the audience who know way more about this subject than I do.</p>
<p>I had originally requested a slot on Saturday.  My current slot requires me to shave a day off of <a href="http://us.apachecon.com/c/acus2008/">ApacheCon</a>.  I’ve again asked that the slot be changed, but even if it doesn’t move, I can manage this.  At least we are only talking about a short hop from New Orleans to Orlando.</p>

    </div></content>
    <updated>2008-09-11T06:51:36-04:00</updated>
  </entry>

  <entry>
    <id>tag:intertwingly.net,2004:2898</id>
    <link href="/blog/2008/09/10/Small-Updates"/>
    <link rel="replies" href="2898.atom" thr:count="8" thr:updated="2008-09-10T15:31:05-04:00"/>
    <title>Small Updates</title>
    <summary type="xhtml"><div xmlns="http://www.w3.org/1999/xhtml">
    
    <p><a href="http://hublog.hubmed.org/archives/001744.html">Alf Eaton</a>: <em>Aside: if you’re reading a Planet that contains HubLog, those posts will all jump to the top - sorry! (I wish Planets dealt better with small updates so I didn’t have to worry about it).</em></p>
<p>I don’t know what publishing software you use, but I see you provide an Atom feed, and Planet 2.0 and Venus both implement <a href="http://www.atomenabled.org/developers/syndication/atom-format-spec.php#element.updated">atom:updated</a> as specified in RFC 4287.</p>

    </div></summary>
    <content type="xhtml"><div xmlns="http://www.w3.org/1999/xhtml">

<p><a href="http://hublog.hubmed.org/archives/001744.html"><cite>Alf Eaton</cite></a>: <em>Aside: if you’re reading a Planet that contains HubLog, those posts will all jump to the top - sorry! (I wish Planets dealt better with small updates so I didn’t have to worry about it).</em></p>
<p>I don’t know what publishing software you use, but I see you provide an Atom feed, and Planet 2.0 and Venus both implement <a href="http://www.atomenabled.org/developers/syndication/atom-format-spec.php#element.updated">atom:updated</a> as specified in RFC 4287.</p>
<p>More specifically, if you have a minor update and leave the updated date alone, the posts will not jump to the top.  The next release of WordPress, for example, will contain the necessary hooks for a <a href="http://blog.ciarang.com/posts/wp-minor-edit/">plugin</a> to provide a simple checkbox for indicating that the change constitutes a minor edit.</p>

    </div></content>
    <updated>2008-09-10T10:18:47-04:00</updated>
  </entry>

  <entry>
    <id>tag:intertwingly.net,2004:2897</id>
    <link href="/blog/2008/09/07/SVG-via-CSS"/>
    <link rel="replies" href="2897.atom" thr:count="10" thr:updated="2008-09-12T02:21:21-04:00"/>
    <title>SVG via CSS</title>
    <summary type="xhtml"><div xmlns="http://www.w3.org/1999/xhtml">
    
    <p>Now that I have my weblog looking reasonably consistent between Gecko and WebKit based browsers, I’ve taken another look at Opera.  Opera doesn’t have support for border-radius, but does have support for background images in SVG, which can be <a href="http://dev.opera.com/articles/view/new-development-techniques-using-opera-k/">used to provide the same effect</a>.  My Nav Bar on <a href="http://rails.intertwingly.net/blog/">my test site</a> now employs this technique, and it requires two separate images: <a href="http://rails.intertwingly.net/stylesheets/rc-039-CCD.svg">039 on CCD</a> and <a href="http://rails.intertwingly.net/stylesheets/rc-CCD-FFF.svg">CCD on FFF</a>.</p>
<p>Frankly, my first reaction to this was mixed.  The pluses for SVG in CSS is that it doesn’t require either adjusting your markup or JavaScript to achieve these effects, a desirable characteristic that generally the <a href="http://www.cssjuice.com/25-rounded-corners-techniques-with-css/">other techniques</a> don’t share.</p>

    </div></summary>

    <content type="xhtml"><div xmlns="http://www.w3.org/1999/xhtml">
    
<p>Now that I have my weblog looking reasonably consistent between Gecko and WebKit based browsers, I’ve taken another look at Opera.  Opera doesn’t have support for border-radius, but does have support for background images in SVG, which can be <a href="http://dev.opera.com/articles/view/new-development-techniques-using-opera-k/">used to provide the same effect</a>.  My Nav Bar on <a href="http://rails.intertwingly.net/blog/">my test site</a> now employs this technique, and it requires two separate images: <a href="http://rails.intertwingly.net/stylesheets/rc-039-CCD.svg">039 on CCD</a> and <a href="http://rails.intertwingly.net/stylesheets/rc-CCD-FFF.svg">CCD on FFF</a>.</p>
<p>Meanwhile, Robert O’Callahan has been exploring <a href="http://weblogs.mozillazine.org/roc/archives/2008/06/applying_svg_ef.html">other ways</a> to integrate these technologies.</p>

    </div></content>
    <updated>2008-09-07T11:12:29-04:00</updated>
  </entry>

</feed>

