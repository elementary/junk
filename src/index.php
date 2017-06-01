<?php

/**
 * index.php
 * This file redirects any app to an appstream url or the elementary website
 * NOTE: it expects an app RDNN name as $_GET['app'] parameter
 */

$redirectUrl = 'https://elementary.io';

// We don't care about the protocol
$url = 'http://'.$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
$path = parse_url($url, PHP_URL_PATH);
$app = trim(end(explode('/', $path)));

if ($app == null || $app === '') {
  header('Location: '.$redirectUrl);
  exit();
}

if (substr($app, -8) !== '.desktop') {
  $app = $app . '.desktop';
}

if (substr_count($app, '.') < 3) {
  header('Location: '.$redirectUrl);
  exit();
}

?>

<!doctype html>
<html>
<head>
  <title>elementary AppCenter</title>

  <style>
    html,
    body {
      margin: 0;
      padding: 0;
    }

    main {
      -ms-flex-line-pack: center;
           align-content: center;
      -webkit-box-align: center;
         -ms-flex-align: center;
            align-items: center;
      display: -webkit-box;
      display: -ms-flexbox;
      display: flex;
      height: 100vh;
      -webkit-box-pack: center;
         -ms-flex-pack: center;
       justify-content: center;
      width: 100vw;
    }
  </style>
</head>
<body>
  <main>
    <img src="/appcenter.png" alt="appcenter"/>
  </main>

  <footer>
    <script>
      var isElementary = (navigator.userAgent.indexOf('elementary') !== -1)

      if (isElementary) {
        window.location = 'appstream://<?php echo $app ?>'
      } else {
        window.location = '<?php echo $redirectUrl ?>'
      }
    </script>
  </footer>
</body>
</html>
