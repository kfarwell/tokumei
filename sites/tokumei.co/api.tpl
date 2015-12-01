<h1>API</h1>

<img class="responsive-img" src="/img/xml_ascent.png" alt="XML sucks: The Ascent of Ward" />

<p>Hate XML? You'll love Tokumei's API.</p>

<p>Just GET these simple files:</p>
<ul>
  <li><a href="%($base_url%)/p/1.txt">%($base_url%)/p/1.txt:</a> Plain text contents of post #1. IDs start at 1.</li>
  <li><a href="%($base_url%)/p/1_werc/tags">%($base_url%)/p/1_werc/tags:</a> Post #1's tags. One per line.</li>
  <li><a href="%($base_url%)/p/1_werc/replies/0">%($base_url%)/p/1_werc/replies/0:</a> Plain text contents of reply #0 to post #1. IDs start at 0.</li>
  <li><a href="%($base_url%)/p/1_werc/postnum">%($base_url%)/p/1_werc/postnum:</a> Post #1's most recent reply ID, or number of replies minus 1.</li>
  <li><a href="%($base_url%)/postnum">%($base_url%)/postnum:</a> Most recent post ID, or total number of posts (not including replies).</li>
  <li><a href="%($base_url%)/_werc/tags/tokumei">%($base_url%)/_werc/tags/tokumei:</a> IDs of all posts tagged with #tokumei. One per line.</li>
</ul>

<p>You can check the modify timestamp in a post or reply file's metadata to see when it was created.</p>

<h2>Examples</h2>

<p>Working with Tokumei's API in another language? Send some example code to <a href="mailto:hello@tokumei.co">hello@tokumei.co</a> and we'll add it here.</p>

<h3><a href="http://rc.cat-v.org/">rc shell</a></h3>

<h5>Get the text of every post tagged with #tokumei:</h5>
<pre><code>for(i in `{curl %($base_url%)/_werc/tags/tokumei})
    curl %($base_url%)/p/$i.txt</code></pre>

<h5>Get the creation date of post #1 in seconds since Epoch:</h5>
<pre><code>wget %($base_url%)/p/1.txt
stat -c %Y 1.txt</code></pre>
