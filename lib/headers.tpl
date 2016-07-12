<!DOCTYPE HTML>
<html>
<head>

    <title>%($pageTitle%)</title>

    <link rel="stylesheet" href="/pub/style/materialize.min.css" media="screen,projection" />
    <link rel="stylesheet" href="/pub/style/materialdesignicons.min.css" media="screen, projection" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

    <link rel="stylesheet" href="/pub/style/style.css" type="text/css" media="screen, projection">
% if(test -f $sitedir/_werc/pub/style.css) {
    <link rel="stylesheet" href="/_werc/pub/style.css" type="text/css" media="screen, projection">
% }
    <noscript><link rel="stylesheet" href="/pub/style/noscript.css" type="text/css" media="screen, projection"></noscript>
    <link rel="stylesheet" type="text/css" media="screen, projection" id="webkit">
    <script>
        if(navigator.userAgent.indexOf("WebKit") != -1) {
            document.getElementById("webkit").href="/pub/style/webkit.css";
        }
    </script>
% if(! ~ `{get_cookie theme} '') {
    <link rel="stylesheet" href="/_werc/pub/%(`{get_cookie theme}%).css" type="text/css" media="screen, projection">
% }
% if(! ~ `{get_cookie css} '') {
    <link rel="stylesheet" href="/_werc/pub/custom/%(`{get_cookie css}%).css" type="text/css" media="screen, projection">
% }

    <link rel="shortcut icon" href="/favicon.ico" type="image/vnd.microsoft.icon">

    <meta charset="UTF-8">
% # Legacy charset declaration for backards compatibility with non-html5 browsers.
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

%{
if(~ $req_path /p/[0-9]*) {
  desc=`{cat $sitedir$req_path.txt}
  echo '    <meta name="description" content="'$"desc'">'
}
if not {
  if(! ~ $#meta_description 0)
    echo '    <meta name="description" content="'$"meta_description'">'
}

if(! ~ $#meta_keywords 0)
  echo '    <meta name="keywords" content="'$"meta_keywords'">'
%}

% h = `{get_lib_file headers.inc}
% if(! ~ $#h 0)
%   cat $h

    <link rel="sitemap" href="/sitemap.gz">

    <link rel="alternate" type="application/rss+xml" title="%($siteTitle%)" href="/rss">

    %($"extraHeaders%)

</head>
<body>

