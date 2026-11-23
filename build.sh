#!/usr/bin/env bash
# Baut index.html aus korbflieger.html (Artefakt-Form) und setzt den Cache-Namen im Service Worker.
set -e
cd "$(dirname "$0")"
VER=$(date +%Y%m%d-%H%M%S)
{
cat <<'HEAD'
<!doctype html>
<html lang="de">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover,user-scalable=no">
<title>Korbflieger</title>
<meta name="description" content="Mit dem Propellerball von oben durch jeden Korb. Swish-Serien, Sterne, neue Bälle.">
<meta name="theme-color" content="#2a1a4f">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="apple-mobile-web-app-title" content="Korbflieger">
<link rel="manifest" href="manifest.webmanifest">
<link rel="icon" href="icon-192.png" type="image/png">
<link rel="apple-touch-icon" href="apple-touch-icon.png">
<style>
[hidden]{display:none!important}
html,body{overscroll-behavior:none; -webkit-touch-callout:none}
body{
  padding-top:max(10px,env(safe-area-inset-top,0px))!important;
  padding-bottom:max(10px,env(safe-area-inset-bottom,0px))!important;
}
/* Installierte App auf dem Handy: randlos, nur Abstand für Statusleiste und Home-Balken */
@media (max-width:600px){
  body{padding:env(safe-area-inset-top,0px) 0 env(safe-area-inset-bottom,0px) 0!important}
  .stage{border-radius:0!important; box-shadow:none!important}
}
</style>
</head>
<body>
HEAD
grep -v '^<title>\|^<meta name="claude:viewport-fit-sides"' korbflieger.html
cat <<'TAIL'
<script>
if('serviceWorker' in navigator){ window.addEventListener('load',function(){ navigator.serviceWorker.register('sw.js').catch(function(){}); }); }
</script>
</body>
</html>
TAIL
} > index.html
sed -i "s/^const CACHE=.*/const CACHE='korbflieger-$VER';/" sw.js
echo "index.html gebaut, Cache korbflieger-$VER"
