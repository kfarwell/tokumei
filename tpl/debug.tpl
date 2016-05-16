% if(! ~ $#debug_shell 0) {
<form method="POST" name="prompt">
<input size="80" type="text" name="command" value="%($"post_arg_command%)">
<input type="submit" Value="Run">
</form>
<script language="javascript"><!--
document.prompt.command.focus()
//--></script>

%{
fn evl {
    # Buffering is probably messing this up:
    #rc -c 'flag x +;{'^$post_arg_command'} |[2] awk ''{print ">> "$0}'''
    rc -c 'flag s +; flag x +;'^$post_arg_command
}
    if(! ~ $#post_arg_command 0 && ! ~ $#post_arg_command '') {
        echo '<hr><pre>'
        evl | escape_html |[2] awk '{print "<b>"$0"</b>"}' 
        echo '</pre>'
    }
%}
% }

<hr><pre>
% env | escape_html

% umask
</pre><hr>
