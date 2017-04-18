<h1>API</h1>

<img class="responsive-img" src="/img/xmlascent.png" alt="XML sucks: The Ascent of Ward" />

<p>Hate XML? You'll love %($siteTitle%)'s API.</p>

<h3>Read</h3>
<p>Just GET these simple files:</p>
<ul>
  <li><a href="%($protocol%)://%($SERVER_NAME%)/p/1.txt">%($protocol%)://%($SERVER_NAME%)/p/1.txt:</a> Plain text contents of post #1. IDs start at 1.</li>
  <li><a href="%($protocol%)://%($SERVER_NAME%)/p/1_werc/tags">%($protocol%)://%($SERVER_NAME%)/p/1_werc/tags:</a> Post #1's tags. One per line.</li>
  <li><a href="%($protocol%)://%($SERVER_NAME%)/p/1_werc/filetype">%($protocol%)://%($SERVER_NAME%)/p/1_werc/filetype:</a> Post #1's file extension. Use it to determine the location of the file attachment below.</li>
  <li><a href="%($protocol%)://%($SERVER_NAME%)/p/1_werc/file.*">%($protocol%)://%($SERVER_NAME%)/p/1_werc/file.*:</a> Post #1's file attachment. For example, if <code>filetype</code> above returns <code>png</code>, fetch <code>file.png</code>.</li>
  <li><a href="%($protocol%)://%($SERVER_NAME%)/p/1_werc/spam">%($protocol%)://%($SERVER_NAME%)/p/1_werc/spam:</a> Number of times post #1 has been flagged as spam.</li>
  <li><a href="%($protocol%)://%($SERVER_NAME%)/p/1_werc/replies/0">%($protocol%)://%($SERVER_NAME%)/p/1_werc/replies/0:</a> Plain text contents of reply #0 to post #1. IDs start at 0.</li>
  <li><a href="%($protocol%)://%($SERVER_NAME%)/p/1_werc/postnum">%($protocol%)://%($SERVER_NAME%)/p/1_werc/postnum:</a> Post #1's most recent reply ID, or number of replies minus 1.</li>
  <li><a href="%($protocol%)://%($SERVER_NAME%)/postnum">%($protocol%)://%($SERVER_NAME%)/postnum:</a> Most recent post ID, or total number of posts (not including replies).</li>
  <li><a href="%($protocol%)://%($SERVER_NAME%)/_werc/tags/tokumei">%($protocol%)://%($SERVER_NAME%)/_werc/tags/tokumei:</a> IDs of all posts tagged with #tokumei. One per line.</li>
  <li><a href="%($protocol%)://%($SERVER_NAME%)/_werc/trending">%($protocol%)://%($SERVER_NAME%)/_werc/trending:</a> Space-separated list of the top 10 trending tags.</li>
</ul>

<p>You can check the modify timestamp in a post or reply file's metadata to see the day it was created. The exact time is stripped to improve anonymity.</p>

<h3>Write</h3>
<p>Just POST these fields to <a href="%($protocol%)://%($SERVER_NAME%)">%($protocol%)://%($SERVER_NAME%)/p/</a>:</p>
<ul>
  <li><h4>New post</h4>
    comment: the post text<br />
    tags: comma-separated tags (optional)<br />
    file: file attachment URL (optional)<br />
    password: deletion password (optional)</li>
  <li><h4>Reply</h4>
    comment: the reply text<br />
    parent: the post to reply to</li>
</ul>

<h2>Examples</h2>

<p>Working with %($siteTitle%)'s API in another language? Send some example code to <a href="mailto:%($email%)">%($email%)</a> and we'll add it here.</p>

<h3><a href="http://rc.cat-v.org/">rc shell</a></h3>

<h5>Get the text of every post tagged with #tokumei:</h5>
<pre><code>for(i in `{curl %($protocol%)://%($SERVER_NAME%)/_werc/tags/tokumei})
    curl %($protocol%)://%($SERVER_NAME%)/p/$i.txt</code></pre>

<h5>Get the approximate creation date of post #1 in seconds since Epoch:</h5>
<pre><code>wget %($protocol%)://%($SERVER_NAME%)/p/1.txt
stat -c %Y 1.txt</code></pre>

<h5>Create a new post:</h5>
<pre><code>curl -d 'comment=First line%0ASecond line' \
     -d 'tags=firsttag, secondtag' \
     -d 'file=https://example.com/file.png' \
     -d 'password=supersecret' \
     %($protocol%)://%($SERVER_NAME%)/p/</code></pre>

<h5>Reply to post #1:</h5>
<pre><code>curl -d 'comment=First line%0ASecond line' \
     -d 'parent=1' \
     %($protocol%)://%($SERVER_NAME%)/p/</code></pre>

<h3>Java / Qt Jambi</h3>

<p>There is a partial reference client in Java: <a href="https://kfarwell.org/projects/toqumei/">Toqumei</a>.</p>

<img src="/img/toqumei.png" alt="Toqumei" />
