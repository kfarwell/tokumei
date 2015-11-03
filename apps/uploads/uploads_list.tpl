% # good luck
<br /><div class="row">
% i=1
% for(c in `{ls -tr up/ | grep /`{basename $local_path}^: }) {
%   file=`{basename $c}
%   user=`{basename $c | cut -d : -f 2}
%   ext=`{basename $c | sed 's/.*\.//'}
    <div class="col s12 m4 galleryimg">
%   if(~ $ext 3gpp || ~ $ext 3gp || ~ $ext ts || ~ $ext mp4 || ~ $ext mpeg || ~ $ext mpg || ~ $ext mov || ~ $ext webm || ~ $ext flv || ~ $ext m4v || ~ $ext mng || ~ $ext asx || ~ $ext asf || ~ $ext wmv || ~ $ext avi || ~ $ext 3GPP || ~ $ext 3GP || ~ $ext TS || ~ $ext MP4 || ~ $ext MPEG || ~ $ext MPG || ~ $ext MOV || ~ $ext WEBM || ~ $ext FLV || ~ $ext M4V || ~ $ext MNG || ~ $ext ASX || ~ $ext ASF || ~ $ext WMV || ~ $ext AVI)
%       echo '        <video id="'$i'" title="'$i'" src="/up/'$file^'" class="responsive-video z-depth-1" data-caption="By '$user'" controls><a id="'$i'" href="/up/'$file^'"><img src="/img/unsupported.png" class="responsive-img z-depth-1" alt="Download unsupported file" /><a></video>'
%   if not if(~ $ext mid || ~ $ext midi || ~ $ext kar || ~ $ext mp3 || ~ $ext ogg || ~ $ext m4a || ~ $ext ra || ~ $ext MID || ~ $ext MIDI || ~ $ext KAR || ~ $ext MP3 || ~ $ext OGG || ~ $ext M4A || ~ $ext RA)
%       echo '        <audio id="'$i'" title="'$i'" src="/up/'$file^'" class="z-depth-1" style="width: 100%" data-caption="By '$user'" controls><a id="'$i'" href="/up/'$file^'"><img src="/img/unsupported.png" class="responsive-img z-depth-1" alt="Download unsupported file" /><a></audio>'
%   if not if(~ $ext png || ~ $ext tif || ~ $ext tiff || ~ $ext wbmp || ~ $ext ico || ~ $ext jng || ~ $ext bmp || ~ $ext svg || ~ $ext svgz || ~ $ext webp || ~ $ext gif || ~ $ext jpeg || ~ $ext jpg || ~ $ext PNG || ~ $ext TIF || ~ $ext TIFF || ~ $ext WBMP || ~ $ext ICO || ~ $ext JNG || ~ $ext BMP || ~ $ext SVG || ~ $ext SVGZ || ~ $ext WEBP || ~ $ext GIF || ~ $ext JPEG || ~ $ext JPG)
%       echo '        <img id="'$i'" title="'$i'" src="/up/'$file^'" class="materialboxed responsive-img z-depth-1" data-caption="By '$user'" />'
%   if not if(~ $ext obj || ~ $ext OBJ)
%       echo '        <iframe id="'$i'" title="'$i'" class="thingiview" src="/up/thingiview.obj.html?file='$file'"><a id="'$i'" href="/up/'$file^'"><img src="/img/unsupported.png" class="responsive-img z-depth-1" alt="Download unsupported file" /><a></iframe>'
%   if not if(~ $ext stl || ~ $ext STL)
%       echo '        <iframe id="'$i'" title="'$i'" class="thingiview" src="/up/thingiview.stl.html?file='$file'"><a id="'$i'" href="/up/'$file^'"><img src="/img/unsupported.png" class="responsive-img z-depth-1" alt="Download unsupported file" /><a></iframe>'
%   if not
%       echo '        <a id="'$i'" title="'$i'" href="/up/'$file^'"><img src="/img/unsupported.png" class="responsive-img z-depth-1" alt="Download unsupported file" /><a>'
        <h5 class="center"><a href="/user/%($user%)"><img class="avatar" style="height: 1em; margin-right: 0.25em !important" src="https://secure.gravatar.com/avatar/%(`{cat etc/users/$user^/email | tr -d $NEW_LINE | md5sum}%)" /></a>By <a href="/user/%($user%)">%($user%)</a>
%   if(~ $user $logged_user) {
%       if(~ $ext png || ~ $ext tif || ~ $ext tiff || ~ $ext wbmp || ~ $ext ico || ~ $ext jng || ~ $ext bmp || ~ $ext svg || ~ $ext svgz || ~ $ext webp || ~ $ext gif || ~ $ext jpeg || ~ $ext jpg || ~ $ext PNG || ~ $ext TIF || ~ $ext TIFF || ~ $ext WBMP || ~ $ext ICO || ~ $ext JNG || ~ $ext BMP || ~ $ext SVG || ~ $ext SVGZ || ~ $ext WEBP || ~ $ext GIF || ~ $ext JPEG || ~ $ext JPG) {
        <form action="" method="post" style="display: inline"><button type="submit" name="uploads_watermark" value="%($file%)" title="Add watermark" class="btnLink waves-effect waves-light"><i class="material-icons">security</i></button></form>
%       }
        <form action="" method="post" style="display: inline"><button type="submit" name="uploads_delete" value="%($file%)" title="Delete" class="btnLink waves-effect waves-light"><i class="material-icons">delete</i></button></form>
%   }
%   if(! ~ $logged_user '') {
        <button title="Reply" onclick="document.getElementById('comment_text').value+='[@%($i%)](#%($i%))\n'; $('#comment_text').trigger('autoresize')" class="btnLink waves-effect waves-light scroll-bot"><i class="material-icons">reply</i></button>
%   }
        </h5>
    </div>
%   i=`{echo $i | awk 'echo $1++'}
% }
</div>
