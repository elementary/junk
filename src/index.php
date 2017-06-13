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

  <link rel="stylesheet" type="text/css" media="all" href="https://fonts.googleapis.com/css?family=Open+Sans:300">

  <style>
    @-webkit-keyframes fade {
      from {
        opacity: 0;
      }

      to {
        opacity: 1;
      }
    }

    @keyframes fade {
      from {
        opacity: 0;
      }

      to {
        opacity: 1;
      }
    }

    html,
    body {
      margin: 0;
      padding: 0;
    }

    h1 {
      -webkit-animation: 1s ease 2s 1 normal forwards running fade;
              animation: 1s ease 2s 1 normal forwards running fade;
      color: #333;
      font-family: "Open Sans", Helvetica, sans-serif;
      font-size: 26px;
      font-weight: 100;
      margin-top: 16px;
      opacity: 0;
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
      -webkit-box-orient: vertical;
      -webkit-box-direction: normal;
          -ms-flex-direction: column;
              flex-direction: column;
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
    <h1>Redirecting</h1>
  </main>

  <footer>
    <script>
      var title = document.getElementsByTagName('h1')[0]
      var userAgent = navigator.userAgent.toLowerCase()
      var isLinux = (userAgent.indexOf('linux') !== -1 || userAgent.indexOf('elementary') !== -1)

      if (isLinux) {
        title.innerHTML = 'Redirecting to AppCenter'
        window.location = 'appstream://<?php echo $app ?>'
      } else {
        title.innerHTML = 'Redirecting to elementary.io'
        window.location = '<?php echo $redirectUrl ?>'
      }
    </script>
  </footer>
</body>
</html>
