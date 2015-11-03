<h1>Manual Sections</h1>

<ul style="text-transform: capitalize;">
% for(c in $wman_cat_list) {
    <li><a href="%($c%)/"><b>Section: %($c%)</b></a>
%   wman_get_section_desc $c 
%   if(~ $status '' '|')
%       echo '(<a href="'$c'/intro">intro</a>)'
    </li>
% }
</ul>
