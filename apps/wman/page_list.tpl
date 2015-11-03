% d=`{wman_get_section_desc $wman_cat} 
<h1>Manual pages - Section %($wman_cat%): %($"d%)</h1>

<ul style="float:left">
%{
wman_ls_pages $wman_cat_path \
    | awk -F/ '{ print "<li><a href=\""$(NF)"\">"$(NF)"</a></li>" }
    NR%20 == 0 { print "</ul><ul style=\"float: left\">" }'
%}
</ul>

